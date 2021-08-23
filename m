Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52753F52B4
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhHWVUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbhHWVUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:20:30 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0A7C061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:19:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v10so16930739wrd.4
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Avl++N6DQGGADbW00h1y+Y25SgQB3tIoTVDONGuvsPc=;
        b=OiVPvlL1J62qW9Rmg9XZZTP8DUzXobpd+eMyliMDSccdRODpIJ9O1lXyQ4mTFJnTDK
         ZicrkYw6lGQg55Rqz4Vwb4E4ofXs76672KrqvR3Vm6wW1iWOc7BKWcW93MQcsuIPz5hU
         ja8SuT/EPK/ymNjrCC8J1a5yYlQuNvL6K7alGqY2oPJbqXlMXe+vLetXRaWDP2BL3m4S
         1N/Nr5X8dvDKTiqLl25DqCB59/P3aadU453gG/F+BbCVWI/49uRmgnYEpDf2LHb4yQae
         tOp4WOEGLpn2RhZ19Mq2BpyswMY7dOsY5BTg3FOevMRS6i8j6Vwfi8FcOOr/GeI0fBlM
         ASAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Avl++N6DQGGADbW00h1y+Y25SgQB3tIoTVDONGuvsPc=;
        b=WW9xsU4HML+XorIf+FTHCoIbCaCz13QkL7XWiJKicL79TIE+Q8jK/d4/pWo2428TY6
         6/wTjKnYbBWMDpLZK3rcwqHuVKq+b8GRTrhTYqTs8a3yo/zNKmNZjd6FBbHEH2TeA0oI
         Z0C3Q+PJVrLTobqXYGZEtEGcTTQyJn9+4ZKOoZB1whNH+W6GGN46sAnlF00moAELttq+
         s36RbtHGUMrOaHyuhRcnDSk3TMhs8jKCQBU7JdM+2OH32/Zl2ny4/hF7OkQACV3wJbsX
         E4S3LWSMOJVVtUgAc5zmBPuoOGMXXydk/l1r/DSuXTvFXZ7Eutl8hOhiUgHYN40XSp9G
         R5kQ==
X-Gm-Message-State: AOAM531giTNbi9xBPujLd6/NJMLXWTFnbcdaPTHmsc5QCh+4vENdys6W
        5ciWBkoLrpzB4wiRKlNXfvE=
X-Google-Smtp-Source: ABdhPJwIhVsc1fEeXQIYUNzHZQHu6nC56jAGTm799cCkXdqam/+u/Xb1eTlbU8HRrOVq58+qR6bHYg==
X-Received: by 2002:adf:e0c2:: with SMTP id m2mr13655833wri.115.1629753585587;
        Mon, 23 Aug 2021 14:19:45 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id k16sm298831wms.17.2021.08.23.14.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:19:45 -0700 (PDT)
Date:   Mon, 23 Aug 2021 22:19:43 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not
 reserved) for all !TDP" failed to apply to 4.19-stable tree
Message-ID: <YSQQ7zzRbv3Y4NvD@debian>
References: <1626007252169125@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nAhqs3pBhh9ZVHAh"
Content-Disposition: inline
In-Reply-To: <1626007252169125@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nAhqs3pBhh9ZVHAh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 02:40:52PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.14-stable.

--
Regards
Sudip

--nAhqs3pBhh9ZVHAh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-mmu-Treat-NX-as-used-not-reserved-for-all-TD.patch"

From 19073fb2fa74d528620a0f0a1e2bf442c14a67ec Mon Sep 17 00:00:00 2001
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
index 762baba4ecd5..0cb82172c06c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4557,7 +4557,16 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
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
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
-- 
2.30.2


--nAhqs3pBhh9ZVHAh--
