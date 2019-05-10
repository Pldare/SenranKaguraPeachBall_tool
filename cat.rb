# Senran Kagura: Peach Ball - .cat file
# reference:RandomTBush`s project RTB-QuickBMS-Scripts/Decompression/SenranKaguraPeachBall_CAT_TZP.bms
# Written ruby code by lisomn
require 'find'
def long
	return $cat_file.read(4).unpack("V").join.to_i
end
def file_arr(_count)
	_tmp_i=[0]
	for i in 0..(_count-1)
		_tmp_i[i]=long
	end
	return _tmp_i
end
def goto(_off)
	$cat_file.seek(_off)
end
def get_last_name(_type)
	case _type
	when 0
		$name_last=".cat"
		$type=1
	when 811887988
		$name_last=".tmd"
		$type=0
	when 5527623
		$name_last=".gxt"
		$type=0
	when 1481920066
		$name_last=".bntx"
		$type=0
	when 1
		$name_last=".cats"
		$type=1
	else
		$name_last=".dat"
		$type=1
	end
end
def save_file_core(_folder,_file_name,_offset,_size)
	save_wz=_folder+"/"+_file_name
	if _folder == " "
		save_wz=_file_name.to_s
	else
		if File.directory?(_folder)
		else
			Dir.mkdir(_folder)
		end
	end
	if FileTest::exists?(save_wz)
		puts "The #{_file_name} already exists"
	else
		_mq_wz=$cat_file.pos
		goto(_offset)
		#puts "save #{_file_name}"
		#_i=File.open(_url,"rb")
		_ii=File.open(save_wz,"wb")
		_ii.print $cat_file.read(_size)
		_ii.close
		#_i.close
		goto(_mq_wz)
		puts "save #{_folder+"/"+_file_name}"
	end
end
def pd_str_name(_strrr)
	pp=[0]
	for i in 0..(_strrr-1)
		tmo_pp=$cat_file.read(1)
		if (tmo_pp.unpack("C").join.to_i) == 44
			break
		end
		pp[i]=tmo_pp.to_s
	end
	return pp.join.to_s
end
def cat_core(_file_name)
	$file_name=_file_name#ARGV[0]#"acce_arm00_00.cat"
	$cat_file=File.open($file_name,"rb")

	$name_last=""
	$type=0#0复数类文件 1最终文件
	$tmp_wz=0
	$globe=0
	$tmp_name=""
	$name_file_block=0

	$type_list=[0]
	$type_i=0#记录次数
	$name_list=[0]

	$base_name=$file_name.split(".")[0].to_s
	if $roundesss == 0
		$org_base_folder=$base_name
		if File.directory?($org_base_folder)
		else
			Dir.mkdir($org_base_folder)
		end
	end
	unk1,files1,unk2=long,long,long
	file_offset1,file_size1=file_arr(files1),file_arr(files1)
	for i in 0..(files1-1)
		goto(file_offset1[i])
		unk3,files2,unk5,unk6,unk7=long,long,long,long,long
		file_offset2,file_size2=file_arr(files2),file_arr(files2)
		for ii in 0..(files2-1)
			puts "------------------------------"
			$tmp_wz=(file_offset2[ii].to_i)+(file_offset1[i].to_i)
			goto($tmp_wz)
			file_header=long
			get_last_name(file_header)
			if (files2-1) > 0
				print $base_name,"/",$base_name,ii,$name_last,"\n"
				floder=" "#$org_base_folder#$out_folder_path#"out_data"#$base_name
				file_name=$base_name+"_"+($globe.to_s)+$name_last
				if (file_size2[ii].to_i) < 32
					goto($tmp_wz)
					$tmp_name=pd_str_name(file_size2[ii])
					puts "#{file_name} found string #{$tmp_name}"
					#save_file_core(floder,$tmp_name,$)
					$name_file_block=1
				else
					if $name_file_block == 1
						$name_list[$type_i]=file_name
						file_name=$tmp_name+$name_last
						print "rename ",$base_name,ii,$name_last,"=>",$tmp_name,$name_last,"\n"
						$type=0#类型:存储文件名称
						$type_list[$type_i]=$type
						$type_i+=1
						floder=$org_base_folder
					end
					get_last_name(file_header)
					save_file_core(floder,file_name,$tmp_wz,file_size2[ii])
					$name_list[$type_i]=file_name
					$name_file_block=0
					$type_list[$type_i]=$type
					$type_i+=1
				end
			end
			$globe+=1
		end
	end
	$cat_file.close
	if $roundesss == 0
		File.rename($file_name,$base_name+".bak")
	else
		File.delete($file_name)
	end
	print $type_list,"\n",$name_list,"\n"
	#print $org_base_folder
end
$roundesss=0
#org_file_name=ARGV[0]
$stop_lock=0
#path
$out_folder_path="data"
loop do
	name_list2=[0]
	name_list2_i=0
	#name_zt=[0]#已经删除为1未删除未0
	Find.find("data") do |path|
		if File::directory?(path)
		else
			name_list2[name_list2_i]=path
			name_list2_i+=1
		end
	end
	$stop_lock=0
	print "list => ",name_list2,"\n"
	for i in 0..name_list2_i
		_tmp_file_name=name_list2[i]
		if /.cat/ =~ _tmp_file_name
			if FileTest::exists?(_tmp_file_name)
				cat_core(_tmp_file_name)
				$stop_lock+=1
			end
			#$stop_lock+=1
		end
		if /.cats/ =~ _tmp_file_name
			if FileTest::exists?(_tmp_file_name)
				cat_core(_tmp_file_name)
				$stop_lock+=1
			end
		end
		if /.dat/ =~ _tmp_file_name
			if FileTest::exists?(_tmp_file_name)
				cat_core(_tmp_file_name)
				$stop_lock+=1
			end
			#$stop_lock+=1
		end
	end
	if $stop_lock == 0
		print "done!"
		break
	end
	$roundesss+=1
end
