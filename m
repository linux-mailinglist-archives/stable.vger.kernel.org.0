Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E946037BAF6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhELKlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:46 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:55417 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id AD7EE11ED;
        Wed, 12 May 2021 06:40:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AEXu74
        Xuk80xp4lRvxfnSvqUxBQGknLUc8xc9JLxARg=; b=mX8BcvhyGQpHXcdQzKqv6x
        f7NvYJaMB7+2jinIWYoOWf5vh4yM+OrLOTnYCd8qwmvrLFMiqTzZEo54BsB963qC
        blF9+ICjxvaKwmHbIk8YA2XgaZCKD4RbMYwtdYL1XhkFFt5OEvswre1/BuXYVQ8f
        JgcHZobVIc51RGr3V3YKbWX5W214ing3TfNDIMSsP240CB1zvF2FLRVGONPBTduk
        NCfKckAATRJnDSExug2DbHXVj5TQDKSq08o8vUwvvJlVCTB9dDbTvLP0UJVyc6DP
        8QdUart4MDyZyeh6OKywmJ9sot4zYWJmV7O0DWarJVvymIqJ0XSCsu/Hi6Y8xO8A
        ==
X-ME-Sender: <xms:pLCbYI2FliTiR1fnaZr3B-1d0FPdxwvyIe2udI0cICsOV9mkmOm_vQ>
    <xme:pLCbYDGnBXwLWYfcc1FNfNinrUrJINkHQODXQEkOU5Sggwnt0ysQOsK2cJw5vZBbY
    c_93DmsfmHgEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:pLCbYA6OKnmg5sCorJrEW8453uM1_sJwWMPaVQ09DNQtjkVMLPoFXg>
    <xmx:pLCbYB18ijDUBhrgn7CxmbT5hmGbY5sirT64qS_6VBK7dAJsrdMtiw>
    <xmx:pLCbYLGqeOMEwkZnD-tVU8amj5PJOrVzJdKftqWDkq8x-WqMU_Z2yw>
    <xmx:pLCbYOMeCm80jd7EbQYU29sFIEh4Uzaqw4YUprebLe_23IhAHEWEReF93yI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 4.9-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:18 +0200
Message-ID: <1620816018220145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

