Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDC5324C14
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhBYIcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:32:12 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:48249 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235442AbhBYIcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 03:32:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id CCA547C7;
        Thu, 25 Feb 2021 03:31:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 25 Feb 2021 03:31:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LGj6W1
        qtCmddct7mtRwp+p3ycwmNO0uMCBgeko3vths=; b=Z+sUM3wKBT2Rlx2ePRSa/M
        ppFtaXPmt+hiAJo3Vv3Tj8qpxsulJxFIGrt14y4lcGOYSgcjNgMm0Pr/kE087HLE
        +cF5jDCZXCTW9G2jgv8779TVVANpCL15UU4TMP5dWctkZyF7l7PlPhYgcmd8G4Yk
        /N+jjnekuUdBc/aK+e/w2ukMCF5AA4n53JfkFr10eCF5a9E47EJJ2VOHqfnN8wzg
        lK0m5PZljYxu5P/jpMjfLp3NKxRXRZyr9KBl7N0/ca8YB1a46cHVcufQde1c5WvF
        +j0lCvu9YNs8uhTlwqJsuDM0D1eSw7K5AnrTEvtpYXOYpoC/QPS0vWTo1k8NeFjw
        ==
X-ME-Sender: <xms:XGA3YDfQbCRznwE2xpGri2ks5bPyXmC63b2xIVjT8IxbMfKuu0R7zQ>
    <xme:XGA3YLN8PGZ1DeFGPGqimapaBlLMXTX32htpdFJT2g51Prugkvwy878Ug8LjNIIM1
    mnNjogck0Ejlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XGA3YF5rQ3f8Kf9uKkj1WIyH5svH3GA8ZCABqBF_VKH__nodPlauTA>
    <xmx:XGA3YHIg-HnM4PKPobJ5yZIQ4ewmUV3Fb8WsCymuBvTc0qnFhC1Nug>
    <xmx:XGA3YHcpj2Kx7XHZlZo-BdLlxVRRIjzmvvenMq27fWQSI2AeZwlU3w>
    <xmx:XWA3YPFWmweDyVBzKTpG-kD8A2nq3cflWSrVwZiTeqezfxiMpvcSQ8rQLzw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8913C240057;
        Thu, 25 Feb 2021 03:31:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Set so called 'reserved CR3 bits in LM mask' at" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Feb 2021 09:31:22 +0100
Message-ID: <1614241882191171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f156abec725f945f9884bc6a5bd0dccb5aac16a8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 3 Feb 2021 16:01:06 -0800
Subject: [PATCH] KVM: x86: Set so called 'reserved CR3 bits in LM mask' at
 vCPU reset

Set cr3_lm_rsvd_bits, which is effectively an invalid GPA mask, at vCPU
reset.  The reserved bits check needs to be done even if userspace never
configures the guest's CPUID model.

Cc: stable@vger.kernel.org
Fixes: 0107973a80ad ("KVM: x86: Introduce cr3_lm_rsvd_bits in kvm_vcpu_arch")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210204000117.3303214-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 838ce5e9814b..10414a78b951 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10080,6 +10080,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.cr3_lm_rsvd_bits = rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 

