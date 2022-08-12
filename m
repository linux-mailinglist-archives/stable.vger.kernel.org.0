Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E23F590CEE
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 09:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiHLHyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 03:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiHLHyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 03:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C2E3A721F
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660290845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+Tj2r6Y7Vcp8X+jz8gTV+4+hFM0B15xDcaogb9TEnM=;
        b=QhoEGAJrnVHeMHmseheOo7JoE9+OHhKHImX7R2x426MgznEKb8kpRopVZSflVyMcJMDXgZ
        8y4VqfeI1wXs1yJQ4if8IhdSciCeB0A2Wn8IVrLFRCbW+DU/ZPXsxQXxrK86c7n6YTFLX9
        4MVixYhBJllLE3+htrH10NFFBWeFlRY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-4lD_FkXzONSVBHh4ByPTAQ-1; Fri, 12 Aug 2022 03:54:04 -0400
X-MC-Unique: 4lD_FkXzONSVBHh4ByPTAQ-1
Received: by mail-ed1-f69.google.com with SMTP id s21-20020a056402521500b00440e91f30easo188544edd.7
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 00:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/+Tj2r6Y7Vcp8X+jz8gTV+4+hFM0B15xDcaogb9TEnM=;
        b=R973HoRtvrG3lVdA/m69UVVjEFJ9E16Eg2hK4rVn7Wf30z7wd4XGAeINnAc09zDB2t
         cuHzp8Pf9AuvoiXrfgysBalRBGrGfdNmTaVMTywngLcYraKEKv1otQV+VpKyAd9Jtw+7
         9RH6fjYy+V3cYD7Lb8Di/1HSYbZDAMXZkx0mJdpImYBGBfl+Hc17F9abTZoxVtAdpwSx
         +LlROCID1gs0bS6q+Q/ppsvFO1KSA4DdEEg53253u+leH+g3JvcBVqnNMBXFKoC6WIv0
         Nij0BDHUPDdhtRdOgBkm0SBTzkZI+JcFChBTkAVUYOQrNoEiwgKz5Zx3uoGS4MgOt/nc
         KmFg==
X-Gm-Message-State: ACgBeo3XtVelOmEmaoN6Mcg2jNCMpYoQNaZEKKG/g9wI8fb830/fsRaR
        T21SJngIeBSLDxTmdtEaTNLIblMd8/XJCmUmKrBU9P+BVTzi8/ir89qYf+ocvQ0M7Izj4fa/fkP
        s8fg+S+z2tc1BwTF6
X-Received: by 2002:a17:907:d17:b0:730:a910:d407 with SMTP id gn23-20020a1709070d1700b00730a910d407mr1895615ejc.89.1660290842593;
        Fri, 12 Aug 2022 00:54:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6twCa11gZNf6+stVwTdzXOCpfNBlTQf1MLyGyHHIAhzCC9/KmsRST5iHWrK6VX/nbwTsEamw==
X-Received: by 2002:a17:907:d17:b0:730:a910:d407 with SMTP id gn23-20020a1709070d1700b00730a910d407mr1895606ejc.89.1660290842341;
        Fri, 12 Aug 2022 00:54:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id e12-20020a056402088c00b0043a43fcde13sm938307edy.13.2022.08.12.00.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:54:01 -0700 (PDT)
Message-ID: <5283d0eb-87e7-c7bd-02f4-cbaaf7ede814@redhat.com>
Date:   Fri, 12 Aug 2022 09:54:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 5.4 1/3] KVM: Add infrastructure and macro to mark VM as
 bugged
Content-Language: en-US
To:     Stefan Ghinea <stefan.ghinea@windriver.com>, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
References: <20220810202552.32242-1-stefan.ghinea@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220810202552.32242-1-stefan.ghinea@windriver.com>
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
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> commit 0b8f11737cffc1a406d1134b58687abc29d76b52 upstream
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <3a0998645c328bf0895f1290e61821b70f048549.1625186503.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [SG: Adjusted context for kernel version 5.4]
> Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
> ---
>   include/linux/kvm_host.h | 28 +++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c      | 10 +++++-----
>   2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 19e8344c51a8..dd4cdad76b18 100644
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
> @@ -502,6 +503,7 @@ struct kvm {
>   	struct srcu_struct srcu;
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
> +	bool vm_bugged;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -530,6 +532,31 @@ struct kvm {
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
> @@ -790,7 +817,6 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
>   
>   bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>   				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> -bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>   
>   long kvm_arch_dev_ioctl(struct file *filp,
>   			unsigned int ioctl, unsigned long arg);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 287444e52ccf..ec1cd059816d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2937,7 +2937,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>   	struct kvm_fpu *fpu = NULL;
>   	struct kvm_sregs *kvm_sregs = NULL;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -3144,7 +3144,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>   	void __user *argp = compat_ptr(arg);
>   	int r;
>   
> -	if (vcpu->kvm->mm != current->mm)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3209,7 +3209,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>   {
>   	struct kvm_device *dev = filp->private_data;
>   
> -	if (dev->kvm->mm != current->mm)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>   		return -EIO;
>   
>   	switch (ioctl) {
> @@ -3410,7 +3410,7 @@ static long kvm_vm_ioctl(struct file *filp,
>   	void __user *argp = (void __user *)arg;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   	case KVM_CREATE_VCPU:
> @@ -3618,7 +3618,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>   	struct kvm *kvm = filp->private_data;
>   	int r;
>   
> -	if (kvm->mm != current->mm)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>   		return -EIO;
>   	switch (ioctl) {
>   #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

