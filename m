Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DD917077A
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgBZSSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 13:18:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39027 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726956AbgBZSSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 13:18:01 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C659220BD;
        Wed, 26 Feb 2020 13:18:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 13:18:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=W/7azV
        ayQ1f5A8h/LsRXzan1Y46FY9T4M5Nm7JiantM=; b=J/55S1gAzxuTy4aH6ecWuA
        1N9/u/GPssnRYqK3Gi70A1flD/RBH+3kl8EKzET67WjrJDXtMxdOuZ/wJ02Ox2Vu
        Xu4Nvt1E1+mdk3vRMw9QVN12F/501o05gUOqIOhCFZffdLpvVsw7CZZgKFu/TlDB
        dhtkS/6coHa0xAJj/jXesrby0blW8/G3fq9QnjIsEM2zhVdXmuEbACabXByf6GBr
        NK/Rf/3mizbwu3cgHXVa1WtzsYzSGA/pECGeIEc2wsJfvRmqcfrdrOxFYqi8uTeG
        YJdZN5Kv+X9Gt6VCo1O4seI/E2km1rfs4CNsjbo6+m0FDlWCuS+h7q23AvIeVs5w
        ==
X-ME-Sender: <xms:WLZWXsnWDkMCcUO3Wh-gfRhUgjd5FBxC1_XEWDVnoEiO-vAngxiI8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WLZWXgH_utL85cGncQdo1pFMlClVhCahZfsBaC_2isMq-IgtEp7Wjw>
    <xmx:WLZWXlpmUG9xcmZsdLzNH3qNaflGkdUeLWwSkotAkan0R22JBIbLUg>
    <xmx:WLZWXs55JxfytaO8ojdUktqsKROYJZYXJ6-nkKnrG6UvkBd4Ox58aA>
    <xmx:WLZWXs6-BUIbI6UdHunxstarPzucJnxQI60cKPaoA76VHFbVVlpisQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21C23328005E;
        Wed, 26 Feb 2020 13:18:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Don't emulate instructions in guest mode" failed to apply to 4.9-stable tree
To:     pbonzini@redhat.com, oupton@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 19:17:49 +0100
Message-ID: <158274106914255@kroah.com>
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

From 07721feee46b4b248402133228235318199b05ec Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 4 Feb 2020 15:26:29 -0800
Subject: [PATCH] KVM: nVMX: Don't emulate instructions in guest mode

vmx_check_intercept is not yet fully implemented. To avoid emulating
instructions disallowed by the L1 hypervisor, refuse to emulate
instructions by default.

Cc: stable@vger.kernel.org
[Made commit, added commit msg - Oliver]
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcca514ffd42..5801a86f9c24 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7164,7 +7164,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	}
 
 	/* TODO: check more intercepts... */
-	return X86EMUL_CONTINUE;
+	return X86EMUL_UNHANDLEABLE;
 }
 
 #ifdef CONFIG_X86_64

