Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49737162D
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388955AbfGWKgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:05 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:43907 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 181B45D5;
        Tue, 23 Jul 2019 06:36:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=eIEoD8
        UMVg4DrAVBwjwuwVmzRIaolibU8x0ilzRCdUY=; b=TsBFstlUjAbXH2zImz30pX
        yx+qNkwiGpmMtcMstO9vvyUGopvTZB0MK16LzebttOmToNki0t8VHTxxedtdd/zC
        J468rsBsIbMpPUndu2etKE0WKdi/S4JIhgrG4OS47TESCY+MrOV2iSXk482ANHjR
        +u58J1jAb/bqL+SrNmxmh8mb8DwwBo8UTt5qfJWuygWP2iOf57YJwah14Ojf48yE
        KujDgANt2Lkxmu7MgyPkWc9kB1C2KAlmjIAmxFhxkNBBAqdXHi4yTTJyzO+1flmr
        k7lwnC+RXkvKZDo6TN/K9Iq8+LEBvufGNXZZMPSKPS5dN7uFLE29pD3/4g3C13uA
        ==
X-ME-Sender: <xms:E-M2XWdit6LiVRDTgnGTVdEWeN9hJ3g-o4VHZNNdMczV-KEly6NUaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:E-M2XVFjwhX9M_DQm-3lLsXqAFohbEqTXOHq04J6UtyF5fh815hTMQ>
    <xmx:E-M2XVEg1w30MdimwxR7kDFVXM0woKyOYi4Al6xzeno8hVzRAyJQkQ>
    <xmx:E-M2XWBY8ECNaUp0hVASgcSLPZd9wSItZHOzcwjY5Ec-NXCndqC8Ww>
    <xmx:E-M2XQM-ByNlrCheiBcqrJ5G78ypWbU3BKDNKY6B13U4aKC4vGwxyA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E03780063;
        Tue, 23 Jul 2019 06:36:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: check CPUID before allowing read/write of IA32_XSS" failed to apply to 4.19-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        tao3.xu@intel.com, xiaoyao.li@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:33:47 +0200
Message-ID: <1563878027174207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

