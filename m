Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C1A49874D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbiAXRzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbiAXRzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:55:16 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262B8C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:55:16 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id t9so1267832lji.12
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lwYRUM6iCqXyjzM8R6mVx7QYQAgnbD6nOvh3iTUB9co=;
        b=ghrUGKaZnSlvyAIvDovIkbTjiAsk/ewkPo8oODmxTPtzyZwHEAfuVsicy4pLLWgOoV
         xR7hqprs20hSklO1/uQ9fseRUMiAJrZ5iX0qznRBX/v0CitEvDbC82ohyM5eLTsSW59v
         pFZUyQj9Cca+TSGk2Vc4bLqYsL8VwCuMcU2Ei2AHXa5H39WNQtPVhbcOnpKwfFHwzypS
         L7k7SrttbfB1lFa9ti9ix9nIWMJTTYFi8ElUupQuaYrCYntHYKjnLSMVU15WtzAtO8SI
         EBBpgJwDGqadr/3Ga8AoztWnvypDlny4QGGVDNJLYAjT7oZEPfG+g8HR5RGw9x/bCxdN
         aeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lwYRUM6iCqXyjzM8R6mVx7QYQAgnbD6nOvh3iTUB9co=;
        b=MivpGWgHsQUmDrW7Rt/ipUfiHy0L9rmex+6xWiyLJ+k2Dn0Awzkq5AK/FLvoy8Mnjr
         +hg4LP4O4vc8isd0Nq2Upk/LXbc/m5neBcV9lmsI5RdUC6PvofQtCR8KF4QejHIwpRhK
         p98xsYpHgUdJ3+TWKk1St8IlEcl3CHCdhMZPOHTfqCV5E8X9fNfnfl8xyLV5jrr9ue0d
         hJCw/PBTWDSeCqUQy2JyHtLTUDfPM7nM0jQOZk9BPSWeOxx23G9C2ixKr8lgxxVxbU76
         +R/rAdb7e2+BF3GWXTh9TXl6lAi0RKlcZA91hcQAlWaZUFB978DeWyjRzC8gnhq814Lo
         SRfQ==
X-Gm-Message-State: AOAM531RsL2cKIMu/xjNt/J9/n4xIJFA8JyQ7RiNULhU8zyYrL+tx3wa
        MCgtJcxZ9w37M5vFF1G+tHAJkcGdgoxXKMMh9V8wIQ==
X-Google-Smtp-Source: ABdhPJzzJgdjhXHa80Fry/crdlEzUym3vUr1kaK/4UU9aqEEBDRMMknUb6K+2GrSVWT/eaEFgcqYEwojDqrseVl1ROI=
X-Received: by 2002:a2e:9c03:: with SMTP id s3mr11885124lji.198.1643046914229;
 Mon, 24 Jan 2022 09:55:14 -0800 (PST)
MIME-Version: 1.0
References: <1642944976217120@kroah.com>
In-Reply-To: <1642944976217120@kroah.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 24 Jan 2022 09:54:47 -0800
Message-ID: <CALzav=eObKuocK9KOzsEACQ+8Uy9arNGzTPUc2CwUmdNAfvAyg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Fix write-protection of PTs
 mapped by the TDP" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 23, 2022 at 5:36 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I'll take a look and send a backport to 5.10.

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 7c8a4742c4abe205ec9daf416c9d42fd6b406e8e Mon Sep 17 00:00:00 2001
> From: David Matlack <dmatlack@google.com>
> Date: Thu, 13 Jan 2022 23:30:17 +0000
> Subject: [PATCH] KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP
>  MMU
>
> When the TDP MMU is write-protection GFNs for page table protection (as
> opposed to for dirty logging, or due to the HVA not being writable), it
> checks if the SPTE is already write-protected and if so skips modifying
> the SPTE and the TLB flush.
>
> This behavior is incorrect because it fails to check if the SPTE
> is write-protected for page table protection, i.e. fails to check
> that MMU-writable is '0'.  If the SPTE was write-protected for dirty
> logging but not page table protection, the SPTE could locklessly be made
> writable, and vCPUs could still be running with writable mappings cached
> in their TLB.
>
> Fix this by only skipping setting the SPTE if the SPTE is already
> write-protected *and* MMU-writable is already clear.  Technically,
> checking only MMU-writable would suffice; a SPTE cannot be writable
> without MMU-writable being set.  But check both to be paranoid and
> because it arguably yields more readable code.
>
> Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Matlack <dmatlack@google.com>
> Message-Id: <20220113233020.3986005-2-dmatlack@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 7b1bc816b7c3..bc9e3553fba2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1442,12 +1442,12 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
>                     !is_last_spte(iter.old_spte, iter.level))
>                         continue;
>
> -               if (!is_writable_pte(iter.old_spte))
> -                       break;
> -
>                 new_spte = iter.old_spte &
>                         ~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
>
> +               if (new_spte == iter.old_spte)
> +                       break;
> +
>                 tdp_mmu_set_spte(kvm, &iter, new_spte);
>                 spte_set = true;
>         }
>
