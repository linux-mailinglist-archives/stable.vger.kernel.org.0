Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9504B132C
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbiBJQlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:41:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244566AbiBJQlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:41:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EE3EC51
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sln1XK4tfQf7DanR/XnCkN/+xUa92Bv7r8YPe73yBKo=;
        b=UGnP26JE9I3gJ1YXSdebAjHjqoMlqx1kaeZfLMpm0LZtJTEG4kf9kNSHldjCtbskjdMSt1
        Zi2NzsbGxPFtP5eFFR9SNjhzMTTpBzXzP0xQfxGd8pL/r6ZZAI3xYAocJKUOurERriessZ
        zT44gyYsyoi4lEJJWLn1n62iZoKAb+A=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-5uBWdw-gPoaDhGN-FrF2sA-1; Thu, 10 Feb 2022 11:41:07 -0500
X-MC-Unique: 5uBWdw-gPoaDhGN-FrF2sA-1
Received: by mail-ej1-f69.google.com with SMTP id k16-20020a17090632d000b006ae1cdb0f07so2984449ejk.16
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 08:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sln1XK4tfQf7DanR/XnCkN/+xUa92Bv7r8YPe73yBKo=;
        b=6klAmuvKMtnwQWrglEZYa8K25Kevjgz04QDyGj7QogmzGfrktCGTp1aJwVP28NEJ4f
         tvoi7bZBTNI06FTozP/3fQflkrzbyQVPHCV7ZjscBoJOkv7tLenyaomzLpOZfzCMYNLo
         1t9HHX9Ed5KCpe1UuRkSJFYZjjvhRJAG+M5bzR0aCUm2Q+rIzsoA7vKtmRMdLgD3O5ar
         F3sUgxFxnhh8Gy7cUTHD3iG1vjh5Z6+uCn3UuBUKFGzfFqGp4K4JtawHgF/Lxly+t997
         a6mS0a2IYIJp5ELPjc70wj9/50Ct3b/q/oAUf21c5L398Vx1nYb0xUiXbX0o3ElggItW
         qhaw==
X-Gm-Message-State: AOAM530jAFUO7zw5/JHBqL3Bvhi1X5aA2b+rPg+9vSKooO2fVKNWfWeJ
        00QV75RW2C5+5kiWMGYhuBTBK1bfyMwD356kWi/Ke6qnXMjkXM+Y8YpO0T9JY15XeLT8fcKzLgU
        ApBZ1TYShCSAlrr9m
X-Received: by 2002:a17:906:4dd5:: with SMTP id f21mr7170805ejw.474.1644511266287;
        Thu, 10 Feb 2022 08:41:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGOGqdYFiEZXU4V7DS1VnbbmistQSNDrX9YO/QZtUoiRFpBftVTVgsIgQj5HPkbrLvluWCiA==
X-Received: by 2002:a17:906:4dd5:: with SMTP id f21mr7170779ejw.474.1644511265988;
        Thu, 10 Feb 2022 08:41:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id w17sm9076036edd.18.2022.02.10.08.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:41:05 -0800 (PST)
Message-ID: <6f3d4ed7-f3c1-7c06-d5cf-1bd824731e43@redhat.com>
Date:   Thu, 10 Feb 2022 17:41:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.16 1/8] KVM: eventfd: Fix false positive RCU
 usage warning
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20220209185635.48730-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185635.48730-1-sashal@kernel.org>
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
> From: Hou Wenlong <houwenlong93@linux.alibaba.com>
> 
> [ Upstream commit 6a0c61703e3a5d67845a4b275e1d9d7bc1b5aad7 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Fix the following false positive warning:
>   =============================
>   WARNING: suspicious RCU usage
>   5.16.0-rc4+ #57 Not tainted
>   -----------------------------
>   arch/x86/kvm/../../../virt/kvm/eventfd.c:484 RCU-list traversed in non-reader section!!
> 
>   other info that might help us debug this:
> 
>   rcu_scheduler_active = 2, debug_locks = 1
>   3 locks held by fc_vcpu 0/330:
>    #0: ffff8884835fc0b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x88/0x6f0 [kvm]
>    #1: ffffc90004c0bb68 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x600/0x1860 [kvm]
>    #2: ffffc90004c0c1d0 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x36/0x180 [kvm]
> 
>   stack backtrace:
>   CPU: 26 PID: 330 Comm: fc_vcpu 0 Not tainted 5.16.0-rc4+
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x44/0x57
>    kvm_notify_acked_gsi+0x6b/0x70 [kvm]
>    kvm_notify_acked_irq+0x8d/0x180 [kvm]
>    kvm_ioapic_update_eoi+0x92/0x240 [kvm]
>    kvm_apic_set_eoi_accelerated+0x2a/0xe0 [kvm]
>    handle_apic_eoi_induced+0x3d/0x60 [kvm_intel]
>    vmx_handle_exit+0x19c/0x6a0 [kvm_intel]
>    vcpu_enter_guest+0x66e/0x1860 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
>    kvm_vcpu_ioctl+0x38a/0x6f0 [kvm]
>    __x64_sys_ioctl+0x89/0xc0
>    do_syscall_64+0x3a/0x90
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Since kvm_unregister_irq_ack_notifier() does synchronize_srcu(&kvm->irq_srcu),
> kvm->irq_ack_notifier_list is protected by kvm->irq_srcu. In fact,
> kvm->irq_srcu SRCU read lock is held in kvm_notify_acked_irq(), making it
> a false positive warning. So use hlist_for_each_entry_srcu() instead of
> hlist_for_each_entry_rcu().
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> Message-Id: <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/eventfd.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2ad013b8bde96..59b1dd4a549ee 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -463,8 +463,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
>   	idx = srcu_read_lock(&kvm->irq_srcu);
>   	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
>   	if (gsi != -1)
> -		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
> -					 link)
> +		hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
> +					  link, srcu_read_lock_held(&kvm->irq_srcu))
>   			if (kian->gsi == gsi) {
>   				srcu_read_unlock(&kvm->irq_srcu, idx);
>   				return true;
> @@ -480,8 +480,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
>   {
>   	struct kvm_irq_ack_notifier *kian;
>   
> -	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
> -				 link)
> +	hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
> +				  link, srcu_read_lock_held(&kvm->irq_srcu))
>   		if (kian->gsi == gsi)
>   			kian->irq_acked(kian);
>   }

