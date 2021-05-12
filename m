Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B260C37B88A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhELIvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:51:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46525 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELIvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:51:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D5279140C;
        Wed, 12 May 2021 04:50:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ycJkHF
        dRzJcTYVKOyGxyVYQNKAOmLOt1lKtzA43dqBI=; b=jHLJ9Wojvj+r1qYZTr+d1Z
        8JAdGv/7KRBvPSm3kYGWnDzBWZv6P5jEj97E/EiCLMBCEajALhEPXlq85pC3ssqG
        /qmY4FfKD4J2WZpwAwtDYFAY4RuVexPauRd4zfj5EnHp27SPidTF10VRGXpvAuyG
        bZc4l8YYBX2w0pWVwcZTbqWLi1Eb+CPXjFEAU3WT/23WTXkMs1fNkLtW9bngtvV9
        jB9byq5qazcQoWnKikZbF5lfwbThopjPaVqv1CUeERtAOyVgrX19zGrfN3Rv3xDl
        TRq1/UceEUn8KKIAy4+kJOCYXpBZ2RR4t7wn8llELH8PvPyYOg2oG+d2jjwkFoig
        ==
X-ME-Sender: <xms:wJabYEyI-tDvMKAgqbWSzXHiBSsOV9xQUJSC22Ob8_reAxRUFCN3vw>
    <xme:wJabYIRsJueWf_2j61AYIxqDqcRY6hjlAhD5SKbUTZLQGec0fR9AVdckGaoS2i2RA
    T4zk9EsbSyF2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:wJabYGUk62mH9OeQRfsn69-imT0Yti2lgMGyYR9rS0SKL29-e1j8dA>
    <xmx:wJabYCip0MOybrOFhKbNeEdpqOoe4TjVrHufCd_rYFWhXiTYIpNjMQ>
    <xmx:wJabYGC69bRbaD8POscG8TajTT6hwpGDsdL4mSORpoluC0ZPblTSCg>
    <xmx:wJabYBqJ0NgW5hyT5fTXY9OxgTlhuUnEBJx8MbFJit1PnaeUAnJPz7mB11s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:50:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Defer the MMU unload to the normal path on an" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:50:06 +0200
Message-ID: <1620809406739@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f66c53b3b94f658590e1012bf6d922f8b7e01bda Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:58 -0800
Subject: [PATCH] KVM: x86: Defer the MMU unload to the normal path on an
 global INVPCID

Defer unloading the MMU after a INVPCID until the instruction emulation
has completed, i.e. until after RIP has been updated.

On VMX, this is a benign bug as VMX doesn't touch the MMU when skipping
an emulated instruction.  However, on SVM, if nrip is disabled, the
emulator is used to skip an instruction, which would lead to fireworks
if the emulator were invoked without a valid MMU.

Fixes: eb4b248e152d ("kvm: vmx: Support INVPCID in shadow paging mode")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-15-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ef64959a443..5c235b4dd74e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11504,7 +11504,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 		fallthrough;
 	case INVPCID_TYPE_ALL_INCL_GLOBAL:
-		kvm_mmu_unload(vcpu);
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 		return kvm_skip_emulated_instruction(vcpu);
 
 	default:

