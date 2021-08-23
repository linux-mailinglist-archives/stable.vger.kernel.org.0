Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AB03F52C4
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhHWVVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhHWVVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:21:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5FEC061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:20:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x12so28134918wrr.11
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jxM9FmoZ88VQaOIKuaZVJtE/vH/caMx9dXbolDzPkow=;
        b=QfXyoT7ai9UpWWJ4NvJfzFKJ0BzMo9mJHtCt5KpNFfBP50SGBQ22f6BWu2vNFR5euF
         BRWIMJzx/1lzFKI6P+PB+qcyqIOnhRauJ7pDepEUzMemn3zHEpk2CF4F0nvGIl0j3/5G
         eZfDF2GOBBNCdfqARIYDOZoYcq7r9pIX/j5FLUJX581sqAJGOHCayLTJmdHQOzD4X2W6
         LjjI+TdRKSKscZN3IfVqd1qug6rBwaJbwHqim1ARVHJmOdB4wgSqfUk6l4bw4s8mdR+V
         s0c7LeaQqgWlPKexpnaMQQSuPdezqrVVe4vJ4xW5wu+ryu40VB8evxIifvCxhpZtgaVe
         TUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jxM9FmoZ88VQaOIKuaZVJtE/vH/caMx9dXbolDzPkow=;
        b=U8pCPfhvAcf//QOW9arF6L1RoiV+Qqtp9t8I+4qhE03n0ZL9gVI2ZFSjN/Wmu2SF+F
         EnWgfkTkMIUeSck9LLBJfBF+S0VxcIiYmRjIfAlkmsVv6yXfqkEzyMrfPyI2k1+groeb
         i3eBSulhbQYW21E+8TJQXkZQWdsxArxZHeFNsQ5pEHT12AahYH2J6lU2ajEmeZO8nVs4
         Sp9lLNwH4VcBuyrJwmmjeGbgkcpYORpEs+DDHhx6N0fr/bkzBt5aBxsXxMvOmek1I6s2
         55i/G4BSOmMOR+oBD2KJQftA8wAavl3ySW8eLRkkAcNMSDbsmx8AGiUHI6w6Un7b6TCq
         0FdQ==
X-Gm-Message-State: AOAM533eVD0EvpXpbA4yADk4U+juNaJcWLZjC8+cPIeRPMIauk4iHdtN
        feukgByj+ZpcfbZZQrTK8qI=
X-Google-Smtp-Source: ABdhPJyp47QE6eX//AY+yDIXVKQ4062zyobX5EGB+o1jmMmJJKZd5SOX1X3SgWMNspp23WZqXNczcg==
X-Received: by 2002:adf:eccc:: with SMTP id s12mr15902018wro.82.1629753658597;
        Mon, 23 Aug 2021 14:20:58 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id w1sm310118wmc.19.2021.08.23.14.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:20:58 -0700 (PDT)
Date:   Mon, 23 Aug 2021 22:20:56 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not
 reserved) for all !TDP" failed to apply to 4.9-stable tree
Message-ID: <YSQROKTiMop9t2s4@debian>
References: <162600725917152@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="D6lwy4XoDMKepNeS"
Content-Disposition: inline
In-Reply-To: <162600725917152@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--D6lwy4XoDMKepNeS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 02:40:59PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--D6lwy4XoDMKepNeS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Treat-NX-as-used-not-reserved-for-all-TD.patch"

From f4d8a0e56d2455d28b55c573d51e1fa7f62d302c Mon Sep 17 00:00:00 2001
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
[sudip: use old path and adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/mmu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5cbc6591fa1d..c16d24ad8356 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3927,7 +3927,16 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx || context->base_role.smep_andnot_wp;
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
+		context->base_role.smep_andnot_wp;
 
 	/*
 	 * Passing "true" to the last argument is okay; it adds a check
-- 
2.30.2


--D6lwy4XoDMKepNeS--
