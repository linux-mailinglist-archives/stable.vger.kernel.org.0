Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5F037BAF5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhELKlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:45811 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4F94BC14;
        Wed, 12 May 2021 06:40:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Cx2jDh
        Se8xVkv7fgFAF8wi3PY9s0WbGict0Kk1q7uQM=; b=Pg1pqxcMaBDIWl8vbxERBW
        YaQ7aROfTvktQ8M4SVxJs8+57seF+7erM5qTJ/0NKFF5+S8me8HpmKd6XPGZy9Iu
        4zjNKXESp03vGZOC2g8WUFPUUoS99pSDkLSLxiVRDg7hfiDMk3RYWMn0n0o+VsG+
        hIngH9Y/LeyKqg0DQwjESC4JUnA9NIFt7S4dOwEQ58ouWxiF0ZXyekLzMxRgf62L
        LKzsY5zbXlK9jJLGjZesFOoQhfxayAIzQgW3aazpKQnGwCWln8ucfzxWOlb3fqBV
        Z0jgE0V0+aFERYXIjBdmpEDYw77TMJVtNZEXS2bDtgPImn/QdKC4uXNCyanYf0Ng
        ==
X-ME-Sender: <xms:obCbYLWqG3vRYUVvgV8P9LewktMg-1JQRX_R6iuCUXdgipa-XPg7oQ>
    <xme:obCbYDlp-OLm4t7w5S4X9Vg5N829BL8O91hxKDfWErjWahGaIVAJ0lwwxK2Nf1S5d
    v9JnpQm42q22A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:obCbYHZbOjheX6tk9D92IoNgYNJY3A3pFlD-f83VgDTk_ArI0wSK9g>
    <xmx:obCbYGVhsEiWf9fBRabrA9K_rDO1BU_nB5DKtk7NySYwnB8FZlfLBQ>
    <xmx:obCbYFn6-QX9JshFvyIArKRnJ88Inh-tJYFal9Ubjl74WIEbp2-WHA>
    <xmx:obCbYEsxryjI2EwSD4cxkK7k04flxVwX6wsDf7iRzXwhv6Hnq5xT-ehli30>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 5.10-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:17 +0200
Message-ID: <1620816017205251@kroah.com>
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
 

