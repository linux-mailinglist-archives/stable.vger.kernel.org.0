Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD54A37BAF3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhELKll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:41 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56001 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELKli (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7724712E3;
        Wed, 12 May 2021 06:40:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:40:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nw/eUu
        YOUh/lnwLUDuulvN+iQDzTWr0nTGkgQGsBgAw=; b=Ggcwyo6JK0IqjPX4CJVMGv
        TzIS9e2/mKkGXrP9JApsMvYDTlLLEgJZw0iJ0EZHI0XLS75O8BUiGQ39xt5Z29+u
        /QwVlCPXls5ezBvecvoJF2V52H1neu43peDtkwKKHSs6UzDhd7MvVugpaerqOqve
        ZtPSnDlF2ixDDZSjv6GM0m0gPiCp2Lf8Zyzlke3z9I55TErw29/o6beU+q4HR75h
        b+E1e7dswxf6uGfU40YNBZQ8StLVfPQFXWVBZx4KdoWYNTZh3/dfacn1IcuTjaPu
        7WRKMWPxYGnoofVtmzsdObWZlSNsjeGXpujnRKAgvGFH3AGYvEWU+u/aJLs4Qp6A
        ==
X-ME-Sender: <xms:nbCbYCn1HGE7IgGDv87JuFcCNK9VRFQR7Cj-_SIQA8D0ZiFe7JXshA>
    <xme:nbCbYJ1UWTWY-3HXF9VhGM1VyISIDu7YZzHuGr867diBzMmTOF9L4RSr47244-cpv
    0EzqNI-xocV6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:nbCbYAptKhfNRTW0Zq4JOc2wkOTUok_gmEKjqL0EQ2ChmqLfX120NA>
    <xmx:nbCbYGnVInHuUrfBc7iYH61tH-1MLxERfQ53YzNdF1ADdVOaDFP66Q>
    <xmx:nbCbYA34oH6RzYczKM8itG7SipZxI-c16L6u8uZILGOyNNccZRj0Ng>
    <xmx:nbCbYF9h8HboPvt8LR3_mHI5q2UXq7L2Z5ZlecTM2o1ANJX40CkOcfT_Xbw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 5.4-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:17 +0200
Message-ID: <1620816017250207@kroah.com>
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
 

