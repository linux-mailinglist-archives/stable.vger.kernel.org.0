Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2737BAF7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhELKlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:47 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48513 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:47 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 3779512D5;
        Wed, 12 May 2021 06:40:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wfTDJr
        DTZVdzQrGv9s7WVeX7H2bohcFb195SdP8EqoY=; b=P+RB6ijw7SaEy0kyHs8loB
        b+j783cXb7ZUz+XjDjzxH2KxEZugbvGV9EBpQ+96mo6SlSz5JBtdRe11eRFzKk/E
        +iCpB6IVSK7eVFO67Oa83OpqzOCPaoHuIUNGCLJJEmB2qFONcTmxL7k0yCTFj/24
        3IZBXnc5OxQl+svVqJTP7eleA78oM988i9Qf7Zk0sUKZ86ZjCQzbwAdXSoz26Mbn
        kNxZHcNP/B3dyk1GEYgoF5UmWjP9REMcGLRNk0y2RomjYVaR5TN/gJjmfN9S+AJX
        QI0IgBO1FyanQEmAcMW8f8g5vkdSmXhdaywV8iJsYvXvJ/VH6MCcgyIWYKGCEVpg
        ==
X-ME-Sender: <xms:prCbYBnlkmPJvZslegZ9nu419P0EgbQlMfu1gxqP9jSFlL4ZQgLA_w>
    <xme:prCbYM0dYohSRAW5dYD-ZtWPT8CjbWI3CN_OhPXAsU5RNQ1YFPKG7w5nu98e1OhUK
    lu6SiNwczJ_Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:prCbYHo26W76kyJQ_ScG09jdRfn9UBzZNuca2Xbxn_Gev0RHV99tCA>
    <xmx:prCbYBk6mQmP72Ur6BWHxpR2BGhLCRKXJOyP6gSKv0oQ45-kQG8LAw>
    <xmx:prCbYP32vzkaDqZHnMUslOl4eZ5hFfAHrfaG6FQviJpaHMkmaj5bqQ>
    <xmx:prCbYM_o1PIg-m56THpfy8jXVXfqI5T4inhYFqguE7JPMCmAgySPjfJ6qio>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 4.4-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:18 +0200
Message-ID: <1620816018108101@kroah.com>
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

From a1fa4cbd53d9bc7bb0eaa7bcf7c8a5904372a4ec Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Fri, 9 Apr 2021 12:18:31 +0800
Subject: [PATCH] KVM: X86: Do not yield to self

If the target is self we do not need to yield, we can avoid malicious
guest to play this.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1617941911-5338-3-git-send-email-wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05a4bce181d7..66d2ab074a5f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8228,6 +8228,10 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (!target || !READ_ONCE(target->ready))
 		goto no_yield;
 
+	/* Ignore requests to yield to self */
+	if (vcpu == target)
+		goto no_yield;
+
 	if (kvm_vcpu_yield_to(target) <= 0)
 		goto no_yield;
 

