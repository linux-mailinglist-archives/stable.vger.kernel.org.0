Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C002F4B131D
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbiBJQkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:40:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiBJQkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:40:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F189397
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=30EUFe9ZMAk2o8E42dYwy3LHUtkFtK7cdn4oOH+aiTc=;
        b=DeaeIRyMVb4mRSZFRQOerGdutbeSlgUpoRYm+Ha6l/6o2f5Rg8Eernc0eBt8W6Ytz95QLa
        T78/EZijMj+pdfuYRjiq8AFm3iNwy6APf1+HjYkcKrSyYi70GPkiGDYGFTavK1wLG/iuXV
        EG5SKvrShJbuYWDb4fd6r4BZdH+8m8Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-RHYCxRA5NT6Psg8sVaXfKw-1; Thu, 10 Feb 2022 11:40:48 -0500
X-MC-Unique: RHYCxRA5NT6Psg8sVaXfKw-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a056402354900b0040fb9c35a02so3657942edd.18
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=30EUFe9ZMAk2o8E42dYwy3LHUtkFtK7cdn4oOH+aiTc=;
        b=0q/MXVYPciZBR5li4s3AmIoStJc/YUeU+VwHtb+6lL5ihaEchKJ3immBNAhIsHZXso
         3BODaOGzdKPTajIQ/YrwNUZkznmRmeA8dc+MWpSpAt5SjUWwtNjbaoyYLTphOUl5BM1L
         shvynbivtjYqgHGMUBEk8davfFAWRchJYxv/fOcSZM8/3wjgUReW+AZjY5n8d6CU1Zey
         LQDea/Km/qsFXsgTih8FpB4kzS+LgzQb9D93k8MPeyXEESgNWx7joRMLA7SgjW1ekkaU
         7Vmmv7DJcrGb5ByEJ42yMZYcs64DbvWCShOVYauouvqA/EUepGLu3Uqj5EU1JciCUSrp
         H0BA==
X-Gm-Message-State: AOAM530+7eHUtQpt3hbiBAW1t5wr3Nbyj6BeYhQXeI2jz2LV0KIsijtQ
        Y3D/aSFMsiQ6O3Zru1Dcb96LzXMzQ3R1MgpP1ukKYMSdm7AiiyAQkhNDKSi4NMOUowuTmXJvACB
        /Uq8gLlordmWIVtoM
X-Received: by 2002:a17:906:99c6:: with SMTP id s6mr7547459ejn.522.1644511246918;
        Thu, 10 Feb 2022 08:40:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYRgarg4MQSjsf/6d2XAuFlbPg+lsO2UEU8IjFLj5NbFvJtES92CmW7ZnePV8UnC/mde0BEg==
X-Received: by 2002:a17:906:99c6:: with SMTP id s6mr7547437ejn.522.1644511246686;
        Thu, 10 Feb 2022 08:40:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id i9sm8367958eda.35.2022.02.10.08.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:46 -0800 (PST)
Message-ID: <98254cb1-cb10-ddfe-7ea7-ae71d9f63316@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 5/6] KVM: SVM: Don't kill SEV guest if SMAP
 erratum triggers in usermode
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185714.48936-1-sashal@kernel.org>
 <20220209185714.48936-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185714.48936-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/22 19:57, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit cdf85e0c5dc766fc7fc779466280e454a6d04f87 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> 
> Inject a #GP instead of synthesizing triple fault to try to avoid killing
> the guest if emulation of an SEV guest fails due to encountering the SMAP
> erratum.  The injected #GP may still be fatal to the guest, e.g. if the
> userspace process is providing critical functionality, but KVM should
> make every attempt to keep the guest alive.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Message-Id: <20220120010719.711476-10-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fa543c355fbdb..d515c8e68314c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4155,7 +4155,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   			return true;
>   
>   		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
> -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
> +		/*
> +		 * If the fault occurred in userspace, arbitrarily inject #GP
> +		 * to avoid killing the guest and to hopefully avoid confusing
> +		 * the guest kernel too much, e.g. injecting #PF would not be
> +		 * coherent with respect to the guest's page tables.  Request
> +		 * triple fault if the fault occurred in the kernel as there's
> +		 * no fault that KVM can inject without confusing the guest.
> +		 * In practice, the triple fault is moot as no sane SEV kernel
> +		 * will execute from user memory while also running with SMAP=1.
> +		 */
> +		if (is_user)
> +			kvm_inject_gp(vcpu, 0);
> +		else
> +			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   	}
>   
>   	return false;

