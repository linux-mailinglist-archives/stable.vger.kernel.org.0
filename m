Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD154B134B
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiBJQn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:43:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244625AbiBJQml (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:42:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 459B9F3E
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYrtoAjfH9TWpwEYLvzJDdywJWU9b7QnIIQHiQGQztM=;
        b=Dge1fFu1vvvC7BM7i6zhYbu+E9ZKagznLKo6+HLhAOPDPBuII4/PrQhhtwINuddnZ7vu25
        4c7jenEMjPX8ILBreHxiXYBan6VK8LA110afHCo/9ZjuMNCqJnXvtsnpyGJS2KpS/XtUAQ
        tIrzrPAKIDv+QUrgxyYqv0gSPa+n9Qw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-Vxie_kIXODKtEikcr_-4lA-1; Thu, 10 Feb 2022 11:42:25 -0500
X-MC-Unique: Vxie_kIXODKtEikcr_-4lA-1
Received: by mail-ed1-f71.google.com with SMTP id u24-20020a50d518000000b0040f8cef2463so3639000edi.21
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GYrtoAjfH9TWpwEYLvzJDdywJWU9b7QnIIQHiQGQztM=;
        b=Z1yYJQTFCHAZeTQF3YzYKplwBaiOgSK2Cjx/oK9IHxlZ/HjNlI2yOyyCbO3cWePqfl
         rs5CTaz2+stBmm013mFc4xrN2irhUA06drfeyBW7RzR8jzXGyqVFFUb6vNagRHQESrLa
         +okiqLlpHrBC+fKJhtXbAOS2WJodaEZaGTRQX8WKMrCUa2IRK2kovr3cUXqzdzejjtU6
         jHIH3e91079Q266ML0t7DxAK2l012iW5y65BHCm8lJH0u8rKi8Il/KrOkbjYorfjKOqG
         Y2Pn88CN25btJHm6XDmyTvSi6sbb8GWWq45x5EDyduieOixqmQbOtn3sjHSC+ShnJpOZ
         0ZbA==
X-Gm-Message-State: AOAM532YQ0tLxtl4W/v0VTle6hzZPrzXfo3A/xn3SBGQq9BjYKiyQ0Cu
        ICOnKCJm//SqOb7TLpfflMFG17ABey09vxEblFDkmJPqd2O81t8catlfPBronh5S2i+0e4x8pvK
        AGdhPlCxbLwqhIJrF
X-Received: by 2002:a50:e701:: with SMTP id a1mr9130578edn.110.1644511344250;
        Thu, 10 Feb 2022 08:42:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxl1HCOR1GQW8ptvL34wfWqIQQvxidnniyiZo5rnQiYNTjgkAWVn6Z+VMIXPN/nVqdPNe8hRQ==
X-Received: by 2002:a50:e701:: with SMTP id a1mr9130562edn.110.1644511344025;
        Thu, 10 Feb 2022 08:42:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id da9sm6736003edb.1.2022.02.10.08.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:42:23 -0800 (PST)
Message-ID: <1d8e2504-8e45-41af-c63a-87037b04f407@redhat.com>
Date:   Thu, 10 Feb 2022 17:42:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 6/8] KVM: SVM: Explicitly require
 DECODEASSISTS to enable SEV support
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-6-sashal@kernel.org>
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
> [ Upstream commit c532f2903b69b775d27016511fbe29a14a098f95 ]
> 
> Add a sanity check on DECODEASSIST being support if SEV is supported, as
> KVM cannot read guest private memory and thus relies on the CPU to
> provide the instruction byte stream on #NPF for emulation.  The intent of
> the check is to document the dependency, it should never fail in practice
> as producing hardware that supports SEV but not DECODEASSISTS would be
> non-sensical.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Message-Id: <20220120010719.711476-5-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/sev.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 134c4ea5e6ad8..d006eeb1d0321 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1887,8 +1887,13 @@ void __init sev_hardware_setup(void)
>   	if (!sev_enabled || !npt_enabled)
>   		goto out;
>   
> -	/* Does the CPU support SEV? */
> -	if (!boot_cpu_has(X86_FEATURE_SEV))
> +	/*
> +	 * SEV must obviously be supported in hardware.  Sanity check that the
> +	 * CPU supports decode assists, which is mandatory for SEV guests to
> +	 * support instruction emulation.
> +	 */
> +	if (!boot_cpu_has(X86_FEATURE_SEV) ||
> +	    WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_DECODEASSISTS)))
>   		goto out;
>   
>   	/* Retrieve SEV CPUID information */

NACK

