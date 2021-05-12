Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4337BB27
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhELKqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:31 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52459 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhELKqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 623D812E3;
        Wed, 12 May 2021 06:45:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:45:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YYoror
        hdBmEvQj9awMmk0mzZl0xjl1m7b3KW8+Pm4RI=; b=ZGFFsDBOln4k6MFpmPK24S
        5EfN4+HjHWt60w3t5m81sTX5hBHh7c6IlGE08nay4CWtu8UElVtiHzHJSKSj1cBA
        fhFWkECqqf2PjSYuxZYoKIDAgaZurwxm1kY6dfOfQUnumL6JNcc622QObsUDGv0m
        Sf1TtPKKt5zyMTzh3+6mTCqao0iDbfRMbvwLdKDGbaVrKf8f6vj1BuIio1li/rPP
        wALe4nbh3CngDVhAp9aWHWwphNzxoheXk0Ru5UHvc3wtHfCIZNlbLdCirADMM2ja
        xLEyuzAsD75tJgcBU7DZaOlwiAUc2zQ1ErZskgjE8dRWv5cKe5uUvdv0QanixGXA
        ==
X-ME-Sender: <xms:wrGbYJxh47TsD0IbL9-9-ts_QwqE6KKFSdtzsWGfO0TjIh3cIIWPYQ>
    <xme:wrGbYJTTSNpXsjxi2Z7Ou68q_uV7tkUYakCFovv0ABvVzvB1I_nO_pd8MvZCK2hi8
    xUKQpc9W3u0cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wrGbYDVm6boLtGst1NTIjsPRrogoZ03TV7WmELqBcBYMW14EkALmkw>
    <xmx:wrGbYLiO87rwvWn_sg8lhIAxZXwDbE-6tO5Ma_6m1XDXRPYlVxDFwA>
    <xmx:wrGbYLDY0MlujHz0AtxK-lY7kKfxAXEBu7r3LjidODKXW7Bz-t5Y5g>
    <xmx:w7GbYOo0h-fwWGYlDHkjzrJpSWkQq9LHokLgxaol_5Ddo1l4nqEZL6BGSNM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:16 +0200
Message-ID: <1620816316224214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

