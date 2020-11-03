Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C612A4FDF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgKCTSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:18:54 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38983 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729484AbgKCTSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:18:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1F5F91942B02;
        Tue,  3 Nov 2020 14:18:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:18:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=i0b/Al
        jAf9LAI28qmF/VDPvHNk1EYMH2nPuk0eILLc0=; b=KkpX4UZN3WLBdqlo+fQN8M
        s84ua3/h+ZY/whPjE1zuUzvwwiSX1DPaEKALzW1POmNW5zL3i4TU744emf/qMzZT
        A3uIyfLailhp0Ttp5+7nf9USvk74+jfIulptKHRrmDm2Mw0ATn7EpT5ag5HTlWAy
        8TREccctMwuS3WA7u6rLBSmT8VHGNdmjqwuZOrZd4eWFh8wEBOtm2KDz1I9KyU0Z
        bVbPevRAC3IrAYBaoLsrBFL7tjhjekyFhv0awk/It4RoNEdGQuHd07kaDc2nlHfi
        JB33wOAn9fOtWejvwJmsxZJeKP14V8g4lBOnNk3wMzeeJ4Wylt2bakLtRHERlR6A
        ==
X-ME-Sender: <xms:G62hX_rf9G90ng_BseQwD6ZWdgQDm54NTzE2iBTYvLs6-nWHeAod2g>
    <xme:G62hX5oV7Dq8bWbnJkUgn9YMxQvVi0P0p-pJCSDL9mOEsyuE6PfprSikiOma__dOr
    9p4c4ZFBy9tRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeigeehteeuvddtveevteeihfeukeelvdejuedvtd
    euueeuuefgffelfefhfedtueenucffohhmrghinheprghrmhdrtghomhdpkhgvrhhnvghl
    rdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:G62hX8PmRZ8nnctremb1a1x1qkPcCcRy_fPnMTjtcLwM6jGTQemzGQ>
    <xmx:G62hXy7fvbhxFJmX8ocs241Y6xDrt_bsCBWURc622oyGSp4GNLtypg>
    <xmx:G62hX-4eBx6P3q84_7S6YEgl40GhKrLjiu6-egH3qm4Krbzria3DPQ>
    <xmx:HK2hX0nO0XiLRbj-ltRF1ujMxLuO15cwHvrIjw8e3BWiaCIpomrbew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AC4E3280108;
        Tue,  3 Nov 2020 14:18:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return" failed to apply to 5.9-stable tree
To:     swboyd@chromium.org, andre.przywara@arm.com, maz@kernel.org,
        steven.price@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:18:50 +0100
Message-ID: <160443112958151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1de111b51b829bcf01d2e57971f8fd07a665fa3f Mon Sep 17 00:00:00 2001
From: Stephen Boyd <swboyd@chromium.org>
Date: Fri, 23 Oct 2020 08:47:50 -0700
Subject: [PATCH] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return
 SMCCC_RET_NOT_REQUIRED

According to the SMCCC spec[1](7.5.2 Discovery) the
ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
SMCCC_RET_NOT_SUPPORTED.

 0 is "workaround required and safe to call this function"
 1 is "workaround not required but safe to call this function"
 SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"

SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, except
calling this function may not work because it isn't implemented in some
cases". Wonderful. We map this SMC call to

 0 is SPECTRE_MITIGATED
 1 is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

For KVM hypercalls (hvc), we've implemented this function id to return
SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
isn't supposed to be there. Per the code we call
arm64_get_spectre_v2_state() to figure out what to return for this
feature discovery call.

 0 is SPECTRE_MITIGATED
 SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

Let's clean this up so that KVM tells the guest this mapping:

 0 is SPECTRE_MITIGATED
 1 is SPECTRE_UNAFFECTED
 SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE

Note: SMCCC_RET_NOT_AFFECTED is 1 but isn't part of the SMCCC spec

Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://developer.arm.com/documentation/den0028/latest [1]
Link: https://lore.kernel.org/r/20201023154751.1973872-1-swboyd@chromium.org
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 25f3c80b5ffe..c18eb7d41274 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -135,8 +135,6 @@ static enum mitigation_state spectre_v2_get_cpu_hw_mitigation_state(void)
 	return SPECTRE_VULNERABLE;
 }
 
-#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	(1)
-
 static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
 {
 	int ret;
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 9824025ccc5c..25ea4ecb6449 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 				val = SMCCC_RET_SUCCESS;
 				break;
 			case SPECTRE_UNAFFECTED:
-				val = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 885c9ffc835c..f860645f6512 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -87,6 +87,8 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x7fff)
 
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\

