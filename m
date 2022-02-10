Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C94B12F5
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244347AbiBJQhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:37:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244344AbiBJQhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:37:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91779C2A
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5WySc1RlGnG8P3T39mlzj8E39X8bwgB3Tm12/xbTZl0=;
        b=NId7yE6aA04Yiy24UCJluPWxQFM7DwUrXoDXtJn9vH8ls4N5NiucVb/k5A/z4+nyc76iWD
        gGO65vEAgoZWNTDpfJSMEn5/8RNIC8coP95fLTcbrDJu6InGomKkbmI1FLjyCHT9rIvclX
        bVmExAr3bNEXIKXO6Ji8G7LiiM1A9gE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-6zhEOViuNsyRYam8Mc2NdA-1; Thu, 10 Feb 2022 11:36:59 -0500
X-MC-Unique: 6zhEOViuNsyRYam8Mc2NdA-1
Received: by mail-ej1-f71.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso3001672ejj.4
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:36:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5WySc1RlGnG8P3T39mlzj8E39X8bwgB3Tm12/xbTZl0=;
        b=2T/h+3JboWYIaJT/J7cdl1+Pn83pYLtG3Gdlbo/cT15X0Jzq8D1PFK3KNEDon31J1e
         tDzMjKAjFQUv0ri9NwShRNlDaUMou7iX9Eicg0X6t2fLue8c0RhMQ3KYgYDGCvl84JFU
         BRY0QCIEzY/oGaOGz5CrXQcTfA0YwzKSJAcizvcpeZDRR8CIn6uAQOvIWxGgVEVI8Qua
         brOf7syTBg+F6/NsbBM7xzTW5dVkxAkUdKORL6wH+n/GG2yKE3Dmrw5/ldIOHu4taNqv
         l/v9JsaCOu1eYm3Qnl95gln+bHQqhdMiwWbp2jmf9UMCPHRl7ac45u6YoXxUigP1rRfU
         xe8g==
X-Gm-Message-State: AOAM530+qZLLQ68HOgKwbGyFVWY6NK4H1fxZivImEKwL+sGwMy1SklUK
        ng1ML2lgxCx/1Fk7/lHzb1q/c42LO/Tx6HF0EPYydIqTRayy0JgpnwrtyP1Q4JRPOKYxJzPJjEo
        OcbuOuFgGnhgRmVax
X-Received: by 2002:a17:906:73ce:: with SMTP id n14mr6827050ejl.312.1644511018363;
        Thu, 10 Feb 2022 08:36:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDLWA297hpVfTcfKzBU3jAjpUisYVnV/ULWs53msCQUuZNZ+de98gW+3zY9Ew60sUlgr8XXw==
X-Received: by 2002:a17:906:73ce:: with SMTP id n14mr6827032ejl.312.1644511018158;
        Thu, 10 Feb 2022 08:36:58 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.240])
        by smtp.googlemail.com with ESMTPSA id m17sm8783672edr.62.2022.02.10.08.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:36:57 -0800 (PST)
Message-ID: <042c4562-3eb8-f141-a363-67ec1def8e2c@redhat.com>
Date:   Thu, 10 Feb 2022 17:33:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 5/8] KVM: SVM: Don't kill SEV guest if SMAP
 erratum triggers in usermode
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
 <20220209185635.48730-5-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-5-sashal@kernel.org>
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

On 2/9/22 19:56, Sasha Levin wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> [ Upstream commit cdf85e0c5dc766fc7fc779466280e454a6d04f87 ]
> 
> Inject a #GP instead of synthesizing triple fault to try to avoid killing
> the guest if emulation of an SEV guest fails due to encountering the SMAP
> erratum.  The injected #GP may still be fatal to the guest, e.g. if the
> userspace process is providing critical functionality, but KVM should
> make every attempt to keep the guest alive.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

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
> index 3efada37272c0..d6a4acaa65742 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4530,7 +4530,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	is_user = svm_get_cpl(vcpu) == 3;
>   	if (smap && (!smep || is_user)) {
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

