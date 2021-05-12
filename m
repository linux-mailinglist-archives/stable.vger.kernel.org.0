Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81937BB2D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELKrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:47:11 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40879 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhELKrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:47:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8674912A4;
        Wed, 12 May 2021 06:46:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:46:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=twvc6c
        HFbyAcKI5UqSG2UJrWDZDF+09Bjz+joWSHx7E=; b=Co6rFTjcRxEO5UrFwSKtzG
        s2bq01v8rrud4A+T0jbGNzB/Ggv7s6bqRVn8dvZF+BopAL24Vjz6aIzoVmWM2c/O
        18C8MJWwTi8zy7aG5SZecK5JWFSedtl3cYDAoLlOfTmvCZqki+vK66UQrlylIjqY
        4H40M39J27zbtdMwiH+XAGiz+ZQHcLScgs8WAvaZXU7dRRetJH4FNclrhEjAyPRX
        WXzGea9fkb8EOK2zayB53fupD86t8KzqxiHOAKAzZwgQyIzvR1gM2TsUk3sCbSTq
        pozi9YCQIoJ7jN92P7jO/G/hTryfBS7FamoywSwzx8ls1SHgD85SYqjUq/kc6cqA
        ==
X-ME-Sender: <xms:6bGbYBT7flIH3iA6sfH9NwHMSYYEGAv24JD7fImEzZWSUNenPQet6w>
    <xme:6bGbYKz7CkzDk2ThDnCqehLBEhr7R2fJo4ChdmlZA2TLZYA4U5GpJ6NSe1MBmlII3
    B7fAeJPefTkVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:6bGbYG0IumAyzW9d5l5mmNibnEEjplIC50XuC9fFF8QK7g5Al5aXGg>
    <xmx:6bGbYJDwJuIA9SnMew4LrJ33v7kPj0tKMaSLotUr-f4SiQt45XF1qg>
    <xmx:6bGbYKiRuSetEpmT-2r5il94Si7g4moG83YYQROGDSmO1Zkltr-9Ag>
    <xmx:6rGbYCLmRBb63N8bbg3yNjuCw19nVh5LJ_ZAcMVJpm-MCyik4rZwFhkheZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:46:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Truncate base/index GPR value on address calc in" failed to apply to 4.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:46:00 +0200
Message-ID: <162081636014740@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

