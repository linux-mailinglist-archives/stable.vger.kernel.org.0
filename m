Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72751590CEC
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiHLHxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbiHLHxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:53:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31F6DA7225
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JxLx09xDVnlpy5PzGDOElnOxPzAw4CyuCuvFng8xGyw=;
        b=XlqBbSbHRLT1IX++JxW0OwOFQPtWBbFylJ8OF/dSinCKNatnblyoR1tCa8HMadUFVu2KLr
        BGN9Zx+yXK0x9gPO6mHxxIkqD0snpMXfrwcT+uGw/j45VBs8J4QOYFFVOEqecshgmSSPJu
        20jFYOu9WPPJ2konf8OLtmRUFEPAN70=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-RRPIyWYuMAySxFoMUnVgkw-1; Fri, 12 Aug 2022 03:53:48 -0400
X-MC-Unique: RRPIyWYuMAySxFoMUnVgkw-1
Received: by mail-ej1-f72.google.com with SMTP id qf23-20020a1709077f1700b007308a195618so143591ejc.7
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=JxLx09xDVnlpy5PzGDOElnOxPzAw4CyuCuvFng8xGyw=;
        b=a4/iztolQA+OcSq1FBegmyRF+Y3n7wE4OYitl99n78UcZUZlUsfCYnQ5JgrsJNHRWd
         CbgPQZw+Jgd979YGBUkvVeHlutNHqx8+BGAAdq64rd2WVWQ+Kcx+WQiWj7sQAfNqRuV+
         35/tJOVgYpNy13vdOJPL/T8nE1+EDO8jEVCC0oYRTMT+fXelwMsopF4CRYDMTm4Qkybo
         NRiAy9iM8WSJ6OSXBaAWh4EhJuetYWsLjaqFujO6Ja/Evi1IZkBpFF0dubVodVQoYBRQ
         MPmpmAUJ1qSSxo2f2LHmm9TAvRo4Cy2j0kAADTYxiYrsBEr89pjskx8OPsjHxj1+er/V
         03/Q==
X-Gm-Message-State: ACgBeo3EY5/6Umg2hItTRxavj0sFJiWNuKTEj5AZ1/8mU8Ifq8F8Rwdr
        fgZkjyDotq/dCyDBrt9GW2f6TaSLmqnGvpYOSCdnEy1IXr9DO3P/+RqaUM4mOly8HOwuYsRqh8q
        DCrAXH6sM9XU6uwZ6
X-Received: by 2002:a17:907:3e81:b0:726:9615:d14d with SMTP id hs1-20020a1709073e8100b007269615d14dmr1794168ejc.517.1660290826952;
        Fri, 12 Aug 2022 00:53:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6f2WCaIPfS/VqLbnHsyYPX885Dg++mEJ79GSnTWwCz/ZaV2/w+pmn4ImCg1Z2m+l8fWj9bhw==
X-Received: by 2002:a17:907:3e81:b0:726:9615:d14d with SMTP id hs1-20020a1709073e8100b007269615d14dmr1794158ejc.517.1660290826733;
        Fri, 12 Aug 2022 00:53:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id o6-20020aa7c506000000b0043e8334f762sm927568edq.65.2022.08.12.00.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:53:46 -0700 (PDT)
Message-ID: <6a785b73-6631-d758-94ca-a8f6e790905e@redhat.com>
Date:   Fri, 12 Aug 2022 09:53:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.10 1/3] KVM: Add infrastructure and macro to mark VM as
 bugged
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <20220810202439.32051-1-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202439.32051-1-stefan.ghinea@windriver.com>
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

On 8/10/22 22:24, Stefan Ghinea wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> commit 0b8f11737cffc1a406d1134b58687abc29d76b52 upstream
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [SG: Adjusted context for kernel version 5.10]
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c      | 10 +++++-----
>   2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 439fbe0ee0c7..94871f12e536 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -146,6 +146,7 @@ static inline bool is_error_page(struct page *page)
>   #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_PENDING_TIMER     2
>   #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQUEST_ARCH_BASE     8
>   
>   #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -505,6 +506,7 @@ struct kvm {
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
>   	unsigned int max_halt_poll_ns;
> +	bool vm_bugged;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -533,6 +535,31 @@ struct kvm {
>   #define vcpu_err(vcpu, fmt, ...)					\
>   	kvm_err("vcpu%i " fmt, (vcpu)->vcpu_id, ## __VA_ARGS__)
>   
> +bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> +static inline void kvm_vm_bugged(struct kvm *kvm)
> +{
> +	kvm->vm_bugged = true;
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_BUGGED);
> +}
> +
> +#define KVM_BUG(cond, kvm, fmt...)				\
> +({								\
> +	int __ret = (cond);					\
> +								\
> +	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
> +		kvm_vm_bugged(kvm);				\
> +	unlikely(__ret);					\
> +})
> +
> +#define KVM_BUG_ON(cond, kvm)					\
> +({								\
> +	int __ret = (cond);					\
> +								\
> +	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
> +		kvm_vm_bugged(kvm);				\
> +	unlikely(__ret);					\
> +})
> +
>   static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
>   {
>   	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> @@ -850,7 +877,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>   bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>   				 struct kvm_vcpu *except,
>   				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>   bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
>   				      struct kvm_vcpu *except);
>   bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c5dbac10c372..bb7adddd6a85 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3252,7 +3252,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   	struct kvm_fpu *fpu = NULL;
>   	struct kvm_sregs *kvm_sregs = NULL;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -3458,7 +3458,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>   	void __user *argp = compat_ptr(arg);
>   	int r;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3524,7 +3524,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>   {
>   	struct kvm_device *dev = filp->private_data;
>   
> -	if (dev->kvm->mm != current->mm)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3743,7 +3743,7 @@ static long kvm_vm_ioctl(struct file *filp,
>   	void __user *argp = (void __user *)arg;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_CREATE_VCPU:
> @@ -3948,7 +3948,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>   	struct kvm *kvm = filp->private_data;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

