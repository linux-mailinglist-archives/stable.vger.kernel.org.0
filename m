Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB7590CED
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiHLHyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiHLHyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50C1DA721F
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iemnzCi82taxJK9gof0A3vbRr+wiYKnoKu9ClK8H+Io=;
        b=Q8HqXmWeL41J5IsgNJM2syYjPi17apx+5kfMTalSVR0cCG03Wq12X41v6XAmf2K31gs3+Q
        V6YlR7mE1dA0QVuSSyciLwzfxP4BGj42MGi6OyZtHIev5qCvz3BYJBtRI/4clJ0JktVJbK
        4LMExGUoKM7JAb/otOyAdqtRx7DymZQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-COSkirUkPnqmN_oMDhgY6g-1; Fri, 12 Aug 2022 03:53:57 -0400
X-MC-Unique: COSkirUkPnqmN_oMDhgY6g-1
Received: by mail-ej1-f69.google.com with SMTP id go15-20020a1709070d8f00b00730ab9dd8c6so142092ejc.6
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=iemnzCi82taxJK9gof0A3vbRr+wiYKnoKu9ClK8H+Io=;
        b=ZfAvg63JP+PhIZ2YDBWoDa6686V4+FKDdKf1kpWkNDJC6EYCTwR89MDw6BNaKWYKYE
         7TtSr77MXb4SHfks4LLpyhSgp3zLlqdt9v4XweYYTVuCNXAM6chmxOM8DZ+AFniyf9T1
         8kXwY079wzgqD4f0cr+HHZh5Firs/ZavH1HNn4eBK/h8qolh+9+//CO4hQwt4OTpoixj
         y2d/uNyALIrC7TtfaVI1pg8spgJ4s5ykn4VHEWsvhV8EzVyYp0tLsccwY3dW28eedYE+
         6AXd4IG6auP+uhhY0P3KoMtfiGbjG32lcWZm2vt91o+d4E77KAKtmT+SjvbzmbEvOE3Y
         jBMg==
X-Gm-Message-State: ACgBeo0noH38PeHN0QmIspAOYclyLMSa2auLY6xyrvWhh/T2Ytv2FAIu
        ptvR+i4z47oxJTfN4x9qywiLDgs38b4Nzuhf7nU60G1kVqamiqWekwNYAJzA06UeWmcu2hh58LQ
        uW48r3ARPUSgzntdi
X-Received: by 2002:a17:907:a0c6:b0:730:f081:6e8e with SMTP id hw6-20020a170907a0c600b00730f0816e8emr1853207ejc.479.1660290836092;
        Fri, 12 Aug 2022 00:53:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7L0RPa+Wur6vRGR+pXu691xtDLZCziuD1A6LSoWETY8Lfw1xc+Co+P2Hujs4lq+boYUtPEaw==
X-Received: by 2002:a17:907:a0c6:b0:730:f081:6e8e with SMTP id hw6-20020a170907a0c600b00730f0816e8emr1853198ejc.479.1660290835908;
        Fri, 12 Aug 2022 00:53:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id gk24-20020a17090790d800b0072b92daef1csm515517ejb.146.2022.08.12.00.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:53:55 -0700 (PDT)
Message-ID: <ee0fafd0-6fe3-50a2-a106-d0e765690389@redhat.com>
Date:   Fri, 12 Aug 2022 09:53:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.10 3/3] KVM: x86: Avoid theoretical NULL pointer
 dereference in kvm_irq_delivery_to_apic_fast()
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202439.32051-1-stefan.ghinea@windriver.com>
 <20220810202439.32051-3-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202439.32051-3-stefan.ghinea@windriver.com>
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
> index 6ed6b090be94..260727eaa6b9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -991,6 +991,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

