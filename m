Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534F4590CF5
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiHLHyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiHLHyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2835A74C3
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bw7V/1RMGVaApAsJTbY0uElxQkYoTatupioYh4ERRE4=;
        b=SRtaBc9W/UlxMmPtdYg4ZzllepdWLiOVYiVdCwAhsicEc0U5wPnUA7ZATMImsv59bt9R3b
        BYoW6Qj0RLrQuvfQu3xFo/6sw9uSqtYonXfe9XeZ4QOfS/QCbpf99qYWz9au+ZsQL3tB1u
        GO1zxpEy3/xxaT8AjGGGrRwmM3quemc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-GOEs3F2cNrmoHK4uYy_uXA-1; Fri, 12 Aug 2022 03:54:37 -0400
X-MC-Unique: GOEs3F2cNrmoHK4uYy_uXA-1
Received: by mail-ed1-f72.google.com with SMTP id m18-20020a056402511200b0043d601a8035so176705edd.20
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Bw7V/1RMGVaApAsJTbY0uElxQkYoTatupioYh4ERRE4=;
        b=xkUd6Wcd1+6wQcqhGBFFVrvIV+jWx14c5inu5565p9gLvnRd/uoJ6oEf4mBOyxcINB
         ayti3MHD7zT5FXkw75CkdZfOGq0qa4Zq+5O+HGUJLfi44Wv8tWNdPmlWworNEw8ZjQSC
         WZj/pXKszunL/g33gZIoDTYwWuJ3SPdE0ckFazdsLAxdprO4PTimSdWhywG+wXY7b1Cx
         Ggk2u3d+BInBf7kTNIPGy+4ZoealOZEaVTI4BztyKJ0uLv+1G0jpXFyMG8weHWJN0WoN
         ZJ+8R/2NnM0ICM7PqFVAGm69E58TQ9RxD5wBPNRI4Tf4tIgzu2B2TUx3UZI0is3nCDdO
         4Cyg==
X-Gm-Message-State: ACgBeo0aO/pYVPircCJMP6wB+oHujzBPqriDXE9ZuadXApS8Nhp7HR44
        mCv7ZRMqjnzoeNRzVO335ywBJPIPIjDs6aJFN+WumrSm7yZswFwGZgK3Cahc4H4OVAxe8ZbCtJG
        NEjCX7xSzNnuMXtaU
X-Received: by 2002:a17:907:7603:b0:730:9e05:1110 with SMTP id jx3-20020a170907760300b007309e051110mr1839559ejc.591.1660290876111;
        Fri, 12 Aug 2022 00:54:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7H5Y5+GQBX3tZQ4J2lTgP08r/X5JJT7t7cgQ2GBMtzuq4VabqMie19CkOewx1qRzz1pMSZ5A==
X-Received: by 2002:a17:907:7603:b0:730:9e05:1110 with SMTP id jx3-20020a170907760300b007309e051110mr1839550ejc.591.1660290875867;
        Fri, 12 Aug 2022 00:54:35 -0700 (PDT)
Received: from [192.168.10.81] ([93.56.169.144])
        by smtp.googlemail.com with ESMTPSA id i21-20020a17090685d500b0073073ce488asm520877ejy.45.2022.08.12.00.54.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:35 -0700 (PDT)
Message-ID: <a447072a-d22c-534a-7dd6-9a770b715e31@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4.14 1/3] KVM: Add infrastructure and macro to mark VM as
 bugged
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <20220810202655.32600-1-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202655.32600-1-stefan.ghinea@windriver.com>
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
> [SG: Adjusted context for kernel version 4.14]
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c      | 10 +++++-----
>   2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d5e38ebcfa47..2c6a321899e8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -127,6 +127,7 @@ static inline bool is_error_page(struct page *page)
>   #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_PENDING_TIMER     2
>   #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQUEST_ARCH_BASE     8
>   
>   #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -446,6 +447,7 @@ struct kvm {
>   	struct kvm_stat_data **debugfs_stat_data;
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
> +	bool vm_bugged;
>   	pid_t userspace_pid;
>   };
>   
> @@ -475,6 +477,31 @@ struct kvm {
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
> @@ -732,7 +759,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
>   
>   void kvm_flush_remote_tlbs(struct kvm *kvm);
>   void kvm_reload_remote_mmus(struct kvm *kvm);
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>   
>   long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 87d522eefbb4..7c4de635f00a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2660,7 +2660,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   	struct kvm_fpu *fpu = NULL;
>   	struct kvm_sregs *kvm_sregs = NULL;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -2864,7 +2864,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>   	void __user *argp = compat_ptr(arg);
>   	int r;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -2922,7 +2922,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>   {
>   	struct kvm_device *dev = filp->private_data;
>   
> -	if (dev->kvm->mm != current->mm)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3087,7 +3087,7 @@ static long kvm_vm_ioctl(struct file *filp,
>   	void __user *argp = (void __user *)arg;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_CREATE_VCPU:
> @@ -3264,7 +3264,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>   	struct kvm *kvm = filp->private_data;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_GET_DIRTY_LOG: {

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

