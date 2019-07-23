Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1B71622
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbfGWKfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:35:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:60043 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfGWKfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:35:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F1FDA58C;
        Tue, 23 Jul 2019 06:35:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QEoCyQ
        cY7jEs5vaXzOrizzx2eXRpJCoQjPqS4JEZI+w=; b=AtIuRN2z7TjC72Pw1uzH1M
        0Etsu0hRJXLsXkH0sl5aVly33VkFucom98t3ZUAI/VEULGlY6HG6XpKZc9d0JTgH
        g42Il+HW7OwZ7ewh5bOwntmIyrvuLukNniEFPtmpEpo/rSf7e2v2VbZHB5JF5M6K
        mlEZkJ1TZxIpSf8QSuO5UwR6fasUTpLoMJLfxso8e5Qbd+rhlVn+lJpJXYSZnH0c
        OJ9eMJQLdW4ZEiXBnFxs9+6jPwHEvJHEykknblGWO9Un6m6YLsN4FaHFLrnRNqcj
        pDQiIViigO3bDfx1sYCYMa+ssDUf08Bm/Bp5VjtkCQV/9xcD47weTiU9YgrMGlzw
        ==
X-ME-Sender: <xms:BuM2XWtaEEeZH29jLmDAK-ipwSa3khB6-T1dEmKOyYAEUpCwe8YXbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:BuM2XS6ZqMnZ-W8JzzGLuNDMXGDeUxYXT4fgz1L-zYcQ5gYVfJIFgA>
    <xmx:BuM2XfKUTqX6QAbG4spo2wemuEO0rXiFoR6Kz514WEgdloocH3V4pA>
    <xmx:BuM2Xa5aKRBL1LcL_Q9z3O_YZ2fwlK7sOMr-FaWNzu3C4F_xIdWu1A>
    <xmx:BuM2XZVS9gFSbPoDlVJ6yy_JODh3kSRI1PlhfSZQojiwdhzWoL-E7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2EDD9380076;
        Tue, 23 Jul 2019 06:35:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, nadav.amit@gmail.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:32:22 +0200
Message-ID: <156387794267213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d28f4290b53a157191ed9991ad05dffe9e8c0c89 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 7 May 2019 09:06:27 -0700
Subject: [PATCH] KVM: VMX: Always signal #GP on WRMSR to MSR_IA32_CR_PAT with
 bad value

The behavior of WRMSR is in no way dependent on whether or not KVM
consumes the value.

Fixes: 4566654bb9be9 ("KVM: vmx: Inject #GP on invalid PAT CR")
Cc: stable@vger.kernel.org
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1a87a91e98dc..091610684d28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1894,9 +1894,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					      MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
+		if (!kvm_pat_valid(data))
+			return 1;
+
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
-			if (!kvm_pat_valid(data))
-				return 1;
 			vmcs_write64(GUEST_IA32_PAT, data);
 			vcpu->arch.pat = data;
 			break;

