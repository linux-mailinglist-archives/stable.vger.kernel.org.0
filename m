Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B839337BB2F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhELKrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:47:22 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:33823 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhELKrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:47:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 713FEC14;
        Wed, 12 May 2021 06:46:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iRbIJ6
        iHwwvZ9g4Ob2BfOZbgbKwCCFNsISBnqvioEwQ=; b=kT0osbzNTQN94UjKTYbmKs
        3V0QbWiRNol4ejaxhGOJdld4GCi+vqrujiOD44WPnjZxcrzw4bOHBU2CGZimACru
        yw4jhOMOz6k9jv/9B08Feytbpdo3WGWJiUrrTzxfr7oUIcZSvZ0tF934wvyKRE32
        nHUCfQQU5OnwpAmNEO3pgoKID7KgHiq+icknX2wEDd+9hInx6FgpEDRGhwIZ5JZZ
        JJOZqXheqw1jWRzOSNJTBwIginfPKP+S7XK5gT1JBrvFNF1BzYkddoGCiRup7Fup
        UPJyuTqGxlU1VKrmf2a1a6rkrh9LAAMwUsB2+WQBKiIkAVaFKEfCkKeq+n/SQAng
        ==
X-ME-Sender: <xms:9LGbYEjA6hGtXYESagZILGF52ywNJDlOOQu-2YHwjf_M7vioqqKSrA>
    <xme:9LGbYNCqCoTS45wcMNXSRsnbreVmRE-Gpe3NGsrI4AwLBAnkoalI89_pOfRRqPNSX
    NS6-i0l-ZQfAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9LGbYMHyIZ24ALCPAKb1qOufthfyYESJxWGYZUN6LTKehsElepw76w>
    <xmx:9LGbYFQuXdRWJ5LBAefCIk3_rYu1EXrAPdlX7VfzB3ZWum8vnj0jDg>
    <xmx:9LGbYBz2_-xFKspTQlGbNL83cUGLGhOC23MVTSQiW0hIxzoysdPX4w>
    <xmx:9bGbYPZGWHTc-nHtxkHdlGxPBB5lzzv1WRfYx_k19MjOF9zBaOyPXKnDgpY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Truncate base/index GPR value on address calc in" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:01 +0200
Message-ID: <162081636135173@kroah.com>
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

