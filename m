Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23C37BB2A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhELKqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:38 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:46073 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELKqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id ADF5912DF;
        Wed, 12 May 2021 06:45:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WIwEOA
        Um2v4tFMSCtHOMoJZPb4tLnEPPBYgUjVHiQy8=; b=f2h6rev99IrSB7xi9SsyGh
        4ss0eAEAW/sI1KZDosmov8Hy0Cx45jhuqCUsfr6EG/Vsmuuji7T01mjRNASRh385
        rOILAM/VZjf7pfNe7v4SnSnjia2yxZ7qzTPRwbvGwc51xlUiLANEtg8REoTS0iZV
        O4dnX3Tg3JbEkqRxAi+QheugvP5gPgqq0GK5IlrWUKsL/WhD9VoWHjzRbysePjfa
        MUXHkQq8N8y2OP1h+D1adQpRJay2NAmNsiq3QVgsWOGZMmSRyHAMEOkVXHkezbrk
        4fX+KUGbZLfUO8kGRRdJ34Y6doUgM0qolDPKZQMIUYrax2S6SXcEx7b5DAqmSrdg
        ==
X-ME-Sender: <xms:yrGbYGqaurGPKISwUcNkYr1ngH_5MbOcDAyhFfeOUhuiS8VOLQvL_Q>
    <xme:yrGbYEoX3eAGdHQ0yZRnK8a9uGutxBk_cuD-iAWuyK-zvmF5Fxna8NiSTTJ2F4-Il
    0nn4hovzOB14g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yrGbYLO-p_zP7j-1mrpNk2I9pQFIP6GRAUoGITepkj5-y_B7v25vyw>
    <xmx:yrGbYF5wqJQJGTjUZGAdB5niR4Y7ShQMF_d62j0zIrrweaScebl8OA>
    <xmx:yrGbYF4QmPdW-OdoaC17--TpcMrjAXjFiUWQJ68oV2ugsaxg7oNQZg>
    <xmx:yrGbYCjfPKblKAupk4GV3FdWTxKQ_2yrQtpyxY4QlWTpDLsj9UkjyEgSxog>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:18 +0200
Message-ID: <1620816318881@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d8971344f5739a9cc53f91f1f593ddd82265b93b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:23 -0700
Subject: [PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit
 mode

Drop bits 63:32 when storing a DR/CR to a GPR when the vCPU is not in
64-bit mode.  Per the SDM:

  The operand size for these instructions is always 32 bits in non-64-bit
  modes, regardless of the operand-size attribute.

CR8 technically isn't affected as CR8 isn't accessible outside of 64-bit
mode, but fix it up for consistency and to allow for future cleanup.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index edc23c77be32..64354b009fe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5121,12 +5121,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5199,7 +5199,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));

