Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989EC39E93E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 00:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFGWDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 18:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhFGWDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 18:03:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66226C061574
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 15:00:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a11so17395139wrt.13
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 15:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m2rd2kHCOHiwNNyAWc0xQbQ43JwiEWvx1jPRRCT9/1o=;
        b=AT+uOO75v94xQX9hr2JW76D8ICzehwEulbcrPNNypdgR4A5Ze4cdQCBtAJHZ2uSceH
         S13Fex+27IF2VWlWaqTERaw3eJnGZBp/zufiuns8rFV4aAAjrRXMlks3O3NngMEbRVMD
         LXlcW+r0Tvezb2ztxOXi7WRUevqE4qyyhl8Vw1XgPcKlPWLOw+/iVYlIhX39VYcPFQg7
         L2RKbCsKUkuOQrMzXezOQd6i5IOZW/h+X6pHO6fb1fM9cFSrZGTm4xicjYwNgCaYcWjw
         segqwST4zO6PfEMaGnG751mOez0vnTiNmGV7A6MZ01A9ExhDsKCyrlCF1CAYAwd9iApI
         xLRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m2rd2kHCOHiwNNyAWc0xQbQ43JwiEWvx1jPRRCT9/1o=;
        b=hu3PB/oCVslkciwxqvdTkttb5b1gZJrW9zSne4SL+QiDjh4gPuXHh3/kPImaK6oMR3
         jxC4YFbx62idsMG9FKtoSVxJdI1QuPDZ/dcRYUxrswYzkZct+CkM77poc2/7dvHX8ukz
         7dDxIn51th1dxXxzQKN6kI3o/oxgBjQ6tTAQfhow+aC2dx/IXzM2fhWxQaCa+R8TeXIS
         N56xKHY+fW3JDYW/1TMUuPnqHLKy68y/sSeLqyZHnnkFySrLZv+RDPVprlaRhQIFJr8n
         FvVCsuIFTIinp8HyuJOVaD48yHDF7ecUuL9xfVvkgjAxrpCM69csRzrDKtm10Xl6isd6
         jMRA==
X-Gm-Message-State: AOAM5323bu2uXMk9D5BzlgfpkoXTch9UvO669Xo1LWl5eekjIBP8pk1i
        O0i4TYZkl8EUFUWAVh8A+xg=
X-Google-Smtp-Source: ABdhPJxuCX+Jnvn/YfyfnTfULvXu2/g3G8E5FIiF/xFLyZGBLz/vBz8yLIIN7+jRi9AwqRgB6SaaPQ==
X-Received: by 2002:adf:eed2:: with SMTP id a18mr18917458wrp.147.1623103253977;
        Mon, 07 Jun 2021 15:00:53 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id v17sm8927470wrp.36.2021.06.07.15.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:00:53 -0700 (PDT)
Date:   Mon, 7 Jun 2021 23:00:51 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 5.4-stable tree
Message-ID: <YL6XE/f1eiUma2QL@debian>
References: <1620816231461@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="it2H0wQg/bZHNgX7"
Content-Disposition: inline
In-Reply-To: <1620816231461@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--it2H0wQg/bZHNgX7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, May 12, 2021 at 12:43:51PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply till 4.14-stable.

--
Regards
Sudip

--it2H0wQg/bZHNgX7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Truncate-GPR-value-for-DR-and-CR-accesses-in.patch"

From efe812e4cf35ade1bb3680968ebb7bd0d41fd251 Mon Sep 17 00:00:00 2001
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
[sudip: manual backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/kvm/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b9d14fdbd2d8..074cd170912a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4057,7 +4057,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (!check_selective_cr0_intercepted(svm, val))
@@ -4102,7 +4102,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
 }
@@ -4132,13 +4132,13 @@ static int dr_interception(struct vcpu_svm *svm)
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


--it2H0wQg/bZHNgX7--
