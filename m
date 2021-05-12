Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5164737BAF2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhELKlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:35 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:45209 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELKlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:35 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id F0ECB12EC;
        Wed, 12 May 2021 06:40:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hdN8RX
        07savE4ZoxiU9ibjOFcrMy3vM+yckn4hU5ymY=; b=QA9XGq93BnYdCTVN0G95f/
        DF9fkxDMvrgHujmYsYCo5ZeYDLasTCRCxX6ctIkRWVB4OEM4qomX9cerEfBwvR6M
        0Z5+kXTWf5cv0wZbG7+CRQzYsgJSMwrbWAl4HGaafCgMVZeWtrT5qAs/lszCpLwy
        4VfJkIPr5Be0HcPMADZ3I4aBNJE3lOtx8QQnssXgjiV7QaKqgWixgJnAj8F3Gkvw
        YPpFwtDBgMmuuK6VGZ2Ma0ZU5B1CQsPUpEAGHupRyHYGj0QH6nEYOJeD9ku7nMMZ
        ztLIWYZAtExNuRyykFAhnd9qqJ9L8MfJ5gQdQH4pz+ctQtIqjsK75+zgREbq0TxQ
        ==
X-ME-Sender: <xms:mrCbYAn9_6wFYwx75fUFIb0Kc3bz1HtwbKxMwcYPhyG4CRwLGSbakw>
    <xme:mrCbYP3ulgBlKEDUaWPtm4_AKf76JQcBy07qi4l--cIrADJCaxMCOfQbYt51NN0kj
    jNF0Q9nrZ0Msw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:mrCbYOpnl4msp5HnsM0qFDhTaObYLbo37vk5zCFDp8HhglArlr9FfA>
    <xmx:mrCbYMnmbpmyTK2TGpU9mmyF2lCh2KT_sMA3Iq5YttY9uIZMcy805A>
    <xmx:mrCbYO2dIEM-3K-44IyddNa6NK4Pb5bZK_G8NvcHFk2xU-gT0ihD1Q>
    <xmx:mrCbYD_YLUmXSuZshhCD2xM1EJUOTcfkGw6WSs_f-m3NstKAtlQon7OMfJU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 5.11-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:16 +0200
Message-ID: <162081601615561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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
 

