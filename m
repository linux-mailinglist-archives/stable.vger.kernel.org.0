Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330887162E
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388962AbfGWKgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:06 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:38291 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 191C04F9;
        Tue, 23 Jul 2019 06:36:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=o0lWNe
        BU0le80Bpe+Ooo4etzk+mqqtbHvgXtip5N9h0=; b=TTN75jZ8gzmAEjQcsgQLAe
        +LoC3mG1VLTHlENmN1Wbf58moRLQDvN1dcjVTNAySlemKWhokHtVKKH04J1QNZx3
        XDLMnJWQqR3eFRi/9G9WyC9LopioaNrxd9ev0/qmrYRVrgl+/pu9j/ssrHODsTCG
        dusvg8tgQ5RG0U8ZNiTDbe5FRbl3LNvgRiMSXOeHCI2EiPFMVgYFoU8coEmZwrNf
        F8dtKDE8duyifbKKyLgrMQvcDbSXcY5xac6sUVQ/iBW7Gwf4PEhcb4PdXImlo/6B
        TepFw2bPxllJMSGqgfjlHIPZr3ax9A1aTTf8UTv780Fz1T3/G6PPLszko3+ACuyQ
        ==
X-ME-Sender: <xms:FOM2XakDwLaQd-gamRMvFx6U_oQ1_jZllQnhsuJWxcJkGfUVARCUMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:FOM2XXjz7_UiGZ6S9Mc_nsK07uuvBSV0Dlfk7RI-lhGPLZhyRzYa6A>
    <xmx:FOM2XZ2M4RPORaQ65nekVcRfechg1sc27aXz2Luyy-_WwdSWCvTtVg>
    <xmx:FOM2XcYmmim5sIZ3TAh79Dwxb8DmA-YOiDdVcs6PRYcpG04uxylGuw>
    <xmx:FOM2XaHIqVZjBlMrUwlQ3zG0HckxNc2g4Ex-yMDg-WMBV1WfQmfYtQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 221DC80069;
        Tue, 23 Jul 2019 06:36:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: check CPUID before allowing read/write of IA32_XSS" failed to apply to 4.14-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        tao3.xu@intel.com, xiaoyao.li@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:33:48 +0200
Message-ID: <156387802813638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

