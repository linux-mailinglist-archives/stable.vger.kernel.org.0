Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469A9590CF6
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbiHLHyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiHLHyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5595A7238
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CqufVxavGwQ54mPBSs9A9yIlIIyngAUy+dihX7oyJo8=;
        b=Fs456RE24JQaOpy8mh5gWfpxjuLZfMYp5GJRh8G3FtByHwOfRLObLoMnxYxCzUxvjChSDS
        cCzqNQZYujNVkhYHabS3ye772eXYa1Vr91hc0IdZoRV9dk6hFRxKAJhr04AP2EJGZDcdEo
        rETcxeKSjd7YC6F/UL+Ts3lR+UzAiog=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-312-FyfWO30cOe2jITdCcpN5jA-1; Fri, 12 Aug 2022 03:54:40 -0400
X-MC-Unique: FyfWO30cOe2jITdCcpN5jA-1
Received: by mail-ej1-f70.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so144880ejc.8
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CqufVxavGwQ54mPBSs9A9yIlIIyngAUy+dihX7oyJo8=;
        b=R638izjmXOR+HhEYnpwfV0tkfxDDCfoQ9ULWIwjdQIfR+wWZnlCWVPsjd3ALa4C6bx
         JQTVQHMmam60p0ZlUlQeCKKZVjQLC5AGN++1sY9GQ076qp7gAl3SuzIOiqkZPog/KDi1
         U6uUzxAsDrHKOHZXitwKhn2JAsC6exrdRdgamP4yhBv/nRBP7QALRNWra83LSbpQ1SM8
         fRsa9pOxwz/WdcrvkIhg5LCTwd1tBKmcPu44+dDzHHJANHkxVPpJeebkEBLplgYZRhgg
         JEdIsNZHVnb14SeRpuB93aG0ekyrak+mN+7R825o9A8SITbxJIFii8bdhJWqddg0Z0H4
         sDbw==
X-Gm-Message-State: ACgBeo1iE7oiXebQD5bmLvVQtrlCSlkIKJ4JQPV0+Nb9RUZs/MUqmn5F
        kV/HUcDge3G+Bcr6Ccgg4NmfIn3IIvm40PSQa/KlG3kcftvSg9njn1v3ssnUeXPQFdQRjPlU/U7
        wq0UBYa4fH5bV1m+3
X-Received: by 2002:a17:907:7615:b0:730:e1ad:b132 with SMTP id jx21-20020a170907761500b00730e1adb132mr1893676ejc.744.1660290879364;
        Fri, 12 Aug 2022 00:54:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4n/fMV4+cyrng8kLFdqKRDpHxM4cOTeYZk7Uxl1e4iv374txPUNPC7dczd6MrMKo+MdvWbUg==
X-Received: by 2002:a17:907:7615:b0:730:e1ad:b132 with SMTP id jx21-20020a170907761500b00730e1adb132mr1893674ejc.744.1660290879175;
        Fri, 12 Aug 2022 00:54:39 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170906201100b0072f1e7b06d9sm516478ejo.59.2022.08.12.00.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:38 -0700 (PDT)
Message-ID: <d5984d3e-97c1-1b17-9afb-7c91bbc3c797@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.14 2/3] KVM: x86: Check lapic_in_kernel() before
 attempting to set a SynIC irq
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202655.32600-1-stefan.ghinea@windriver.com>
 <20220810202655.32600-2-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202655.32600-2-stefan.ghinea@windriver.com>
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

On 8/10/22 22:26, Stefan Ghinea wrote:
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
> index 5497eeef4e70..ae9c45590b7e 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -317,6 +317,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
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

