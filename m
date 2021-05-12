Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0707037BB28
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhELKqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:34 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39535 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhELKqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id C7C1012FA;
        Wed, 12 May 2021 06:45:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IM3GBy
        mXII/wC8KftFqqTPjZjRdAEaYsZhwuiGy4Lnw=; b=ZpE6NKWspCYp0LpsMKcynV
        e83GvUOQH7c6ycIpCBnIZNtaaDE7qF22Ud9yLN/ycRi0BM3ttFWg404f5HmjIKhK
        qQpMMbf/mcYunqLKQU/LtxgRPzRpuDyEyAQxkMrYzQsC/ff3KCa9EIXowZ0dRTn/
        ZGywI2S8MOwvvWiAExygkRd03ooX1/Z+PMB0/cIzaXuf8NupaaYpchE7bI2BYLaX
        k5LfnbyFDOWeBvkG2we/5tSnKD11TsiroYok89OYLrS1h5vO2GbSyufJ99hi547y
        j1C/B4tXBzPIQMLAtzX/i4X3EnzqZSXKVgYhhC19+8i5xuKoLmbB/YnfbK21zLMA
        ==
X-ME-Sender: <xms:xbGbYA7bGP7ZuGExc1dENV7CcEg6yIW41YEqc0Jl71Vg90DHsBujZg>
    <xme:xbGbYB71QeJIq83arwM0_aBTl8FjfJZdL4_bRgR4UXkEakh9eXopHxh-VuoR0fwMm
    Ze2JpIjr27pMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xbGbYPepVovpZLkrx-41Xw82KqJrMmUqPw7T1D6ke1E2fsMeR189TQ>
    <xmx:xbGbYFK0MVfKp0Ux-MqDyP2mr0Lxg8jNMASbRRK0PnCViu94EuGkYg>
    <xmx:xbGbYEI3B1zKTZjHUh4jXbeRlXnmBWJvsiZ3JgYG73AQ59zws3Tuww>
    <xmx:xbGbYOxuvOsV8gZg1XRT7j1VLmWh9PkrhOgv0LZHr-n8Rr4c81J95-i-T3I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:45:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:45:17 +0200
Message-ID: <1620816317248142@kroah.com>
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

From d8971344f5739a9cc53f91f1f593ddd82265b93b Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:23 -0700
Subject: [PATCH] KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit
 mode

Drop bits 63:32 when storing a DR/CR to a GPR when the vCPU is not in
64-bit mode.  Per the SDM:

  The operand size for these instructions is always 32 bits in non-64-bit
  modes, regardless of the operand-size attribute.

CR8 technically isn't affected as CR8 isn't accessible outside of 64-bit
mode, but fix it up for consistency and to allow for future cleanup.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index edc23c77be32..64354b009fe0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5121,12 +5121,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5199,7 +5199,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));

