Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57488590CF1
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237668AbiHLHyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbiHLHyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6B1DA722E
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kB3ABJUujApZXQTkDpDH//BwSeCVh+FbeHzcVx6BVIQ=;
        b=cJSEaUoqty06SAoCMxvb+wb4aqLXGvDBCz6DR6Oxqty8N6VewRmxwTiwVsmZP4Hqy2Ie6y
        7sMSO+osBFzXdHAIPjWB3uRuwt2kdvQ7WQuzXoJ6S8t+u7LU3aAT3KmmJclgkInbbdxacJ
        ci2IbFvfU9jDdUGJjX+ApzPQ5CKAxVo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-euGon22aPzK1-73IyfxWRA-1; Fri, 12 Aug 2022 03:54:14 -0400
X-MC-Unique: euGon22aPzK1-73IyfxWRA-1
Received: by mail-ed1-f72.google.com with SMTP id h6-20020a05640250c600b0043d9964d2ceso194619edb.4
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=kB3ABJUujApZXQTkDpDH//BwSeCVh+FbeHzcVx6BVIQ=;
        b=J13imo5XDZD1zq+o9ej1OgbYlXnOTIzRhduUvfEWSl+UTRR8q4NG8Akh3kuqhOvTCZ
         n2EgTUuXiuydmoLQyEvQ3j+CqxDVaLZRdZGnBskuJyEajjKzwxn39ESuBTRKQ0/B5Wqk
         si4wx5bVKX/fW8k3eGZBd8LTyVMT0M5s0eQFNetW9ziCtDLjUlrIjHXvYt15z46xQ80A
         MSxqdhe/fa5q2NW3EuAxGixdNeA4e68PRvLZ7+jsvk8Q/Hfu99C9qSzC/RX8hZQCej2i
         W3rteBmUQsvvtYOmR4H8La1ifPA+fVRpBAZWq9ayuv8oubRRmXqajYu6A0mP5kQ4q64F
         y6uA==
X-Gm-Message-State: ACgBeo0ZkvZd8hDXg9KDYvzHwxI/d+lJV4dLKU9lqj0v+IwIhW2x5jSS
        y/DRvdISZOmPIKMSEkNXlYdfgYpVh9V54lCY4fQBYvXjEfvDX/8KezESsdG0ITGUeiMwttS4KnU
        CrZ6WelB4E4AwAJG7
X-Received: by 2002:a05:6402:3552:b0:43d:a57d:22e9 with SMTP id f18-20020a056402355200b0043da57d22e9mr2493040edd.119.1660290853382;
        Fri, 12 Aug 2022 00:54:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5C0/bwQsBWIKZ9s3T3V6ts2x1dgCADEswO4MMqbu0DrLJhC/FK/b2DUAKkImntjqueeC4kgA==
X-Received: by 2002:a05:6402:3552:b0:43d:a57d:22e9 with SMTP id f18-20020a056402355200b0043da57d22e9mr2493032edd.119.1660290853149;
        Fri, 12 Aug 2022 00:54:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id x19-20020aa7cd93000000b0043cb1a83c9fsm936004edv.71.2022.08.12.00.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:12 -0700 (PDT)
Message-ID: <7fcd6cb3-ea97-6901-187d-1cbdb5a715d2@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.4 3/3] KVM: x86: Avoid theoretical NULL pointer
 dereference in kvm_irq_delivery_to_apic_fast()
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220810202552.32242-1-stefan.ghinea@windriver.com>
 <20220810202552.32242-3-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202552.32242-3-stefan.ghinea@windriver.com>
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

On 8/10/22 22:25, Stefan Ghinea wrote:
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
> index 3696b4de9d99..23480d8e4ef1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -955,6 +955,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

