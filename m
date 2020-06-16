Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F51FAE55
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgFPKos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:44:48 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36053 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728154AbgFPKor (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:44:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 90F6B1940648;
        Tue, 16 Jun 2020 06:44:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 06:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=D16inG
        QC997R1vxhtuHlNb2VHBLxY5WA6byLP6QuyY8=; b=btzQ8K0a2m9065Sr1PdRMg
        4uanj+/3Z+fNVUVhMYkCFApGbOwjG3LI8KK1t6HwqLPJd1HUsnzWgzJ7bZALR9mW
        mgCAJlhiaf/p/RcvZVqBqhfoBw85tjwKZ8t5jrlUH71jOJsMLes5GvGBbobKHDxJ
        XS12MdbAchxQPADzTub5cK4IEKoLpyL8O+ofoW9VD9aODzqoHmto77XsQ6KGhvl5
        g23DLdLkjj4tcYda9LuJOqew54Ty2j+WEgVbpz5cFTotMacNx53mi4MGCmman7m7
        x0Ixie7e/ZAv2gt6ijY0RPfXGRIzDq/TOyimBQPb3r8nLp8KSIBRDxH7SoajI9jA
        ==
X-ME-Sender: <xms:naLoXnHKieEyWRARqKkiQ5_cmjnjWnm6G7UBdvrhfjqiDJfCziOWTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepudeuhedvvddutdekveffueeiffduvedtudetgfdutd
    ekvefhudekleevfeeghfelnecuffhomhgrihhnpegrphhfrdhhohhsthenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:naLoXkXUrrk5gbqBE4MENEhUXlZr0Jc_-JzC3zytWOOJ5h49X7OJwA>
    <xmx:naLoXpK3Ip9r3yCHbyiIJn49B2uoLkFnnYtd6TjTXheoua_15DGYYA>
    <xmx:naLoXlHBMA53fXbB_WcUS1tDkoIfkToosHmjws8tsEtD4EJ7lGecMg>
    <xmx:naLoXsBqHX69pyx8D15x2R4tAaXs0aD9fX7gb8aJCOruWiKUn5jLDw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2EB1530618BF;
        Tue, 16 Jun 2020 06:44:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nSVM: fix condition for filtering async PF" failed to apply to 4.9-stable tree
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 12:44:32 +0200
Message-ID: <15923042722746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a3535be731c2a343912578465021f50937f7b099 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 16 May 2020 09:19:06 -0400
Subject: [PATCH] KVM: nSVM: fix condition for filtering async PF

Async page faults have to be trapped in the host (L1 in this case),
since the APF reason was passed from L0 to L1 and stored in the L1 APF
data page.  This was completely reversed: the page faults were passed
to the guest, a L2 hypervisor.

Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index a89a166d1cb8..f4cd2d0cc360 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -880,8 +880,8 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 			return NESTED_EXIT_HOST;
 		break;
 	case SVM_EXIT_EXCP_BASE + PF_VECTOR:
-		/* When we're shadowing, trap PFs, but not async PF */
-		if (!npt_enabled && svm->vcpu.arch.apf.host_apf_reason == 0)
+		/* Trap async PF even if not shadowing */
+		if (!npt_enabled || svm->vcpu.arch.apf.host_apf_reason)
 			return NESTED_EXIT_HOST;
 		break;
 	default:

