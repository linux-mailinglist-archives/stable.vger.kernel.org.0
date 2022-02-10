Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6636D4B1337
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbiBJQmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:42:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244597AbiBJQma (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:42:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06BDBF24
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFYbvPlaBCYjn1T1X1uUdnxkO0hSwtQKlrbztUTQuqo=;
        b=PoRf1898gaaSuPfJzLywxDAbQBtM+dI6Ww1iHBz0KV8oLEKEaIygOx5MIqoQi/LiDZCBmP
        phaL2LPNRL41zdu8D79taFmBYh9a18d6isot+02wsXa0Ba5x2kiIN7lxAWfP0gUlw+B5Ei
        j3tlGJLCXBI1C39FRm9B3HsLS1/9Vdk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-8eJJmmcAMZuJu7z07G5fDA-1; Thu, 10 Feb 2022 11:42:08 -0500
X-MC-Unique: 8eJJmmcAMZuJu7z07G5fDA-1
Received: by mail-ed1-f70.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso3674302edv.12
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RFYbvPlaBCYjn1T1X1uUdnxkO0hSwtQKlrbztUTQuqo=;
        b=G1uvfpKM117vaOT4fuRoAWu5+5y/dYcdfuhudOsaSxHkaqf5G25IFvuXJVQTwBoOpo
         lFl+udObmh3efqGJcARDc76t2HLoG5atXxJUoKomu41MgRB/jdBuE6DAlNlxT7u2MM0a
         PzSkGqtAhWuAPu6oLX36pBFtsNFV5v+wFamp1gO800qclhfgbo8LhBDuhFmootOzS9xd
         kMuiVlNST8wcfwv4awI/kmKHIKgdz5BGExbSR3qWhctqNMUFAzhbwONk9EmAaPWLkJ1s
         TkpJOc/A+Ks5kMdR2z1EmLBtLHKqMMYwH6KADJ6RMWj8WYO76mTfFA9LXSkbwo1g+L93
         Cc9A==
X-Gm-Message-State: AOAM531Lm6ZMdqP8PMZLKmUbPr+kTgN97JSFdADBCzwxCe+KU1xi7VsM
        XLqZkTyd46tTYLmARImXlX50ez03J26sRTcC0qCFBO3Dgo350kmSw3P6SKmDrey/kGEhniIx1BA
        Qy+AcrSPWQz9Gr5lx
X-Received: by 2002:a05:6402:1488:: with SMTP id e8mr9445732edv.456.1644511327595;
        Thu, 10 Feb 2022 08:42:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxci+g4KdlhQJdPQsHLDQyganMyA0JZJT4R8y9CBHPnperKe1p+kKa70UagPWCt1bMc0BN2Q==
X-Received: by 2002:a05:6402:1488:: with SMTP id e8mr9445705edv.456.1644511327370;
        Thu, 10 Feb 2022 08:42:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j2sm7138173ejc.223.2022.02.10.08.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:42:06 -0800 (PST)
Message-ID: <0ed5a95c-39d7-1139-4234-83b1857504b4@redhat.com>
Date:   Thu, 10 Feb 2022 17:41:48 +0100
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

