Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F9590CF7
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiHLHyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiHLHyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60ADAA7234
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6M0tz6uYLSQ61dqfWmfymeto8IT289uGQfzXWE67EM=;
        b=eT3iK+Z2XRQzT62eZ8rjH7DW50GS60ulmt8rXvJrOWXax5cQJxibkCgbHbJuZl4ncKpob9
        64wgjMgKsyfTtou8uT4n14mMs6Pc1qLj3AAmu8jg9wctl1T57Pj+KsAxOwITENer1NvTo1
        ycqrj6Rti1yNiFxPiinOzZ3JEPv5E/E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-x_jPrzL3PpaGkwUEW4lFzA-1; Fri, 12 Aug 2022 03:54:48 -0400
X-MC-Unique: x_jPrzL3PpaGkwUEW4lFzA-1
Received: by mail-ej1-f72.google.com with SMTP id ho13-20020a1709070e8d00b00730a655e173so144980ejc.8
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=F6M0tz6uYLSQ61dqfWmfymeto8IT289uGQfzXWE67EM=;
        b=KkaevQ+6IMffwghwudsnk/gjwkv2auTnbhLrY9HNKUrvZUGKCTnharL4gkBQf6cTJp
         ICSTGz1jTbD5Idx9CqB0nnF2KOHmQJZ6hhhbTXjMusPFnIYxZbitM1pCE9+AaAk5ZtOH
         VsZtnLfSlBJho/JTqHCrRVZc6yX0CYm7bBM2rU+3TEEN7ZMALDaPMKD+NEEdf/NFgqZ9
         pRxnHfXaMLkXzS6qOi9oA+gFCK+r9N3oBrCgr3EmaTxXK8t2eIAKYUfDpZY+iv1e9vZq
         /xB14B/xZ6EGnP124A19CIC3rk6+2s+goQqHMHh7uofEy6wLSxjiQAi/C3Qdx3IcUIrj
         Qnkw==
X-Gm-Message-State: ACgBeo3SA7rr8JjWM3LDlLSThXwPZKqopNPQYSe46YTDZtrMYIXVfccd
        zbXNkgHaFWNhbdw71s9Oc8gjuwfX13WVcxrZL6GJQcJRapbEV9uCepMrzx5+bBVg8++I7ctq31Y
        Daa53CVEOJXO5LlJl
X-Received: by 2002:a17:907:97c1:b0:733:19ef:b2b with SMTP id js1-20020a17090797c100b0073319ef0b2bmr1831787ejc.511.1660290887751;
        Fri, 12 Aug 2022 00:54:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5q5Xxp6pPVIhpFjIA616B2a2UOGIzlusQV2YzClAgYnafE6+ySfdWcJy3+Rrblsi4qhTEsLg==
X-Received: by 2002:a17:907:97c1:b0:733:19ef:b2b with SMTP id js1-20020a17090797c100b0073319ef0b2bmr1831778ejc.511.1660290887557;
        Fri, 12 Aug 2022 00:54:47 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id j5-20020a50ed05000000b0043ccd4d15eesm926960eds.64.2022.08.12.00.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:46 -0700 (PDT)
Message-ID: <48684f5e-4821-2a51-864f-906781fc6e56@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.14 3/3] KVM: x86: Avoid theoretical NULL pointer
 dereference in kvm_irq_delivery_to_apic_fast()
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202655.32600-1-stefan.ghinea@windriver.com>
 <20220810202655.32600-3-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202655.32600-3-stefan.ghinea@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
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
> index 99b3fa3a29bf..4305f094d2c5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -894,6 +894,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

