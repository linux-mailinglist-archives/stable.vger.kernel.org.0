Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2EC1F99CA
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgFOOOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:14:33 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36753 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730147AbgFOOOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:14:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 84C756D2;
        Mon, 15 Jun 2020 10:14:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 10:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lcyDln
        bTJk/rSM5CINI9DKAW3u61ay5rJ2tHwQVAhTE=; b=DDfR79o3fAM9kHNRE2MOta
        3z9qHWPtPVprBm5HGbV7gYplRWFxDEfegYoAZEv97oQFW9DAPLz/fh3LMX7WRO89
        +A8i2r2akfJuwg4+ImGK4RyrN8sFW2WRxSkTD0+tiLqb+I8Nm5m1n/1vRY2V6Ihu
        EP6ngw5f9dCFFXX7y+2jxtu1Jqd2T8srFxd59Z8P3iJ20V9bEWI5m9gvmQgdYIxB
        J2onLa13RoHuX594k9pySSIn8x6eGfjYOGgA3CRUOTxryXW4spxtY7F8hmfhoL43
        E4n7X8XpSRKtJhswCeXzWThls9NjVVdOFv0vMb9nAINS80f/I8jVLe1Vb4YtniMA
        ==
X-ME-Sender: <xms:L4LnXlLjDZwyygwDuycNbxmYhl2KCns-1Q2GAuUcBAojTJM0kcz5pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:L4LnXhKSs99lzuH9ZxQdjWcWH-HyjhsSKuvn8-B8ZuyH_lFmu-atQA>
    <xmx:L4LnXtu1qdC0MaagZ4phTCBPzH5r0r5lrZXkghhCw57kkFOVECPV4A>
    <xmx:L4LnXmacbCZBw8Y7a4R0fgaYOc2QF0fhi5MsjutEVtEupSxrHRwLwA>
    <xmx:MILnXlCTx8PIaCD_zRXSS0XcMAOlxDNmqYRCGUqSarnDVFNmKtDJbONhKE0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 899843280063;
        Mon, 15 Jun 2020 10:14:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL" failed to apply to 5.4-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 16:13:56 +0200
Message-ID: <159223043624895@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Sat, 23 May 2020 19:14:55 +0300
Subject: [PATCH] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally

This msr is only available when the host supports WAITPKG feature.

This breaks a nested guest, if the L1 hypervisor is set to ignore
unknown msrs, because the only other safety check that the
kernel does is that it attempts to read the msr and
rejects it if it gets an exception.

Cc: stable@vger.kernel.org
Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..e0083a08da9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5242,6 +5242,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 				continue;
 			break;
+		case MSR_IA32_UMWAIT_CONTROL:
+			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))

