NEWLINE=UNIX

raw:
	curl -sSL https://umbrella-static.s3.amazonaws.com/top-1m.csv.zip | gunzip | awk -F, '{print $$2}' > top-1m.txt
	sed -i 's/\r//' top-1m.txt

	curl -sSL https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf | sed -e 's|^server=/\(.*\)/114.114.114.114$$|\1|' > raw-cn.txt

	grep -Fx -f raw-cn.txt top-1m.txt > top-cn.txt

	sed -e 's/^/.&/g' top-cn.txt > cn.txt

	sed -e "{s/^/  - '+.&/g;s/$$/'&/g}" top-cn.txt > cn.yaml
	sed -i '1i\payload:' cn.yaml

	curl -sSL https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt | sed 's/^||//' | sed 's/\^//' > raw-ad.txt

	grep -Fx -f raw-ad.txt top-1m.txt > top-ad.txt

	sed -e 's/^/.&/g' top-ad.txt > ad.txt

	sed -e "{s/^/  - '+.&/g;s/$$/'&/g}" top-ad.txt > ad.yaml
	sed -i '1i\payload:' ad.yaml

	rm -f raw* top* easy* filter*
