Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9D8590CF4
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiHLHy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiHLHy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFF1BA7225
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuhpGTHc/cb3ZM4g5zhRk7x/4KGE+VbzRb8wy7kJJds=;
        b=P2tqCh33QcTnuveMaob8vjHNr8OII9bBO6syAxPsbgpeBALPjJMOBJ5J885bKjNHvc5Nhu
        0I4iD5svYkoVm+nZI/be9DnqyNBbQgl8cEZl0LTCpMhKbodWDRFObywt61Va8bNMCzC23P
        5+JmExsWwPa5s6b6dVdm4NLgocJkNQ4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-662-7tVXs2H8PaC3KizjyytOiw-1; Fri, 12 Aug 2022 03:54:24 -0400
X-MC-Unique: 7tVXs2H8PaC3KizjyytOiw-1
Received: by mail-ed1-f70.google.com with SMTP id z20-20020a05640235d400b0043e1e74a495so186602edc.11
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=OuhpGTHc/cb3ZM4g5zhRk7x/4KGE+VbzRb8wy7kJJds=;
        b=1P+/tlqUFk2pfnYSIQS16AR36BFC+qckcE9ScJ3kVrSfZbRtV390hIxK89UqeJRvri
         pl2ouLWiynAm411aFaVGtDl5Buy+dT0jBlvQSoAdwwpOTAOnBxne3TotBZqvUoW8oXe4
         BrY5PWT3qQBm4xSAo8ATXEy2CWzGzqoTK1e5X+zvcYjDKB+oiTPN91BAf0Mh245xFi5g
         QU7oV3qbEEGl8dmF2gvugqwViEkgN6Q1f2xww6c28tsiHTpCD2Fy+/3PKRaTBTGYM+M4
         iXD/lEbduVzaBp1kSXsshsglVqGHvY/SJIaOIIG6UgL4o+uPxaD2i0cx3ults3aDO5n/
         5o4g==
X-Gm-Message-State: ACgBeo2Vydo87a2lPdrSOXuORtMaXbwuVkdRSh2AxnQuoT7mnPEeq382
        0prwoXcMuROW2webqy0gsLcBrzEMMvhTmhl0iUZxOFG5nCLE4sHUlDjlx/rusom81b8d4hZWgMG
        K/+oeJmDFu+CQUfPg
X-Received: by 2002:a05:6402:341:b0:440:86a2:8272 with SMTP id r1-20020a056402034100b0044086a28272mr2499398edw.70.1660290862964;
        Fri, 12 Aug 2022 00:54:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4xl0VWh/MbQClVibW3lv47uiNkZZTJQrxX60ju+uXPlvKEcPTOxjzrefHlVTGVVTFxFa3FvA==
X-Received: by 2002:a05:6402:341:b0:440:86a2:8272 with SMTP id r1-20020a056402034100b0044086a28272mr2499392edw.70.1660290862793;
        Fri, 12 Aug 2022 00:54:22 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id gv11-20020a170906f10b00b0072af4af2f46sm510161ejb.74.2022.08.12.00.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:22 -0700 (PDT)
Message-ID: <aa24f0df-30ae-bef9-d5f5-32375545cac4@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.19 3/3] KVM: x86: Avoid theoretical NULL pointer
 dereference in kvm_irq_delivery_to_apic_fast()
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202625.32529-1-stefan.ghinea@windriver.com>
 <20220810202625.32529-3-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202625.32529-3-stefan.ghinea@windriver.com>
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
> commit 00b5f37189d24ac3ed46cb7f11742094778c46ce upstream
> 
> When kvm_irq_delivery_to_apic_fast() is called with APIC_DEST_SELF
> shorthand, 'src' must not be NULL. Crash the VM with KVM_BUG_ON()
> instead of crashing the host.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220325132140.25650-3-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   arch/x86/kvm/lapic.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 89d07312e58c..027941e3df68 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -961,6 +961,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>   	*r = -1;
>   
>   	if (irq->shorthand == APIC_DEST_SELF) {
> +		if (KVM_BUG_ON(!src, kvm)) {
> +			*r = 0;
> +			return true;
> +		}
>   		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
>   		return true;
>   	}

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

