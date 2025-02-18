.PHONY: terraform argocd-password chart

terraform:
	cd terraform && terraform init
	terraform apply --auto-approve

argocd-password:
	echo; kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo

chart:
	helm package helm/sample --destination helm/
	curl -X DELETE http://chartmuseum.homelab.msfidelis.com.br:80/api/charts/sample/0.1.0; 
	curl --data-binary "@helm/sample-0.1.0.tgz" http://chartmuseum.homelab.msfidelis.com.br:80/api/charts 

	helm package helm/windows --destination helm/
	curl -X DELETE http://chartmuseum.homelab.msfidelis.com.br:80/api/charts/windows/0.1.0;
	curl --data-binary "@helm/windows-0.1.0.tgz" http://chartmuseum.homelab.msfidelis.com.br:80/api/charts 
