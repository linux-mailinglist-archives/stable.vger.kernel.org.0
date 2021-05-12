Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B172B37B88B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELIva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:51:30 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:39059 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230291AbhELIv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:51:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5E2A313A3;
        Wed, 12 May 2021 04:50:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xQBDqF
        AmB1x5VWB4eLN55/65ciTBNzQVMotNaCEWdSA=; b=FRRmMmcBJWl7n49p3ymqt0
        OL4qD+4FQYeBz0wKamkrgMNd1ptg1Znmk5CM4dcAuXkyKXni8zffHsza7W0Md5GB
        c2QpzByNUp6rVgFCGd883blphlXuDIhslEAip7/faPTc8VySK2iiGQ09jbNRwEHh
        cj7nO+vCBzmOJ5+nmZbQ7rvj9+FpxR//2dLdJvMjPTqs1fbhCgSMbZEKDdzZDXnI
        1rOvZCApMysAaqxtTCnrtSI9Lmw3jFa/zFy1cscFBv4+Qm4wuKJYhneOhnAqxvSx
        LchtLI13gnnr8gH3V92jHbgKrLnIQMFO0AXTGAigesfuaafuROcfnIZlTE5fVQNQ
        ==
X-ME-Sender: <xms:yJabYKiL78s8y3LYtJMeo9IV_vSTUZgzFsQGqOTciYnKYaFvcK4yzw>
    <xme:yJabYLCCTcMy90UzxuFgAomCog06hYgUj8W8MZKwNZRsxE9_aEZJZjODoI_F4_B3R
    b77aDCLVv0QOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yJabYCEdC92--WkNKy6IDOXmyhC2Tw3yMWtvTftnHztcQz-q7LiM5A>
    <xmx:yJabYDR5Ntdjd3Tj35XwZ6yIYgxJscshlJQsl8ADaRLdYbWu82Uhag>
    <xmx:yJabYHwXSqOMu3i81qSUMNfBuWKK2cUcvbmULaXA-GMJGah90_hsaQ>
    <xmx:yZabYFZdmEIh3Xn7CzjRGg2vhhf7yxj-hnLx8A3MhRr269Xtuq2n4_zdjTY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:50:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Defer the MMU unload to the normal path on an" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:50:07 +0200
Message-ID: <1620809407109168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

