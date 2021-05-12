Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6737BAFC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELKmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:42:32 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37283 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhELKmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:42:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 443AD1940425;
        Wed, 12 May 2021 06:41:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:41:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KqBHa7
        b5Le8urCANH0lhCJjIAzaV9YQX+jIfhMxQEDc=; b=AaSmFHZVHxrVzHaE8a31D8
        ZTpXANqKfYWC3RXDskFEKiqYbmATWZ39hMy3j+7uSaKY45jh580X6MC7u+qRkFyK
        aof/l/1UYpwjnJR4Bt8VhKDWmCDsSCn6i719qlpOSlrVtpTW3pIx5hwC4ppv6x8i
        Av7hYdEYcJFXNwnaijSRlao83OsVIw4LRXZf+dl3FiQx3E3SQXM/VPfGaX1KQF4A
        H+uq2fBm8vbPh4i1P5MLrvhUB4yJ0EmeT/gq2RHEAFEWLYKSNSFBq5XBRn4LfPga
        76VoTuY+cEdCnaIxN2Kl11w1fT3mwOrlvfZXcxyD00OaRAPhJd0EtVB43oD2xQyA
        ==
X-ME-Sender: <xms:07CbYLjQORstjj6nrKJbRrqv5AormcjLOUnnkRAaN3Dtwb-t2GtX4g>
    <xme:07CbYIBKucqDbFvBzhr3ocI2jw3s4rEHfiXT1WlaSRPezSmDRYiOtdm4dz-VsIwdK
    fxxuCZPqluJag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:07CbYLEQNG_BVyHCDeS9F7mWIOU36q0ey2SgXfCAGgaV1xCQiEdvtA>
    <xmx:07CbYISNOUZugWcKe-Vj5ypCE2HkfMTwHQ77qPwiTo3DQsG4wy_Ocg>
    <xmx:07CbYIydmcXFa7k7_I_w0zpX9wvQDOMWZy3LgWN5531XMZuD1_ynTA>
    <xmx:1LCbYD9QrldLc16LlhIaf93Pt_NBBbYuIV4tdvtxcTnWyFxRBeNzpA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:41:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Don't strip the C-bit from CR2 on #PF interception" failed to apply to 5.4-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:41:14 +0200
Message-ID: <162081607410484@kroah.com>
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

From 6d1b867d045699d6ce0dfa0ef35d1b87dd36db56 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:56 -0800
Subject: [PATCH] KVM: SVM: Don't strip the C-bit from CR2 on #PF interception

Don't strip the C-bit from the faulting address on an intercepted #PF,
the address is a virtual address, not a physical address.

Fixes: 0ede79e13224 ("KVM: SVM: Clear C-bit from the page fault address")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-13-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58a45bb139f8..cc45ea16c0d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1898,7 +1898,7 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 
 static int pf_interception(struct vcpu_svm *svm)
 {
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	return kvm_handle_page_fault(&svm->vcpu, error_code, fault_address,

