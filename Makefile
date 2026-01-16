.PHONY: terraform argocd-password chart

terraform:
	cd terraform && terraform init
	terraform apply --auto-approve

argocd-password:
	echo; kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo

chart:
	helm package helm/sample --destination helm/
	curl -X DELETE https://chartmuseum.homelab.fidelissauro.dev:443/api/charts/sample/0.1.0; echo 
	curl --data-binary "@helm/sample-0.1.0.tgz" https://chartmuseum.homelab.fidelissauro.dev:443/api/charts ; echo 

	helm package helm/windows --destination helm/
	curl -X DELETE https://chartmuseum.homelab.fidelissauro.dev:443/api/charts/windows/0.1.0; echo 
	curl --data-binary "@helm/windows-0.1.0.tgz" https://chartmuseum.homelab.fidelissauro.dev:443/api/charts ; echo	
