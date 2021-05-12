Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D8537BB2B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhELKqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33043 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELKqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id E043812DF;
        Wed, 12 May 2021 06:45:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:45:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tlrhrw
        UKgpyI/O5vHfdLsfHV1aoYDawY7jnJjZR/DtQ=; b=IMZuzJ5qTosSQ2hUS9f1gr
        at8GOraIQ97kywfbmU3U8rWSGnXMeXNfJ5jX8f9WX03NxTQOx5U2KfYGesv+QpoN
        5QK6ezLLCUtuHm0kgE6SzqiMQ2PQJ/Er7rsnpgSIGGewdvFhwz/6vo5J1PLi3Nx8
        EqRmAF27cRj/O3+AuqE/gII72CtY9F4s8U/kKwcb414MbscFOMXJYPOZbUOBhTpw
        +dL3AxWowWP3n2uOfyjHTomA0+6u18XPVryfqm07XpJK116MYOWNzT46LXj1mTjH
        LnZtg9RAnxDjz2I0r+qQJc2xwaj1I8crqgjbh/pF6ZdvYP3Uyn9pRw2H9Q6ynNSg
        ==
X-ME-Sender: <xms:zbGbYKuAcFFFe7TY5qrnltF9VzdLrAM9nHujY70SZ_OLhx5b6VJx0A>
    <xme:zbGbYPeGGvDPewAOIgTQ3E9TpjOSFLOHoH6H1xym3qZkFJVilAUEb75n5dJHTWoqO
    r-dauuNCTW0rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zbGbYFy5oaWkK7i4tKlC2iOblBaZTonwuDsVLnHEwAQs5P5fHnQwHQ>
    <xmx:zbGbYFMAGMC2vKjKs0gQ4DM3DnbW5fBa4m9_2l6GfK74YLMeOW3sxw>
    <xmx:zbGbYK95St1zlyKk3lfZ3XUsOSux4JtLKj76wqRIompj0b7ldSK74g>
    <xmx:zbGbYPElkuL569utN6GZSBo6GelwKZUhiccPX5CKFpNcTTwIdMkShRq2GHg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit" failed to apply to 5.11-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:18 +0200
Message-ID: <1620816318179217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

