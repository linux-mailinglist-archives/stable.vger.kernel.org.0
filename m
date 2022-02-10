Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849194B132E
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbiBJQlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:41:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238972AbiBJQlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:41:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F95DE94
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0l/m87uQUmT5CdzB+3f+eMwCEX3CAuEYEJDghPjLWUg=;
        b=NMjMQGbggT+lzmLB/lZs0MrWLMyA8eQ1JmUbDSckC+VcK07Vy8csoa74mcLr+2YjWJZHWa
        nMO5DNesVx+HU2G+vA6BZrrbzSrWYJhjV4TDzi7LxiPSdZoh3hXjJQ8GB474vuAazu7A2/
        XsV+f3rxWVRO5TVxxXi8jbjQkgTzNNU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-xazthQsNMtaJZCHELgEN7g-1; Thu, 10 Feb 2022 11:41:04 -0500
X-MC-Unique: xazthQsNMtaJZCHELgEN7g-1
Received: by mail-ej1-f70.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso2979822ejk.17
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0l/m87uQUmT5CdzB+3f+eMwCEX3CAuEYEJDghPjLWUg=;
        b=ojTKdwY+4DFP0sTi9G/iVUCE2Kps+6PSLlz2Ijb7psv3aqKNMJeR8zZIB5Esuel8KV
         aUkeRHTAoRUespO6RFOG93y4/qOeAWoiGjFxU6jRtMHBUrc82nAN3CiOyWDgFZN0BIYd
         Bq431OI9JPhdA4x9Jd/2tmLajiRFWiTqkM9WUIMuN2ZGCE0YNQnVKDG7FSHVql+wp1KL
         7KBbcRv3nWowHtGYeZKGLQcNFclkUX3LVDp//ciHxIiUaDsjYe14S/byOi1SJBwnXsd8
         b8Df707zJ/Qv7JJrr5bz9vXbfIEdTxViawtd2oQVwL2WJJUKldWua7PvRXQGyyUpowXf
         NnwQ==
X-Gm-Message-State: AOAM533W1ApwJPB+KXp7fEjGDclrXaeWfkPMTUA0JTOE/4wz56ZKx9L6
        F6YQhUmZHZsfIkok2wiG4XaC8JKTtpNYhSQJTmW1wxYQFC0TrADh/YhmfJAmqrv/bcCp7HBBfaS
        AEFleWwUdhyd0351B
X-Received: by 2002:a05:6402:4490:: with SMTP id er16mr9338804edb.453.1644511262948;
        Thu, 10 Feb 2022 08:41:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZECJ9IV0hUhjUbenMOOxBbaVN6c3Lw279B4RgPUaIqhBLIYpmJT4dWjQTktndy3A8BvGpTw==
X-Received: by 2002:a05:6402:4490:: with SMTP id er16mr9338778edb.453.1644511262720;
        Thu, 10 Feb 2022 08:41:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f28sm2372477ejl.46.2022.02.10.08.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:41:02 -0800 (PST)
Message-ID: <14850b2d-f55f-712a-41fe-b6ee4a291de0@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 3/6] KVM: nVMX: Also filter
 MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185714.48936-1-sashal@kernel.org>
 <20220209185714.48936-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185714.48936-3-sashal@kernel.org>
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
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> [ Upstream commit f80ae0ef089a09e8c18da43a382c3caac9a424a7 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Similar to MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS,
> MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS pair,
> MSR_IA32_VMX_TRUE_PINBASED_CTLS needs to be filtered the same way
> MSR_IA32_VMX_PINBASED_CTLS is currently filtered as guests may solely rely
> on 'true' MSR data.
> 
> Note, none of the currently existing Windows/Hyper-V versions are known
> to stumble upon the unfiltered MSR_IA32_VMX_TRUE_PINBASED_CTLS, the change
> is aimed at making the filtering future proof.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220112170134.1904308-2-vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/evmcs.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index c0d6fee9225fe..5b68034ec5f9c 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -361,6 +361,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>   	case MSR_IA32_VMX_PROCBASED_CTLS2:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>   		break;
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>   	case MSR_IA32_VMX_PINBASED_CTLS:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>   		break;

