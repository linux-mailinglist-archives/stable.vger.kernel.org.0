Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865AA36349F
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDRKfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:35:16 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:60147 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhDRKfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:35:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C5DE919401B0;
        Sun, 18 Apr 2021 06:34:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SUoAGX
        rlidAyG8TWlRw5WhwWAuakSN020RzqNZQTX2Q=; b=Z+zc3mPTbMr6tvxRfxE19r
        6Xqz4vXWDbo4uqpcMyRqSys/GgFYTROlqZ17VEWvEiypjKXeousrx2sKKPXk2hw/
        muAEoBvY1ACPpCFcaVRYcTISApa37FmP+ws4ZVbY5/tHeZOVX91lZujo1fpkPfrq
        5CbNtnrXuxM2Nen1+mO+I+gESNlYuef75biUl4qAQ0pFsQvYRAtMwIUU3rkguN1y
        r6U0Doeap5DjrmaKHwT9uxoMD8H3tH7Jxb+5j+F3p5IWVNNo58l+Ox/AtxsYmrt0
        6ytUEJ2c1cqAR3VyxzueTIse9dNNj8CkPZ2Qdb8FkVmHphsruCY3cKHvmR+8CyEQ
        ==
X-ME-Sender: <xms:Pwt8YFp8-qnDLMdCPXvpbleCueatSZ3BCu7VzIBC6MCKU03hcSi4pg>
    <xme:Pwt8YHrqTWKRuywmY-UUOPGMl_VvmQTVLA4eli0oXbNPzgh6coeBOZ-lj0Fg8lMV0
    _pHCsfxeJkelA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Pwt8YCPKrscnZSsHURdrH6YDbgnTHqW7ZDo8i7i_7T1IhaWLitqMSg>
    <xmx:Pwt8YA7vLgaBr9-yMCJZ0nZ8oiLN9wXhjdD6P7d2No7SaewFIgDKlg>
    <xmx:Pwt8YE4h7o2Mn6BCn42jp6EiU0g8BWpP4TueG_-hmPQnd5QFcjuO0w>
    <xmx:Pwt8YCSO40wEsvHXGwmJPvMi8IBSW7ZGi0HPF_nmp-aHhiYAlz7wNw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3023A1080063;
        Sun, 18 Apr 2021 06:34:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array" failed to apply to 5.11-stable tree
To:     reijiw@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:34:36 +0200
Message-ID: <1618742076194222@kroah.com>
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

From 04c4f2ee3f68c9a4bf1653d15f1a9a435ae33f7a Mon Sep 17 00:00:00 2001
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 13 Apr 2021 15:47:40 +0000
Subject: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array
 index

__vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
an array access.  Since vcpu->run is (can be) mapped to a user address
space with a writer permission, the 'ndata' could be updated by the
user process at anytime (the user process can set it to outside the
bounds of the array).
So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.

Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20210413154739.490299-1-reijiw@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf8287d4a7..29b40e092d13 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6027,19 +6027,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	     exit_reason.basic != EXIT_REASON_PML_FULL &&
 	     exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
 	     exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
+		int ndata = 3;
+
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-		vcpu->run->internal.ndata = 3;
 		vcpu->run->internal.data[0] = vectoring_info;
 		vcpu->run->internal.data[1] = exit_reason.full;
 		vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
 		if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
-			vcpu->run->internal.ndata++;
-			vcpu->run->internal.data[3] =
+			vcpu->run->internal.data[ndata++] =
 				vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 		}
-		vcpu->run->internal.data[vcpu->run->internal.ndata++] =
-			vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
+		vcpu->run->internal.ndata = ndata;
 		return 0;
 	}
 

