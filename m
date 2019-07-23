Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D787B7162F
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732573AbfGWKgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:08 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56929 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 71D3C5E6;
        Tue, 23 Jul 2019 06:36:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pSd0Ak
        W/LCBPn44H84OitA8Nmn4h8dx41/OU/UoCO8Q=; b=q8rDhRgqICgjpizVcIkDNZ
        or9TqmugIunw/bkxnmDZLYhGGAqFh+i/hBeRwtbwuvqVwka/5oywlJwq8GnIa7dJ
        z7ee4Mc2PHjReWJhftZt+Oaj8Uoeu3VW/8HJpxsHbNb0rt3mrBhZhK9Xs4ye+Dd7
        1oKiGufOZfRZpAAJ6WZglzjRsYInPmeN4J3aP96T3vufh0ifrY3Y5k3cdSAaVTMw
        8mMWiJEI/IU3gizJfgsBGiEs21wGtlSM4qNDmLUJD9fxPdX7brSKmzcDGtzBRXR4
        SSWH0F5+ISvEP9JZsNLEOpkdTYRoQP4LKokS5JObrkPJpWfrZ0YXTJa983lsrvog
        ==
X-ME-Sender: <xms:FuM2XYBSWiyUPuEy56JCcVdCrQJeUnqA_5YPPdghGIe7RM1T-l2m5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:FuM2XewVubcErPHZDvq9YB3HGnNV9Zy_HuCyL7OR6f3FxDYzaZ8-0A>
    <xmx:FuM2XWlKuyL41PT4WLxGEEw6H-ff3yKGAuJ-PM3hrOg-YvoEisEQGA>
    <xmx:FuM2XTEOZMTrUFBViEhG1eBUS8kFeuFWROSrCjLiOYrW_kQOLyMfow>
    <xmx:F-M2XbR-YnegtZieSwZ0qTMHsWXsWd9Z7esZiEK2oBBm0rDllN668g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83491380074;
        Tue, 23 Jul 2019 06:36:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: check CPUID before allowing read/write of IA32_XSS" failed to apply to 4.9-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        tao3.xu@intel.com, xiaoyao.li@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:33:49 +0200
Message-ID: <15638780291085@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 4d763b168e9c5c366b05812c7bba7662e5ea3669 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Thu, 20 Jun 2019 17:00:02 +0800
Subject: [PATCH] KVM: VMX: check CPUID before allowing read/write of IA32_XSS
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Raise #GP when guest read/write IA32_XSS, but the CPUID bits
say that it shouldn't exist.

Fixes: 203000993de5 (kvm: vmx: add MSR logic for XSAVES)
Reported-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Reported-by: Tao Xu <tao3.xu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b939a688ae83..a35459ce7e29 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1732,7 +1732,10 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -1962,7 +1965,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!vmx_xsaves_supported() ||
+		    (!msr_info->host_initiated &&
+		     !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
+		       guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but

