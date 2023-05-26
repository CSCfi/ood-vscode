%define app_path /www/ood/apps/sys/

Name:           ood-vscode
Version:        2
Release:        1%{?dist}
Summary:        Open on Demand vscode

BuildArch:      noarch

License:        MIT
Source:         %{name}-%{version}.tar.bz2

Requires:       ondemand
Requires:       ood-util
Requires:       ood-initializers

# Disable debuginfo
%global debug_package %{nil}

%description
Open on Demand vscode

%prep
%setup -q

%build

%install

%__install -m 0755 -d %{buildroot}%{_localstatedir}%{app_path}%{name}/template
%__install -m 0755 -D template/* %{buildroot}%{_localstatedir}%{app_path}%{name}/template
%__install -m 0644 manifest.yml *.erb icon.png README.md LICENSE %{buildroot}%{_localstatedir}%{app_path}%{name}/
echo %{version}-%{release} > %{buildroot}%{_localstatedir}%{app_path}%{name}/VERSION

%files

%{_localstatedir}%{app_path}%{name}

%changelog
* Thu Feb 23 2023 Sami Ilvonen <sami.ilvonen@csc.fi>
- Initial version
