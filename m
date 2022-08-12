Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B77590CEB
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbiHLHx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiHLHxy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9151A722E
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sB8VlG4IaJrZrehD0+OdsM2+h1JDzMjRnqEA3DI3Ehg=;
        b=ZJMQZYsNEKPT8adShXCf5KrPAE4m8dxu/kCb1xioRqcVgRihLm1YGcSGzScm3AJMVqPmUz
        +0nVJ9MoKdQts+NoD1b+j86PQJ5ONHSZV0BIgaDwRU6UGJMD+q7aP3EpQx+ypKoKN/kx6Y
        Ku4+fSNtXQx8uknnL+YkK+Anyq7XIws=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-488-IcdqVFJvMTGePqI91hzOJw-1; Fri, 12 Aug 2022 03:53:51 -0400
X-MC-Unique: IcdqVFJvMTGePqI91hzOJw-1
Received: by mail-ed1-f70.google.com with SMTP id h6-20020a05640250c600b0043d9964d2ceso194198edb.4
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=sB8VlG4IaJrZrehD0+OdsM2+h1JDzMjRnqEA3DI3Ehg=;
        b=JmNFdvMKG0c41SQ1Q2sL0BZW/zd2Bs1pu4yhvnoAB2XvMfSDIRNXm9AG3ExruFe3V2
         DyVXBlvrSE6wNQvn0yTTYopGlIRtoIF0nCuN/EHOXHUUSy+Mj8m4RYcbKMVzwEj0dDyj
         mMRN4I2wgUJZUh6h9EoXrgCrOaqn9cb/oGaXYaODkr6WYZ5DJw8hlgWHYdgKKD0uP3vC
         8luXa6RjgjVSuZ9vQpR9SymQR7A837CV+tasfkdH632bFovwQ9Yb/dIvSJnFZiIofpdj
         FZogs9hwaqt3Olm8zDbH1EAXtIlJPQJX7aBT1zHd44kr654q2aPMZ1bfZjPLObTaMEUb
         rnpQ==
X-Gm-Message-State: ACgBeo3M/IfaJlQcdWUJms6mTcu0GrVtHmjwyEdtPg+xtcM6rbfdVbi7
        NZWeqrxpWDwSwgolUFEM1bCeuhg4dV9qVlTctbm5Zyw15HWFuWs/FreBRo1cpHGUbY3lNO646Ch
        rRS3xOpJUBQesj+pd
X-Received: by 2002:a05:6402:b84:b0:43d:962d:7db1 with SMTP id cf4-20020a0564020b8400b0043d962d7db1mr2427965edb.270.1660290830185;
        Fri, 12 Aug 2022 00:53:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ld9fSE6GvLRrDESflZTuPr/Wi/AcMpL1nbq1ZWD0yBVwPTfmclXUgc3BUvHmZSCrqXjOfKA==
X-Received: by 2002:a05:6402:b84:b0:43d:962d:7db1 with SMTP id cf4-20020a0564020b8400b0043d962d7db1mr2427951edb.270.1660290829972;
        Fri, 12 Aug 2022 00:53:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id t16-20020a056402021000b0043be16f5f4csm942298edv.52.2022.08.12.00.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:53:49 -0700 (PDT)
Message-ID: <d46fefe2-e060-d088-6ecc-1160dbc86952@redhat.com>
Date:   Fri, 12 Aug 2022 09:53:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.10 2/3] KVM: x86: Check lapic_in_kernel() before
 attempting to set a SynIC irq
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202439.32051-1-stefan.ghinea@windriver.com>
 <20220810202439.32051-2-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202439.32051-2-stefan.ghinea@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/22 22:24, Stefan Ghinea wrote:
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> commit 7ec37d1cbe17d8189d9562178d8b29167fe1c31a upstream
> 
> When KVM_CAP_HYPERV_SYNIC{,2} is activated, KVM already checks for
> irqchip_in_kernel() so normally SynIC irqs should never be set. It is,
> however,  possible for a misbehaving VMM to write to SYNIC/STIMER MSRs
> causing erroneous behavior.
> 
> The immediate issue being fixed is that kvm_irq_delivery_to_apic()
> (kvm_irq_delivery_to_apic_fast()) crashes when called with
> 'irq.shorthand = APIC_DEST_SELF' and 'src == NULL'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220325132140.25650-2-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   arch/x86/kvm/hyperv.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index d806139377bc..09ec1cda2d68 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -428,6 +428,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
>   	struct kvm_lapic_irq irq;
>   	int ret, vector;
>   
> +	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
> +		return -EINVAL;
> +
>   	if (sint >= ARRAY_SIZE(synic->sint))
>   		return -EINVAL;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

