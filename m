Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1393E497BE8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiAXJZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:25:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbiAXJZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643016357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kck1vofRE4hdltlQKHyaVyxTrdkTDYCISvIJ+W2Knko=;
        b=A3ZS5f6P8PYO/VUX8dyM/3fydrK6ky1+8LsYyJFm3erAFehAH03fD6ciBc0eSGRcM+jSMe
        88579XU2HSSBQ/UL7Z5BUd6sDaZaHBYaKkImdYp2wJPStDnG6fv0ImLLwTpwp7BJpJTTvM
        2CrkqoRwFd5ZaplOfXqGyXUsnAuadmA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-384-t8PuB1WfMemkxrokQkfH2g-1; Mon, 24 Jan 2022 04:25:56 -0500
X-MC-Unique: t8PuB1WfMemkxrokQkfH2g-1
Received: by mail-wm1-f69.google.com with SMTP id bg23-20020a05600c3c9700b0034bb19dfdc0so5617948wmb.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 01:25:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Kck1vofRE4hdltlQKHyaVyxTrdkTDYCISvIJ+W2Knko=;
        b=l+oOb5ezOqqgFAPN2x2faya8jDs1+NiRugcPGPKRbtajXo6RKZtpP6Tx/C2KSN1U9C
         7w2RaKd23q5623GcgbiE9xFSwfIo6trBpnAt6CHIUB6DhAzgbAXdmNgUUmjBWJofuDGK
         HBnZua0slwHUyJIFWUj+dpX3is3wRzennmQaYCiJN1HX65aTLae40uRSLDTXNsL5SHs6
         b9QinJzevxU6A3Hvk/JxL7Dix53HLoTcWgRstDjAXoZGFkrfIZwKHy9EZniq6GdH+MdV
         I4uoB1hOcsLtSHR0ijZh6DZPgqFMAJB+fWbZAUATr2/ohrZczef6YXX6CLfaJOItwxYK
         xirQ==
X-Gm-Message-State: AOAM530UkDGVnYASAkSnkOXHLqTnNGcoqqiEbRwCAeokql8vYGZGG+XW
        ye57uwUPTTyoUxqqttK7TnYOKZ3YlZjzMIe2PH6kROU8eXglZ8kjLITTjqgmSqdtIRV3qE9men8
        93t6ly5s65bz2XvHb
X-Received: by 2002:adf:f349:: with SMTP id e9mr13678885wrp.44.1643016355012;
        Mon, 24 Jan 2022 01:25:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjIb51lo1fFJ6ArIISO1wgU2PklPqIfp2mHWlO7G3/HWXnR8YcikE3+Vmh7B6nrq4BzB4P2Q==
X-Received: by 2002:adf:f349:: with SMTP id e9mr13678875wrp.44.1643016354748;
        Mon, 24 Jan 2022 01:25:54 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x4sm14380794wrp.13.2022.01.24.01.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 01:25:54 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, imammedo@redhat.com, pbonzini@redhat.com
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Partially allow
 KVM_SET_CPUID{,2} after KVM_RUN" failed to apply to 5.16-stable tree
In-Reply-To: <164294501412086@kroah.com>
References: <164294501412086@kroah.com>
Date:   Mon, 24 Jan 2022 10:25:53 +0100
Message-ID: <87pmohiixq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<gregkh@linuxfoundation.org> writes:

> The patch below does not apply to the 5.16-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I'll do the backporting.

Side note: there's (at least) one more fix needed in the area for SGX
enabled CPUs:

https://lore.kernel.org/kvm/20220121132852.2482355-3-vkuznets@redhat.com/
("No functional change intended" doesn't apply anymore as the order has
changed). Hope it'll make upstream (Cc: stable) in the next rc.

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From c6617c61e8fe44b9e9fdfede921f61cac6b5149d Mon Sep 17 00:00:00 2001
> From: Vitaly Kuznetsov <vkuznets@redhat.com>
> Date: Mon, 17 Jan 2022 16:05:40 +0100
> Subject: [PATCH] KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN
>
> Commit feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
> forbade changing CPUID altogether but unfortunately this is not fully
> compatible with existing VMMs. In particular, QEMU reuses vCPU fds for
> CPU hotplug after unplug and it calls KVM_SET_CPUID2. Instead of full ban,
> check whether the supplied CPUID data is equal to what was previously set.
>
> Reported-by: Igor Mammedov <imammedo@redhat.com>
> Fixes: feb627e8d6f6 ("KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Message-Id: <20220117150542.2176196-3-vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> [Do not call kvm_find_cpuid_entry repeatedly. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 812190a707f6..7eb046d907c6 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -119,6 +119,28 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>  	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
>  }
>  
> +/* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
> +static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
> +				 int nent)
> +{
> +	struct kvm_cpuid_entry2 *orig;
> +	int i;
> +
> +	if (nent != vcpu->arch.cpuid_nent)
> +		return -EINVAL;
> +
> +	for (i = 0; i < nent; i++) {
> +		orig = &vcpu->arch.cpuid_entries[i];
> +		if (e2[i].function != orig->function ||
> +		    e2[i].index != orig->index ||
> +		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
> +		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
>  {
>  	u32 function;
> @@ -313,6 +335,20 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  
>  	__kvm_update_cpuid_runtime(vcpu, e2, nent);
>  
> +	/*
> +	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> +	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> +	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> +	 * faults due to reusing SPs/SPTEs. In practice no sane VMM mucks with
> +	 * the core vCPU model on the fly. It would've been better to forbid any
> +	 * KVM_SET_CPUID{,2} calls after KVM_RUN altogether but unfortunately
> +	 * some VMMs (e.g. QEMU) reuse vCPU fds for CPU hotplug/unplug and do
> +	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
> +	 * whether the supplied CPUID data is equal to what's already set.
> +	 */
> +	if (vcpu->arch.last_vmentry_cpu != -1)
> +		return kvm_cpuid_check_equal(vcpu, e2, nent);
> +
>  	r = kvm_check_cpuid(vcpu, e2, nent);
>  	if (r)
>  		return r;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 60da2331ec32..a0bc637348b2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5230,17 +5230,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		struct kvm_cpuid __user *cpuid_arg = argp;
>  		struct kvm_cpuid cpuid;
>  
> -		/*
> -		 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> -		 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> -		 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> -		 * faults due to reusing SPs/SPTEs.  In practice no sane VMM mucks with
> -		 * the core vCPU model on the fly, so fail.
> -		 */
> -		r = -EINVAL;
> -		if (vcpu->arch.last_vmentry_cpu != -1)
> -			goto out;
> -
>  		r = -EFAULT;
>  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>  			goto out;
> @@ -5251,14 +5240,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		struct kvm_cpuid2 __user *cpuid_arg = argp;
>  		struct kvm_cpuid2 cpuid;
>  
> -		/*
> -		 * KVM_SET_CPUID{,2} after KVM_RUN is forbidded, see the comment in
> -		 * KVM_SET_CPUID case above.
> -		 */
> -		r = -EINVAL;
> -		if (vcpu->arch.last_vmentry_cpu != -1)
> -			goto out;
> -
>  		r = -EFAULT;
>  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>  			goto out;
>

-- 
Vitaly

