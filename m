Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADFD39E905
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 23:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhFGVVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 17:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhFGVVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 17:21:16 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFDDC061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 14:19:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id y7so14540035wrh.7
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 14:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=blyFzK6xP5Kj+Zfmk2ta1vcYTb46gDMalLEb5SftMXo=;
        b=U2KrC+MlctREdRHIzwp21x7pVaSWdl/JqLjISLQHGrXtGeZ+80sob5ECTods99/zAo
         VPcLGSD8ony5mc0vMY/HpXc/cW6YfMx8hF3P6j+8YJ6gU2lbkO0afnhBw6dPqWRjxgXa
         orQxahavD7MlYweaWBJ3IS3YixS+MyH3/eBWOZSpvzl4pfFdYd6B9rH4hpFBhh10NpsM
         CE8WtddNwa6eVTAXikmQFVTkEWgeqItpVzX/96lxoY6PyF54KDtItiJm/u6f/RHnGHs0
         +WKkEwyObnFhkfhJxGBoylvpFmcb0EZgp+zZDtivifPzHmpQaZsszaSyuIzgsznNVVlS
         GlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=blyFzK6xP5Kj+Zfmk2ta1vcYTb46gDMalLEb5SftMXo=;
        b=gRkQ0qdS9p5WQqGVmw9pLtrP9uWHJfsCmsbm+c/FKdwV1UG+IBjm0s/A9FkpnNFbq7
         PCbQjeXkXtH1x4KV47qayRRGZHAPg0jqmY3hYJzBrsc3cHn4bAqkkA6HsG9pq6td+JvT
         oIGc3HS5T/aW+sOTT1Ep++Q9UT2w3KNqVu1xHjtlweNi1kMeXeA2QtfBwnZoQxkDAAMZ
         hjCfFVlYpohkbmgTdyY+vPAKLzNY+cTZ1wDAAeZ1qPfdyXpqKQUddClQteNUqxsTU6wf
         oJ5LvvLIrKI7iTRmLoXCyH3HwJPvJRg/YZ3ZnNPnAjvt9EkaxRKyohzM2krp9qw+8yiN
         hO/A==
X-Gm-Message-State: AOAM531SkoQpjRlD79BpoUCc4SZWt91njwfOT5B4LiswvSUREN0foULn
        w78qaJPoSH4sQikSSjmkvs4=
X-Google-Smtp-Source: ABdhPJxfkE6swCwAITPRxFJqH+30jSGHQb/xr4+o65GHqXvqhNAAzmk7cYhKLrsHwBgqd2g0Ba00nQ==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr19272559wrs.298.1623100762492;
        Mon, 07 Jun 2021 14:19:22 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id z188sm16147337wme.38.2021.06.07.14.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 14:19:21 -0700 (PDT)
Date:   Mon, 7 Jun 2021 22:19:20 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 5.12-stable tree
Message-ID: <YL6NWAqmcVqmbe8+@debian>
References: <162081623353164@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lZ+B2h3Gh3RnIaJ1"
Content-Disposition: inline
In-Reply-To: <162081623353164@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lZ+B2h3Gh3RnIaJ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, May 12, 2021 at 12:43:53PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backported patch.

--
Regards
Sudip

--lZ+B2h3Gh3RnIaJ1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Truncate-GPR-value-for-DR-and-CR-accesses-in.patch"

From 516f853bf3b71f89489d94f3234b77a9961c4619 Mon Sep 17 00:00:00 2001
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
index 9a6825feaf53..30569bbbca9a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2532,7 +2532,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2578,7 +2578,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
@@ -2643,11 +2643,11 @@ static int dr_interception(struct vcpu_svm *svm)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		err = kvm_set_dr(&svm->vcpu, dr, val);
 	} else {
 		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 
 	return kvm_complete_insn_gp(&svm->vcpu, err);
-- 
2.30.2


--lZ+B2h3Gh3RnIaJ1--
