Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F190590CF3
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiHLHyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237671AbiHLHyX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F0ADA721F
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=akh8K+q2Y7AdbJqXd4NiJ1T8Umr8lrSqKLXi8A4uVWg=;
        b=KFZVuivL6jz8+bBfGh9yvLJYGcLzsJf0ssxAKjVa4wp/6x4X6q+HLiJqJtobXI5GGlo4LP
        sMDavvNdMfoisIDa25q9j1vHTIjJKJzpp1aMTe+diC++WRAJ1LkaIzdweunJ3oU+w46PFy
        CEfRyQDAjflWMzDwT7jAvxdMFUJjIXk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-hAEVO_HONwqXr5XFvPqmdg-1; Fri, 12 Aug 2022 03:54:21 -0400
X-MC-Unique: hAEVO_HONwqXr5XFvPqmdg-1
Received: by mail-ed1-f72.google.com with SMTP id z6-20020a05640240c600b0043e1d52fd98so172791edb.22
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=akh8K+q2Y7AdbJqXd4NiJ1T8Umr8lrSqKLXi8A4uVWg=;
        b=51Yo6zOGedvqCM86wAB4HZZNrT1J9dlk8yj+kxcWNjYK5mt79e/hSjGkJmxCFYHNMp
         zaTWvznvF2YrMTCRqY344Zsq3V+jjDTdicVvklxS3WplvZUbEN4jbmGaqyfjHLAQ/PmQ
         clqs8n2S5rHYDOfim8+gof2C5myg1i+D+XhE4QbIm8jEJPuv9NQ1SYeyFXb0R2dg8bZ1
         A2PFaxJFBpz7qLjxoBAKfaw0TpKpzvT04T1yggsthzocIriC0XRy3zpjJ8WZrFu/QJZI
         w24aZxh4+bKPk0vjNToLOJmzviF8F9rz45Yi6fQ1p5IpUrfn4HvPrUechiy2SR76nKcf
         wPdg==
X-Gm-Message-State: ACgBeo2RQvsvSHlVwQC05wQkYPgmQfzGT6axiQoxYJBcX7sGImVviUuy
        AZzvSr5AHpCoLW8Wbr0jd0+05o3EiaBTdOjzIZ6fQesVMEKt951Fv3gNb54+S5qg1n8lZN6LrOx
        2agaSrdQP9acbbQqD
X-Received: by 2002:a17:907:168d:b0:731:67eb:b608 with SMTP id hc13-20020a170907168d00b0073167ebb608mr1827922ejc.518.1660290859509;
        Fri, 12 Aug 2022 00:54:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6zjCcWWSihcINsoc9IuK+cXwE7eV3yGR98LpFIRODHbT1L2M2BArDiKdMXhjR0xW783yzHnw==
X-Received: by 2002:a17:907:168d:b0:731:67eb:b608 with SMTP id hc13-20020a170907168d00b0073167ebb608mr1827916ejc.518.1660290859306;
        Fri, 12 Aug 2022 00:54:19 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id ck6-20020a170906c44600b0071cbc7487e1sm517327ejb.69.2022.08.12.00.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:18 -0700 (PDT)
Message-ID: <3aadcb3a-5cbc-ef2d-06b3-93371da0f85f@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.19 1/3] KVM: Add infrastructure and macro to mark VM as
 bugged
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <20220810202625.32529-1-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202625.32529-1-stefan.ghinea@windriver.com>
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
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> commit 0b8f11737cffc1a406d1134b58687abc29d76b52 upstream
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [SG: Adjusted context for kernel version 4.19]
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c      | 10 +++++-----
>   2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 827f70ce0b49..4f96aef4e8b8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -128,6 +128,7 @@ static inline bool is_error_page(struct page *page)
>   #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_PENDING_TIMER     2
>   #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQUEST_ARCH_BASE     8
>   
>   #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -482,6 +483,7 @@ struct kvm {
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
> +	bool vm_bugged;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -510,6 +512,31 @@ struct kvm {
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
>   static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
>   {
>   	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> @@ -770,7 +797,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
>   
>   bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>   				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>   
>   long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3d45ce134227..6f9c0060a3e5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2820,7 +2820,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   	struct kvm_fpu *fpu = NULL;
>   	struct kvm_sregs *kvm_sregs = NULL;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -3026,7 +3026,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>   	void __user *argp = compat_ptr(arg);
>   	int r;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3081,7 +3081,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>   {
>   	struct kvm_device *dev = filp->private_data;
>   
> -	if (dev->kvm->mm != current->mm)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3244,7 +3244,7 @@ static long kvm_vm_ioctl(struct file *filp,
>   	void __user *argp = (void __user *)arg;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_CREATE_VCPU:
> @@ -3422,7 +3422,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>   	struct kvm *kvm = filp->private_data;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_GET_DIRTY_LOG: {

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

