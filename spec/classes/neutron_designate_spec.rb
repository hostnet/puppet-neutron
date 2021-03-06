require 'spec_helper'

describe 'neutron::designate' do
  let :req_params do
    { :password => 'secret',
      :url      => 'http://ip/designate' }
  end

  shared_examples 'neutron designate' do
    context 'with default parameters' do
      let :params do
        req_params
      end

      it 'configures designate in neutron.conf' do
        should contain_neutron_config('DEFAULT/external_dns_driver').with_value('designate')
        should contain_neutron_config('designate/url').with_value('http://ip/designate')
        should contain_neutron_config('designate/password').with_value('secret')
        should contain_neutron_config('designate/username').with_value('neutron')
        should contain_neutron_config('designate/auth_type').with_value('password')
        should contain_neutron_config('designate/project_name').with_value('services')
      end
    end

    context 'with provided parameters' do
      let :params do
        req_params.merge!({
          :auth_type                 => 'token',
          :username                  => 'user',
          :project_id                => 'id1',
          :project_name              => 'proj',
          :project_domain_id         => 'domain1',
          :project_domain_name       => 'Domain1',
          :user_domain_id            => 'domain2',
          :user_domain_name          => 'Domain2',
          :auth_url                  => 'http://auth/',
          :allow_reverse_dns_lookup  => false,
          :ipv4_ptr_zone_prefix_size => 765,
          :ipv6_ptr_zone_prefix_size => 876,
          :ptr_zone_email            => 'foo@example.com'
        })
      end

      it 'configures designate in neutron.conf' do
        should contain_neutron_config('DEFAULT/external_dns_driver').with_value('designate')
        should contain_neutron_config('designate/url').with_value('http://ip/designate')
        should contain_neutron_config('designate/password').with_value('secret')
        should contain_neutron_config('designate/username').with_value('user')
        should contain_neutron_config('designate/auth_type').with_value('token')
        should contain_neutron_config('designate/project_id').with_value('id1')
        should contain_neutron_config('designate/project_name').with_value('proj')
        should contain_neutron_config('designate/project_domain_id').with_value('domain1')
        should contain_neutron_config('designate/project_domain_name').with_value('Domain1')
        should contain_neutron_config('designate/user_domain_id').with_value('domain2')
        should contain_neutron_config('designate/user_domain_name').with_value('Domain2')
        should contain_neutron_config('designate/auth_url').with_value('http://auth/')
        should contain_neutron_config('designate/allow_reverse_dns_lookup').with_value(false)
        should contain_neutron_config('designate/ipv4_ptr_zone_prefix_size').with_value(765)
        should contain_neutron_config('designate/ipv6_ptr_zone_prefix_size').with_value(876)
        should contain_neutron_config('designate/ptr_zone_email').with_value('foo@example.com')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'neutron designate'
    end
  end
end
