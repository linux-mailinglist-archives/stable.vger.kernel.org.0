Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53A937BAFB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhELKmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:42:24 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:36565 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230102AbhELKmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:42:24 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1689E1940185;
        Wed, 12 May 2021 06:41:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:41:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=t+gQuK
        GcUDKodL1wx9gNGu/vfz6Hdcpg2rTkbfqKtM8=; b=tcFmk/9/wRue7M9KsUnpJf
        LqpFHFt6tWpgBoc002s+zlci0s9M+ZdEIlalde7QRK9OOd6arFjbmuPu6ZD8ie9i
        X1iRs4s+jK+zPm1nRd6CBz/8awj2otS1TGs2ANxwzoFDhuAv94TDJtzxViNzH9yq
        qFVDL9wZpGsY7HIx+7XAuP3XfNeguRz5WXSUWBPOFPXUqBibi5YdCDCsXKVM8ll/
        eNcANS3IvFvYHsnVdYqa/iCEx2S+IEY6HjiogDOXz0EGCtvAHDtdQmaLt3xiO6VJ
        ljoQ1uqOl22Sy5dXM2rFsZmC1EXcsOh3C0hYH2WTVsoPUBOG4Q7cQN8wKU+AZ39g
        ==
X-ME-Sender: <xms:y7CbYLSprgC0nydxGvMyt0K_YuSMgw8m_LQCWjzWgpChCAaQDb8QFg>
    <xme:y7CbYMwVvAj7KvhUiu-y-byq9krgXKzq9kpW7Bk3kdx3DJmyHuCi-ZvJZoYxfx2iX
    ZFQsKG-ja44CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:y7CbYA3oGqsQxLdakEO8bNFvEOVplFtgpB-Xin3NQ2L1JNqmvAvpTg>
    <xmx:y7CbYLDnz33_hbE_maHeUR_XU1gjD1NZ--qAEOXqpcIGUtzF1K-Tbw>
    <xmx:y7CbYEiKMc4ad-NNN58YHYyrn94GnTMWB3uz3XYr1Eh2LJtvwrY2Og>
    <xmx:zLCbYHuYeMpdfCPxEbS5nd6-YzpWDmO58DB-vrNeRLKlgqsoobcraw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:41:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Don't strip the C-bit from CR2 on #PF interception" failed to apply to 4.19-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:41:13 +0200
Message-ID: <162081607311652@kroah.com>
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

