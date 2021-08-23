Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B0E3F52AB
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhHWVSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhHWVSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:18:34 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF6C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:17:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h13so28207457wrp.1
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LR2oxrF1aRTcyRvMqPIf+/aFGa1XBOaASj3pwWc1/Ko=;
        b=OTEsNTA77hSLAm70UJ2Fak8PN4CVYXQPnvHKxeyKZc0q+Vav98wLDruIteZ0cDbF2Z
         Cr64dEEU26PYHmBs8p4x7S1gT5spbBMmphEyxQ4wElPl5UxXlhVXlX6YwTZEumlgw+n5
         lCSjJ2sAHuB7SGfDZqks4uDsrTWpH+YeFbjGYdiilhTQEuD1mYW/Houm6GI7E0zfGPpA
         DWD/ucVwf4D/FibhRlRQcHGJq70dSnZQjb50YXEKJIGYgJqUIc1RRXwaseUjZ7R4VqsT
         iWo0/2V47xeN39QPSX0ZQrVRmyc3SUlzF9NurWYaEiZwkjp+FAvTqg9MGgMCRIVIxwNP
         hARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LR2oxrF1aRTcyRvMqPIf+/aFGa1XBOaASj3pwWc1/Ko=;
        b=qx+do4J78TOdJGANa4l6mdDJKu23uJfKKvVeAyzw3+JNGuquN45PFmTrteK5zC/h/d
         BJ70wiNvkk9wv9VZZ1f9n5cXdrx9XqjtGQgBNBl5AtYNO7G9azxTV2MZBLR5ZIdutMMm
         dFXvvmlavl4UAnnUn0YvYBrbuD6apzEHhULp7xdsBCtqY3ar5yMK4FseQB0T+yX1wYlj
         U5LMmqQke+kF6+rjftSY1e3G7KJbn19iMfW20TIU9incpzXZMcocuEqL96dCCpT5TSXq
         8mcMz3JisiZOoWwtQ3ff6ILttnD57NRn9pH3K1B+56Gipc7cT6cwbK+6qepLRKTgRMyT
         6wMg==
X-Gm-Message-State: AOAM532O/tUp3T3uBoy75n/FodwMrTY5Y1MvrRxZ52oPpP559g+rXB6X
        8hcklAiz211wI1xxi8cJpj8=
X-Google-Smtp-Source: ABdhPJwdayT712o4QARS+Dthw5T4ACRpGiSapH8+5UKoM55OJjDYxlx8mKJq979dp9RfYEVtmhhHSg==
X-Received: by 2002:a5d:460a:: with SMTP id t10mr10788346wrq.147.1629753470031;
        Mon, 23 Aug 2021 14:17:50 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h6sm378180wmq.5.2021.08.23.14.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:17:49 -0700 (PDT)
Date:   Mon, 23 Aug 2021 22:17:47 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not
 reserved) for all !TDP" failed to apply to 5.4-stable tree
Message-ID: <YSQQe0/4HaHjZuHC@debian>
References: <162600724959170@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="llP1ZrdiVHXUQPw+"
Content-Disposition: inline
In-Reply-To: <162600724959170@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--llP1ZrdiVHXUQPw+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 02:40:49PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--llP1ZrdiVHXUQPw+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Treat-NX-as-used-not-reserved-for-all-TD.patch"

From 925625f45cb571d12230c9254261a375250bb806 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 22 Jun 2021 10:56:47 -0700
Subject: [PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP
 shadow MMUs

commit 112022bdb5bc372e00e6e43cb88ee38ea67b97bd upstream

Mark NX as being used for all non-nested shadow MMUs, as KVM will set the
NX bit for huge SPTEs if the iTLB mutli-hit mitigation is enabled.
Checking the mitigation itself is not sufficient as it can be toggled on
at any time and KVM doesn't reset MMU contexts when that happens.  KVM
could reset the contexts, but that would require purging all SPTEs in all
MMUs, for no real benefit.  And, KVM already forces EFER.NX=1 when TDP is
disabled (for WP=0, SMEP=1, NX=0), so technically NX is never reserved
for shadow MMUs.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: use old path]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 260c64c205b8..d3877dd713ae 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4666,7 +4666,15 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx ||
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
 		context->mmu_role.base.smep_andnot_wp;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
-- 
2.30.2


--llP1ZrdiVHXUQPw+--
