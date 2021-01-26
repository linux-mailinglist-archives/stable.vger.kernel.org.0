Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50967304C04
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbhAZV7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395338AbhAZTPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 14:15:46 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F20CC061574
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 11:15:06 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id o7so2030665pgl.1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 11:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7PjVCLjYFXyjmxqV/lyzID0J0aEXBM2goYbT8N0cVdM=;
        b=N4qij7ElZXoW1edUjouKX7sa4B7PcH7S1ydi7zNInVxG98fDfQBwvWzAsPMCiXfAIi
         SwHvVjKK5tkLgarR+fR9Gr/pyisr1XQUoa32306zwNGoFGGjXd+a1wwkTsed9uIkigvU
         JheRiZjqYzetJS+Y60ZD6kh92Ot6U2lumGY28k1RZgy07h4/3lLjxckmNwnDprtZe5Td
         rjK75ljLmnhqu/oUJ5o4l4db8W6r2oRtZWSs+HHdKAVjLD0CadqLdY6D6X+rT3PnN4zj
         BxndHPd0RluJldv52zCGzT9lBalqFCFNWBB9pZW+YCYOqvaXK4mn+ScGpLrday1Oz8Dn
         obtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7PjVCLjYFXyjmxqV/lyzID0J0aEXBM2goYbT8N0cVdM=;
        b=iKr6dM75FMrs+exs0BjZ1u+b9Xwskrzs+otAVYHZtGzAiRJ/GuaiQcEBHSB/8rVVnI
         CBVbMdkl+XyAVGFZaG8Tkd3Qi/T3qohtBDpx4C2YZG6hF1XsI/vmFq1wJYk2yEFtiUka
         VW6n9OZXakyoDBC038tG4d2XUoWCLCbaRYnROp7Nkiun3QYogTra0fWcASizoVc6k0Y9
         3Pg06TVTM/bNtlnA8TXi5M56uTdJKuiIPyElcCl/7QKbeuVrpfeDHK+9n4rRLDlvXeom
         v8Vk8betiGMpZcTsawmQ3aTYH0EGXtHBPyBz55fE9Fm5u0/511A75LrP0hwTE2EE2lQc
         aqxw==
X-Gm-Message-State: AOAM532nnobzQAMpUoF8o4Y2ipy4dhKd/y6ScnzvWMymV1ExNIFnExZc
        3ELwLp90rxbnC46suJHJn3GIqA==
X-Google-Smtp-Source: ABdhPJywTF+70hdYYm6QZYKpIt1JIx4lGygSfSPQrTqWQ+lxlJJDsLxSag8n7PPPKhewpWJCupqstg==
X-Received: by 2002:a05:6a00:16c7:b029:1b6:68a6:985a with SMTP id l7-20020a056a0016c7b02901b668a6985amr6557419pfc.44.1611688505551;
        Tue, 26 Jan 2021 11:15:05 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id b65sm21356534pga.54.2021.01.26.11.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 11:15:04 -0800 (PST)
Date:   Tue, 26 Jan 2021 11:14:58 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix unsynchronized access to sev members through
 svm_register_enc_region
Message-ID: <YBBqMkd7zGkNqnaL@google.com>
References: <20210126185431.1824530-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126185431.1824530-1-pgonda@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021, Peter Gonda wrote:
> sev_pin_memory assumes that callers hold the kvm->lock. This was true for
> all callers except svm_register_enc_region since it does not originate

This doesn't actually state what change it being made, is only describes the
problem. I'd also reword these sentences to avoid talking about assumptions, and
instead use stronger language.
 
> from svm_mem_enc_op. Also added lockdep annotation to help prevent

s/Also added/Add, i.e. describe what the patch is doing, not what you did in the
past.

E.g.

  Grab kvm->lock before pinning memory when registering an encrypted
  region; sev_pin_memory() relies on kvm->lock being held to ensure
  correctness when checking and updating the number of pinned pages.

  Add a lockdep assertion to help prevent future regressions.

> future regressions.
> 
> Tested: Booted SEV enabled VM on host.

Personally I'd just leave this out.  Unless stated otherwise, it's implied that
you've tested the patch.

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 116a2214c5173 (KVM: SVM: Pin guest memory when SEV is active)
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
>  arch/x86/kvm/svm.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index afdc5b44fe9f..9884e57f3d0f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1699,6 +1699,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  	struct page **pages;
>  	unsigned long first, last;
>  
> +	lockdep_assert_held(&kvm->lock);
> +
>  	if (ulen == 0 || uaddr + ulen < uaddr)
>  		return NULL;
>  
> @@ -7228,12 +7230,19 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	if (!region)
>  		return -ENOMEM;
>  
> +	mutex_lock(&kvm->lock);
>  	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>  	if (!region->pages) {
>  		ret = -ENOMEM;
>  		goto e_free;

This error path needs to do mutex_unlock().

>  	}
>  
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>  	/*
>  	 * The guest may change the memory encryption attribute from C=0 -> C=1
>  	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7242,13 +7251,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	 */
>  	sev_clflush_pages(region->pages, region->npages);
>  
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>  	return ret;
>  
>  e_free:
> -- 
> 2.30.0.280.ga3ce27912f-goog
