Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA437BB2C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELKqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:46 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42943 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELKqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DA4EA12DF;
        Wed, 12 May 2021 06:45:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pkwUIP
        n7rT2IfjsBKYgZZgbKtiTXSoTYhJTuKMFoffA=; b=qsyz/7LNzeBtBpsZEWdFUC
        VP2TjstAIsCk6zvagtzeGPJ1kVmJMNAvSq9/HJpMy7pALeo/FkT5E+xWMdPuy3r/
        QAa/NV5Oy+NA3JfAEwbcLQRySwpies/OHEealL6SiG1vLbigC5xTIuVKBgbRkwp9
        e1Wgb8pXcNO7i4K6PRTenIfZv3gAPA/ufBLQ6rK6b6iVHuXM8qu8MQaWE4OQ0LkS
        WjE+Tj4ooL+hffIJVmLEccqKoPXrM72wb19SR89LMePDPEQ56AN8rMA1r89ZSdX1
        CkRADayIhzSF9mP1ePz3NFEJAYwCPf5DW90OudfOeLznEfjUR5RNY1kt2QvQxA6Q
        ==
X-ME-Sender: <xms:0bGbYOXzjKPhdFkBXzdtxdUrXOPGb0mb3IHSguIq0bMGIZ4vw26Vqg>
    <xme:0bGbYKmyNfsl-EQKuhXwIjWnzU-oAm8B9ks8ux0V7qh4sw3oRIIzFAxSPdoTHsnw5
    btsYHSKKOFNCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:0bGbYCZAjW0gPNMIZagMtmYAdIqJkHryWHrOqFTrSY5OTw-bfQIzyw>
    <xmx:0bGbYFXgseh7Wdy3O5McchHv2h4R2wOGBrRT17crg2MEmFLci_DpPg>
    <xmx:0bGbYImm6KN9HyHCAalhqC7kHb9NvqV0T2cCGfaCl9PKRgEp0JPTmw>
    <xmx:0bGbYPv71-F-FvQQr-HMy-BzvJ-_9Y3rRGq_SobA3NjKdY3xNFd1arEL9R8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:36 +0200
Message-ID: <16208163364429@kroah.com>
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

From ee050a577523dfd5fac95e6cc182ebe0293ead59 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:24 -0700
Subject: [PATCH] KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check
 in !64-bit

Drop bits 63:32 of the VMCS field encoding when checking for a nested
VM-Exit on VMREAD/VMWRITE in !64-bit mode.  VMREAD and VMWRITE always
use 32-bit operands outside of 64-bit mode.

The actual emulation of VMREAD/VMWRITE does the right thing, this bug is
purely limited to incorrectly causing a nested VM-Exit if a GPR happens
to have bits 63:32 set outside of 64-bit mode.

Fixes: a7cde481b6e8 ("KVM: nVMX: Do not forward VMREAD/VMWRITE VMExits to L1 if required so by vmcs12 vmread/vmwrite bitmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0f8c118ebc35..f93ff2302b4c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5745,7 +5745,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)

