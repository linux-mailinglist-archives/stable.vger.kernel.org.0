Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468184B1316
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244454AbiBJQkX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:40:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244452AbiBJQkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:40:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C21C397
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYbtrys6O/G8myu/5FfO900MqezhEujmkQ1qd2Z++7E=;
        b=d4zkNxT3nYex74RG8BGZxFkBeRYyh+CcyhGOjahPxn4o0fjh+85YY0mL8ObClDS0WXUVK8
        axg/t6sisFF++knE7j726cAIJniAAYegKPedSihSK/IWh27LaOGuuDGMQps7BMrpjBL0d3
        HPO0J96rGLe60CPIO8XFB55PXKegMRI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-iEzUvRNfOfG_EDUmjVjazw-1; Thu, 10 Feb 2022 11:40:18 -0500
X-MC-Unique: iEzUvRNfOfG_EDUmjVjazw-1
Received: by mail-ej1-f72.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so2983435ejk.16
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:40:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kYbtrys6O/G8myu/5FfO900MqezhEujmkQ1qd2Z++7E=;
        b=BFWbcvO22O8yU0u7kW6/YGT0XDbX0AbKP3zRV+wiDMKByJevr/cYR5XFi47P/fergY
         pbmmfK0RnK8IUgYasTWXiEZxi6uYjJIQIjn6geMUDKyiju/Cxo7UJlvWXv1PJY/K+3ZS
         ISpxy96wS/RQD7XQxZUkBvGUd8G4IMjXok+es+lz979wQfB5i+1uyFHjdGO5fWHFvWj9
         HKf52wQTlmKV/B0gkk0rSu++Ga1TyGhRQpbtOYoobpR0agPTrdTID9cuDDi8W+jrs5Nq
         AksyEoUBchPLWpXxpVTnr0WI/eOqfUN46yqg/SSJk/Y2NRWevlA/FKwF4/G3l8OaiI9f
         eQ7Q==
X-Gm-Message-State: AOAM533ryrIoV62hvqe6VosZXkko7oVL8YKr0o6SVMIbhcZw4x27WC4I
        ca2tRl4otuOK39atfw20DYh3icZGtrDZQTNUCGx7U/i3QLYYxTVpUHPHvPv3e78ZVMR2v6nh9Tn
        69gn5SUa4IQHSY7OB
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr9091389edf.347.1644511216917;
        Thu, 10 Feb 2022 08:40:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTFOTCswQjhyOzYxQBHk4nDjaeCftIyJxXIZQ0G+0kIFDYPeXBEraXDJjtTI3TpPMCy9j4BQ==
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr9091348edf.347.1644511216536;
        Thu, 10 Feb 2022 08:40:16 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p1sm7135746edy.69.2022.02.10.08.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:15 -0800 (PST)
Message-ID: <87b783e6-2bc7-636d-334e-1b09e05724d4@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 3/8] KVM: nVMX: Also filter
 MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220209185653.48833-1-sashal@kernel.org>
 <20220209185653.48833-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185653.48833-3-sashal@kernel.org>
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

On 2/9/22 19:56, Sasha Levin wrote:
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
> index ba6f99f584ac3..a7ed30d5647af 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -362,6 +362,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>   	case MSR_IA32_VMX_PROCBASED_CTLS2:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>   		break;
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>   	case MSR_IA32_VMX_PINBASED_CTLS:
>   		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>   		break;

