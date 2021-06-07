Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED2739E912
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 23:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFGVXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 17:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhFGVXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 17:23:24 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045C4C061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 14:21:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id q5so19204873wrm.1
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 14:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dI/hok7hmHOCScE88I1DXngUEAXP+DXOPdslRdvjrts=;
        b=FSWrLM2RO5VCIJRIMFav+hwlCw/EN6VyzVGiLVvMq8GzQDflSOR2ljfdR8blctxzlB
         bJ9TzMzBondrYUkfrPUFDOe3x2381PKzOFTVVG8NbD9XPbRA+3lEVzfmRI9w9C8s3Hdz
         1YtRlrAuNbM18Dk98/02UlcudC4YbjJhVJXUjXeTDXLRYdCXHAcPLb8qJLnFjdHxtMV+
         wvZkbydUGl8pwQ9F4UZnn6kR9bNY07fojy0XLOnSDi7pP5RdSjx6z23kalaM+pHdtfNy
         ig+3UIeKPEXt07iFWNdLdm+pkxRdmeTTiol4l2s0KfFvYqGYFxwy2gFuARbRf4zeRs/5
         UKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dI/hok7hmHOCScE88I1DXngUEAXP+DXOPdslRdvjrts=;
        b=Si7wELobMAYYyd7NwmsX6gjNiwbWufAAMCgqzNDMmZvtBUfkeDb4ei5PwNqYT+jU6f
         QSYbsL/ZSu49uxz4FRcXwNhpFYQJS8kf+5W8SsIHwktmoOc18+CgFxo7Q+P7LnDHXEVG
         g/9yaC3xRbWcBh8kezK1ju75PgDLo5WUzs5B4RwREmgSy1BDD6R689FqpNI7vfWYPrQH
         E0A7jdjeO9IhbL4PqYH3I8i9hK+/WetMTfrkf6vnlhKPu5A4adZCBeAC3EyVLXXu+MrO
         g9RzS+yHSBE4f5DdHHYkgIutSBgyLkq1O5nPrdSJ+j8hgE0EwMEcFD6DVE7jDGezYDdW
         GRmw==
X-Gm-Message-State: AOAM533mkuy0YXs6Cm8uykCmyPZoD4qCNHYmqy8E5HN+GouCiwI5YtYd
        AryoVqI6PdFEtmvFTmX+qFc=
X-Google-Smtp-Source: ABdhPJzat+zrycIOm9OSPDDu7Qt/zbsQcmVtwIxqAZOD6W4DgEWZDPGYDp1/TLWBiPOvPzuwiJJKmQ==
X-Received: by 2002:a5d:540b:: with SMTP id g11mr19767517wrv.390.1623100878629;
        Mon, 07 Jun 2021 14:21:18 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id p16sm17828772wrs.52.2021.06.07.14.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 14:21:17 -0700 (PDT)
Date:   Mon, 7 Jun 2021 22:21:16 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 5.10-stable tree
Message-ID: <YL6NzCG+GTkrYiXM@debian>
References: <1620816232242252@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tMDsIcvW7ytjEVb+"
Content-Disposition: inline
In-Reply-To: <1620816232242252@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tMDsIcvW7ytjEVb+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, May 12, 2021 at 12:43:52PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backported patch.

--
Regards
Sudip

--tMDsIcvW7ytjEVb+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Truncate-GPR-value-for-DR-and-CR-accesses-in.patch"

From 193d4aab68376c85d4bcf59ff96e248b9f84836f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:22 -0700
Subject: [PATCH] KVM: SVM: Truncate GPR value for DR and CR accesses in
 !64-bit mode

commit 0884335a2e653b8a045083aa1d57ce74269ac81d upstream.

Drop bits 63:32 on loads/stores to/from DRs and CRs when the vCPU is not
in 64-bit mode.  The APM states bits 63:32 are dropped for both DRs and
CRs:

  In 64-bit mode, the operand size is fixed at 64 bits without the need
  for a REX prefix. In non-64-bit mode, the operand size is fixed at 32
  bits and the upper 32 bits of the destination are forced to 0.

Fixes: 7ff76d58a9dc ("KVM: SVM: enhance MOV CR intercept handler")
Fixes: cae3797a4639 ("KVM: SVM: enhance mov DR intercept handler")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d4eb114613c..41d44fb5f753 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2362,7 +2362,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2408,7 +2408,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
@@ -2439,13 +2439,13 @@ static int dr_interception(struct vcpu_svm *svm)
 	if (dr >= 16) { /* mov to DRn */
 		if (!kvm_require_dr(&svm->vcpu, dr - 16))
 			return 1;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		kvm_set_dr(&svm->vcpu, dr - 16, val);
 	} else {
 		if (!kvm_require_dr(&svm->vcpu, dr))
 			return 1;
 		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 
 	return kvm_skip_emulated_instruction(&svm->vcpu);
-- 
2.30.2


--tMDsIcvW7ytjEVb+--
