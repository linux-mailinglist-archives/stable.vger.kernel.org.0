Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C5E37BAEF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhELKl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:27 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:47165 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELKl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C1F331264;
        Wed, 12 May 2021 06:40:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HvgWRW
        2NzQSu75fruLAXgNBIRjz6Ruk5a7vCeYx9CPk=; b=KooVpvZtySpAHk6kBnTZjA
        yPKp8XX8olZZ7o9+K99YIUtUeYD/DMRkfrVfqTD8Ju+Hpq/3uPITXkImmPb/osEb
        4R4vKZhcx6pgB4Jk3/xn7HRsOf88uOryus/w+/CH/OjsJNaiDzOoU2zkteRTtFiL
        NJA1hQGO1DKokiatvAh91thJf+mrLzyaFilkEy8k05P7qrtXMKlM/xWsyLy+gZte
        1ekxcmNtAsP0xQMKv5E2rrGH4XvqSRVRAHfaGYrVlX63QjxTx1wrGzjPtLYVFGTW
        WBAzTxd/QoRQl7jipJLwDyxSyS06rTL7mIyYYSQxTaJAcr8HMDQYkqiQRZs6XceA
        ==
X-ME-Sender: <xms:kbCbYCHr3dfmIRbZYnUlT2ngG0otz4EI2ejtBMjSkG27Prm5ZC3E1w>
    <xme:kbCbYDXfHvPWcTsIZIZpFxqT9eLAip0IBBfn2Ffs1cbIRViGkL58IcehWNF66pzie
    MF9krMkSt3KCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kbCbYML_6vLjJPOeqrm8VG_CscS5lSOa4zLg4L3LA7UaHIBfy8cyQg>
    <xmx:kbCbYMGdktdGFZEnyeWFMozbIFVuXWijRVV7z8eDuyICHeVtJK1wLQ>
    <xmx:kbCbYIVVWIs_BY1AJHDK85Ca2WW48xbwJr-TKgWgZaAZBPBiBPEW3A>
    <xmx:krCbYBeTe-LW_cg1ixa5Pu_-rgKMb-UMZIJ7xWmULOgk1ahaqS-rNox2a0Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:40:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Do not yield to self" failed to apply to 5.12-stable tree
To:     wanpengli@tencent.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:40:16 +0200
Message-ID: <162081601617848@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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
 

