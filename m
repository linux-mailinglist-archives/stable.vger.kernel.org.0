Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB337BAF8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhELKlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:50 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48247 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 8EE6B12D1;
        Wed, 12 May 2021 06:40:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aoUGUn
        3TbVn95R+asp7M10QKUx8J+Kvaw70JcN8YbPE=; b=qjew6n1lL9uR8sQY/1ikXV
        ssk5hHAF6TSpYOKJxjYEaMGzaWz8hPNI2zizpUI/jf54qmjkdEXp3hqG7X0lkSdp
        Hg3nnMfpbPtlJ5GeuOil1Eu2kgVAyh05OAl9pX1EdjYmRsF7s7tqjnvMKOqDzaJ2
        bGwK5GVCqMst10uo2Lb1I+ujlWqFnJ18eOE0VSVjxpw82JrM8tQDpQq4rI8Om/s8
        drCV38/BOAwxJnMiYnh8IVSqm3O1rQpDtcC2w/qoxlgtrKVVJunKWJCU/Af81OBe
        n+OETRSP8scTKBsjnZBIUYHztn3z+Mw+iyRvFW4jueTioKciZzwou0o3FN/gXyXQ
        ==
X-ME-Sender: <xms:qbCbYJJpUP2FJjt6mG48dP2fG7qCz9Sa4T_rjXSBoTIUgJ_Y5iwYWQ>
    <xme:qbCbYFI7pFCcANMmTaUaBCnfD5pl_zifrEKm5zbkNIL75geEoYjGgxO6T12TtktEN
    yLZXrgwVSmvxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:qbCbYBtGMaYx0WSWfVu3r6IZvnmAvgzA0hZcmE8AddEXUNETOnfdhw>
    <xmx:qbCbYKaHvld4OdCeHZqf5frtD77JBMLnJVXgYG6tTo2LDXSz58meXQ>
    <xmx:qbCbYAaqSsf50rYfUXDU_brkSKCZIy8Yn4wx_210-Cy-d7svi-n8sQ>
    <xmx:qbCbYJDrGBbsYRDouhfx7ani3PBZyT1NG153xZLYwJfKKWqRa9Vgjla9I-8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 4.14-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:18 +0200
Message-ID: <16208160188360@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

