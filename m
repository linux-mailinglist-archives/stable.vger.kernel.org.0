Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67F37BB30
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhELKrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:47:25 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34719 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230185AbhELKrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:47:24 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id D6818FDB;
        Wed, 12 May 2021 06:46:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hnrVIL
        aMpHqyuNTMA/TpiM9nG7voM51xuZDNT6LjeAw=; b=DemQqdsf50fE33WlOg3hcB
        CNKPmTrgnUm9qNmFOQLZ5lnZTaAkf0UBbOvtZu6ojnPT9JkD8tm3/4aJYc+DuzTw
        gyF78gojhyvE4p8aMrVRf0aDwjv+Km8z+KM9vUH08cqPwgxMHVS3W7ng3t6Ry8pb
        2pxoJ2qU4WC1SU+1avYFnFTAi1zZjcoollKTG7VOmwGTb0PKR8XNwAXF7PPLB1Fy
        Vc2WXU+6PQjmCQtJE4dp64UHDH2VSAxuAfGb7nR4U/SbQ7xzANrAEQKjGOS8zP2E
        kBaPp/GTS5fqTSB2CQTtfdroHzmpF1TdDPdUy9NbIfVJtksMoWfmBsbyIh5g8pDQ
        ==
X-ME-Sender: <xms:97GbYOzbIp5xadCEpHYuPDSPhDuQAOmnp_pclHGDnc3HwuiBmDjpkw>
    <xme:97GbYKTH81NOrkVAMidX2soOEIV2QEMSTURQKjNarqhp9vR37E5f2C1-so3k1z-ju
    C7LYA16BFMBew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:97GbYAWxuf6ugEkSSXEvnHykHglQ2ZBTdItVnylLL9w2Ye0cb1aLgA>
    <xmx:97GbYEhJmhWNPE_rEoD5xOjI2uWE99uxYqNX9Icoapxm2Ohk_0iRBA>
    <xmx:97GbYACoKwvRc_dtn9HLR16bZnKBXtAmd7g_WqRvBQEyMHdFW5s2Dg>
    <xmx:97GbYLoJ6APN3Hymr7AY5elko0PlmMsjEQOAYgPIsXXH_LORVEK1DOD9c14>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Truncate base/index GPR value on address calc in" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:01 +0200
Message-ID: <1620816361254155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 82277eeed65eed6c6ee5b8f97bd978763eab148f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:25 -0700
Subject: [PATCH] KVM: nVMX: Truncate base/index GPR value on address calc in
 !64-bit

Drop bits 63:32 of the base and/or index GPRs when calculating the
effective address of a VMX instruction memory operand.  Outside of 64-bit
mode, memory encodings are strictly limited to E*X and below.

Fixes: 064aea774768 ("KVM: nVMX: Decoding memory operands of VMX instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f93ff2302b4c..ac838fb2aa4e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4619,9 +4619,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	else if (addr_size == 0)
 		off = (gva_t)sign_extend64(off, 15);
 	if (base_is_valid)
-		off += kvm_register_read(vcpu, base_reg);
+		off += kvm_register_readl(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_read(vcpu, index_reg) << scaling;
+		off += kvm_register_readl(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*

