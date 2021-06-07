Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD6139E947
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFGWIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 18:08:15 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:55216 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhFGWIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 18:08:12 -0400
Received: by mail-wm1-f42.google.com with SMTP id o127so566917wmo.4
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 15:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=163SqipTaPg+PcW9kBC8+x+G84vF8V3r27M2sRzbByA=;
        b=B0k2Q/+tjKs+AJLiP0W5MHSF43zZ78cXvXajZfaM3a8VGT1wQyIdaKOgjivdg1T2LY
         5BXs4vsgXC9CQkg+o7pQj3+/2VBP9YD31wbyYRdXH14KAJQdQD2jGMjTL/PbM1AoG0IM
         FdgR2edhcjKBLorZGnT4xGnyKRvxiK1dW/Cz1Wsgg/Fo7rZGMLEQkyI+Hkz/1ZiMj380
         v/aAYAV9qdjmjdXNXUYarJtYr70ICtFp3J8gwE3Qnk0/i8+QbZsT/VEopwRtQRVJr3iH
         hGwiikChR4WkqyS5aYxR3WUBCVIyTtTy8o0uWozBrOvk4wWvS3XlagXJgWwOJUEOn2/i
         QqEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=163SqipTaPg+PcW9kBC8+x+G84vF8V3r27M2sRzbByA=;
        b=OSXTeMYGac818iAhB3F/iKikvR/ozAoMS/CNRszCDfHLiof/2JPloV1PDiGaAlJdqC
         j0Gu1JJtsE0P0WRbXIhQlVD0QDUoQw3l/6dfD10JbfHFzTKG8CLxn3nBHz+pAY3SSNDa
         bkfzDoNQeY761Whkn/JTMRRbuXy1k0YStamDcmHtQ+8hvos0Ta8lWz6DMgAZSxOZIhs5
         9k216Gp+t2Cc8uPZ2h1FH4HHP7Tx3xri3uGxU6KstKbH8Z6fWa4+xhvIHRlQ2O8T68yP
         42RKd10/3Hi4yDl+O2OebdLbqrSjvSRoDI1ovzlfeKhZ69P4qWJ6P+KbTsOgakegblvT
         vRtA==
X-Gm-Message-State: AOAM530KjGOWPS162iv/Qfzq1KkQIhsI2ggZK8RW8l1gciSsw1u3GSvu
        pQUPIVTQ4PFI8vsiYU/XfWQ=
X-Google-Smtp-Source: ABdhPJz9LGc9nUailOzXXV8bLM2DhLjiSv7jqX235TRaXuSsXSwVdGrsydftmH71IHkHN7m7I+HpdA==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr18457448wmb.112.1623103511680;
        Mon, 07 Jun 2021 15:05:11 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id h46sm20118919wrh.44.2021.06.07.15.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:05:11 -0700 (PDT)
Date:   Mon, 7 Jun 2021 23:05:09 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     seanjc@google.com, pbonzini@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: SVM: Truncate GPR value for DR and
 CR accesses in" failed to apply to 4.9-stable tree
Message-ID: <YL6YFT2yyafXXXpM@debian>
References: <16208162305199@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mnEmxFYGixrcAK1l"
Content-Disposition: inline
In-Reply-To: <16208162305199@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mnEmxFYGixrcAK1l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, May 12, 2021 at 12:43:50PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will also apply to 4.4-stable.

--
Regards
Sudip

--mnEmxFYGixrcAK1l
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-Truncate-GPR-value-for-DR-and-CR-accesses-in.patch"

From 89ffde7c080424821a70783961a7ab0dec90b9ea Mon Sep 17 00:00:00 2001
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
index 29078eaf18c9..cbc7f177bbd8 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3412,7 +3412,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_read(&svm->vcpu, reg);
+		val = kvm_register_readl(&svm->vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (!check_selective_cr0_intercepted(svm, val))
@@ -3457,7 +3457,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_write(&svm->vcpu, reg, val);
+		kvm_register_writel(&svm->vcpu, reg, val);
 	}
 	kvm_complete_insn_gp(&svm->vcpu, err);
 
@@ -3489,13 +3489,13 @@ static int dr_interception(struct vcpu_svm *svm)
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
 
 	skip_emulated_instruction(&svm->vcpu);
-- 
2.30.2


--mnEmxFYGixrcAK1l--
