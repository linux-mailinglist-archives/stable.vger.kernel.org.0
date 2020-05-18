Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F181D7BB7
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgEROqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:46:50 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:6120
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726989AbgEROqu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 10:46:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOZ/1KWRRgJsiRC9qzepmPTMLR8g3mrzyRmsH4iQvoRupPD1t63/lGcDf6tS9jrtmUmfTUJ9/v/1aHCN1vLCED+UG/X7fUMYIjNhImCLruB4azWGkGmsYX16cpXkA2Twxwyyc2bz9ktZfZ9ajNyMMHYK0Tn7qrRcyzrTQLvO+L9TanuVh+Fk6jCoMxxFurzwdwoHJUGhTrdMrJ5ndNzowt592Av9NUnl7Hwll0Z31aAHSIHFOjUb6HM4sT94fmJ/h9dLr4DF2Uog1uj6/NXVQraSOUQLs5e6U0jLK5iUfKeFjSXnK/2UOrKifLVnNHgnsj1ajeLKk26BqfbJrEeemg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+xgNzoC8m7A3/WkzwiHDWVGMnqlqGBH+XpGZ9LpJ3E=;
 b=HIB4iboaKxpxuSCHs80awxfXzunDO/1ljGcgVO319c+XLjMNAKFaHSWUVq4pMvmcUqTaYEbje8N4DTP2RDnnNd+7S8Mne5KOgz2Ev0hGhk/IncRBOvcJVZkG6gyHDJUbBB9fmphyHKLfxNBFakYLfUrbI1Ku/K0hzbD/5hTlcGps4hlIzJm0eEHP4pvtEHxbXCQUb/wrlg6O7Yo5vOd83IE/rU8r5NQI3HtLPrmZjFVzVuuZCuVn6Sbk6JTi4VbPPUkSNBPURv5TDkrGTh9NHj015bXDq/EXAMRFwygtMX2bjbFrYCk2SOOtOa/H9yNrqalMyqtDTKNXSSz9KzrWgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+xgNzoC8m7A3/WkzwiHDWVGMnqlqGBH+XpGZ9LpJ3E=;
 b=PnNSGtkkvDF0fa2f2DSjUmhtUyaZGzTggC4dfvzThUQ2RcSe/dr7dsMMZbxwRmdQdOCniAxmgQ7UYzfkSbU8sg/KVsh1/o0bSI7hXokECCG77EdH0cUR+4tQojr9ao146xrVRMBc+cn772HKq9zl1x18xEAoYBnNVzWAcwB0W4s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 14:46:45 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::c0f:2938:784f:ed8d%7]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 14:46:45 +0000
Subject: RE: FAILED: patch "[PATCH] KVM: x86: Fix pkru save/restore when guest
 CR4.PKE=0, move it" failed to apply to 5.4-stable tree
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <158980917424929@kroah.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <12fc0ba0-dc72-11cb-5e9f-e34a7c561bf3@amd.com>
Date:   Mon, 18 May 2020 09:46:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <158980917424929@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0033.namprd21.prod.outlook.com
 (2603:10b6:3:ed::19) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.87] (165.204.77.1) by DM5PR21CA0033.namprd21.prod.outlook.com (2603:10b6:3:ed::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.5 via Frontend Transport; Mon, 18 May 2020 14:46:45 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93f7cc96-7d19-4edb-1268-08d7fb3a496a
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2541AB639590099A0292EC6095B80@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPr8xqJ65bzf4I5npRLA/k1SybpBkZH9T6A2p7sZ/Uwq84G+Q0qdAiOfA4zxjOv4O1NGxIC5Aawz8Dl1x8W1T96LVWFuEOfJNquXzECWj/R+P6TwtY/1xBs9ukRR2C4jSCfWLlJzepdJvue6N63XiK9GUCpCjcKYCGxQK9SihHa9ixP6QPOM+2rEVw8T3TEeb12J1GRxHYvoKdb39ie8EHOj4RX2a9Iyr69y0uWcmlUfOC8MBgcw7KVtRMHXYllGSMsPVzC9EdMvakWA9HKF3ZIWMIdQLzOAaqxt6czOSScjCw725EC/q1TEx9xpF/fDTU/FmxsLEh9O4ejeOUXoimOdMndLoeCXP7ISdMcONlgr4AcPrl/ooLTxw4goAy5JqR3o8Yh/+5NmHnuy04hla+fztuz4yeeY0gI/MO0xsSh/O9v7tTsywtARTSe5hOusTsw/eRNsHYOSltfsv7TZ5a0EOndY9LURPCvTBHUyj5/JBnf7k8IWbQNMrkxc3vpn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(956004)(2616005)(44832011)(5660300002)(6486002)(8676002)(8936002)(4326008)(52116002)(66476007)(16526019)(53546011)(66556008)(186003)(66946007)(26005)(36756003)(16576012)(110136005)(31686004)(478600001)(31696002)(316002)(2906002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bSAmrT4FotGj6sqFRcI8JVMoBKWbuZksSv5A1uyobn4omMDEXEx2gmx4Lh1bp6rgLKpnRPHaYva1bEl8fCDNse3XatZEmvcOhq+yQqDM254ShrKq3Q8d11hhYTmoW0CUw8wx81ju2Gj98f6i1LplYXFKGnP4H1k8/AHbgjt9jxvz9sj3kfiZmF+iCVz0afeelMcQTrYYafEABmKVYPEKrULInoob82UMFL0i78OTDVu1HzU6z3zyCaVxedrRq9W5KLTN3PFJUMiR9WwKBrlekBwaMwQLvlNruQVZX6DuNBL/Ta/KJ5mmGmDcz6usfa857hOLyk2smoUo9TF2A7Y+BtffsxQz9Gyi9ke82V5hbw9yB+AFt+P8pgG68kfffVOU7D7sEsyNMb3Ajx80G1wxjVJ8v6uCd8tuA2O4Yke4ha+bBF1rFGi97Vc9Ox2tgAtDWB6Jr7IXpDNPQKcyjmNRHv10mtfDPma/bwswfCdxsPc=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f7cc96-7d19-4edb-1268-08d7fb3a496a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 14:46:45.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTZHL2pqgOCJu4S4zCREpCnvYbglX9lg7yIVMLihFJhqaPCqMg+HlYMwM3aGpPbX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jim, Paolo,
Do you guys want me to take care of this? Let me know.
Thanks
Babu

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Monday, May 18, 2020 8:40 AM
> To: Moger, Babu <Babu.Moger@amd.com>; jmattson@google.com;
> pbonzini@redhat.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] KVM: x86: Fix pkru save/restore when guest
> CR4.PKE=0, move it" failed to apply to 5.4-stable tree
> 
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 37486135d3a7b03acc7755b63627a130437f066a Mon Sep 17 00:00:00
> 2001
> From: Babu Moger <babu.moger@amd.com>
> Date: Tue, 12 May 2020 18:59:06 -0500
> Subject: [PATCH] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move
> it
>  to x86.c
> 
> Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
> resource isn't. It can be read with XSAVE and written with XRSTOR.
> So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
> the guest can read the host value.
> 
> In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
> potentially use XRSTOR to change the host PKRU value.
> 
> While at it, move pkru state save/restore to common code and the
> host_pkru field to kvm_vcpu_arch.  This will let SVM support protection keys.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> Message-Id: <158932794619.44260.14508381096663848853.stgit@naples-
> babu.amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/include/asm/kvm_host.h
> b/arch/x86/include/asm/kvm_host.h
> index 9e8263b1e6fe..0a6b35353fc7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -578,6 +578,7 @@ struct kvm_vcpu_arch {
>  	unsigned long cr4;
>  	unsigned long cr4_guest_owned_bits;
>  	unsigned long cr8;
> +	u32 host_pkru;
>  	u32 pkru;
>  	u32 hflags;
>  	u64 efer;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e45cf89c5821..89c766fad889 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1372,7 +1372,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> 
>  	vmx_vcpu_pi_load(vcpu, cpu);
> 
> -	vmx->host_pkru = read_pkru();
>  	vmx->host_debugctlmsr = get_debugctlmsr();
>  }
> 
> @@ -6564,11 +6563,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> 
>  	kvm_load_guest_xsave_state(vcpu);
> 
> -	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
> -	    vcpu->arch.pkru != vmx->host_pkru)
> -		__write_pkru(vcpu->arch.pkru);
> -
>  	pt_guest_enter(vmx);
> 
>  	if (vcpu_to_pmu(vcpu)->version)
> @@ -6658,18 +6652,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> 
>  	pt_guest_exit(vmx);
> 
> -	/*
> -	 * eager fpu is enabled if PKEY is supported and CR4 is switched
> -	 * back on host, so it is safe to read guest PKRU from current
> -	 * XSAVE.
> -	 */
> -	if (static_cpu_has(X86_FEATURE_PKU) &&
> -	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
> -		vcpu->arch.pkru = rdpkru();
> -		if (vcpu->arch.pkru != vmx->host_pkru)
> -			__write_pkru(vmx->host_pkru);
> -	}
> -
>  	kvm_load_host_xsave_state(vcpu);
> 
>  	vmx->nested.nested_run_pending = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 98176b80c481..d11eba8b85c6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -837,11 +837,25 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu
> *vcpu)
>  		    vcpu->arch.ia32_xss != host_xss)
>  			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
>  	}
> +
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> +	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
> +	    vcpu->arch.pkru != vcpu->arch.host_pkru)
> +		__write_pkru(vcpu->arch.pkru);
>  }
>  EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
> 
>  void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>  {
> +	if (static_cpu_has(X86_FEATURE_PKU) &&
> +	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
> +	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
> +		vcpu->arch.pkru = rdpkru();
> +		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
> +			__write_pkru(vcpu->arch.host_pkru);
> +	}
> +
>  	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
> 
>  		if (vcpu->arch.xcr0 != host_xcr0)
> @@ -3549,6 +3563,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int
> cpu)
> 
>  	kvm_x86_ops.vcpu_load(vcpu, cpu);
> 
> +	/* Save host pkru register if supported */
> +	vcpu->arch.host_pkru = read_pkru();
> +
>  	/* Apply any externally detected TSC adjustments (due to suspend) */
>  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
>  		adjust_tsc_offset_host(vcpu, vcpu-
> >arch.tsc_offset_adjustment);

