Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AA5472F26
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhLMO1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239015AbhLMO1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:27:19 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59C9C061574;
        Mon, 13 Dec 2021 06:27:18 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so51858571edb.8;
        Mon, 13 Dec 2021 06:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=72vv4whFpn21cD5ZTCi8hPbIPzQPuKNBSVPXgoytSPM=;
        b=mXUAJ/XLJ2OE/7l3t6AncysL+vcFKHOaoY1i0qvznZfedRsUbRyOXIqFkduuWa6HHb
         WWqFAJbVaKVxk/DRweZqPtI0p5QjdN42KO+oGiqpdanaZI1rBhvLEGX58ERZdveCL5xp
         wP77YRApWxC1YsF2dflmsBx5vCdWwcvk0yGSIdOnN0BZdHuOcY5196L7Ju8MEf1t/b3Z
         bWXY7CvUTpgPeXh8bPGpNQB2dE/wLwL/DAuxg8ysGNXsyPXTkRhtdPnq837rU0/n5778
         y4TBEWDTvw3srrAopXbbsUZ/J7ObqsLgg9lplYqDeCW9AUQx10KEPlfDqIovKLMPblWF
         J3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=72vv4whFpn21cD5ZTCi8hPbIPzQPuKNBSVPXgoytSPM=;
        b=tfgn7x2HpefU/Jmb0EFvATtDDO/QfQUt1RjcbNq7jQwCH4bpNURc4KyToFAKpuTZZx
         swnJiWUNfW/PgCh7E2T3xZ42kJMCWDy0SXJHPaiTEc8FBgv6WxDjmhWseIFHJ2tt213j
         Dqvk+NmNUNUrpeGb+dXPOzwWz1b+s5BPGNtPSZ+RTWUjv3uWbTgqDnv8wlHi23XgX0WO
         4VVP+NVN8JAt6EQLbPnnYYVcS2AmelndI4lElIom47/GqztpfhZUckepbuBSx/6MsGL6
         NIsWYiDFkuWTEOCOOZ5Iiy2kM5H2fFwqOMD916zY6e3tbBpKNBZjrRjA/veE3FCUrSwU
         /apg==
X-Gm-Message-State: AOAM532DfxytOT3dvIbrTqxJueCqxMtd+7tzTSG2uLzLlfu5BrSZx9oQ
        ui0tPgDJlYoBS2nUckRy3uw=
X-Google-Smtp-Source: ABdhPJzeGWEmdztHt8Z4JPtKnFWXtzH+uRdm36nohQR6B/cXOqvUMxVbn9U+a9kz0UFXoGjbjceJZg==
X-Received: by 2002:a17:906:544f:: with SMTP id d15mr43897756ejp.373.1639405632661;
        Mon, 13 Dec 2021 06:27:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id h10sm1023459edr.95.2021.12.13.06.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:27:12 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3cdb14c3-9186-4101-9ab0-d205e8778bd7@redhat.com>
Date:   Mon, 13 Dec 2021 15:27:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 3/9] KVM: VMX: clear
 vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit e90e51d5f01d2baae5dcce280866bbb96816e978 ]
> 
> There is nothing to synchronize if APICv is disabled, since neither
> other vCPUs nor assigned devices can set PIR.ON.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dacdf2395f01a..4e212f04268bb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7776,10 +7776,10 @@ static __init int hardware_setup(void)
>   		ple_window_shrink = 0;
>   	}
>   
> -	if (!cpu_has_vmx_apicv()) {
> +	if (!cpu_has_vmx_apicv())
>   		enable_apicv = 0;
> +	if (!enable_apicv)
>   		vmx_x86_ops.sync_pir_to_irr = NULL;
> -	}
>   
>   	if (cpu_has_vmx_tsc_scaling()) {
>   		kvm_has_tsc_control = true;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
