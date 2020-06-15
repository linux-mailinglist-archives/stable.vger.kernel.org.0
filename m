Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB261F99BE
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgFOONR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:13:17 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36019 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728773AbgFOONR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:13:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 501CF6CE;
        Mon, 15 Jun 2020 10:13:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 10:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WJWIwG
        MS2ZLJoXNKZTpO2ZwJ+n0eTZLmvTFyV4FZHuE=; b=R94kkkOF/keULR68xn7STy
        AEY8q6xKTyZcLBRvFpAdJh7DcbaXaNAnyoA7Hk39Wl1dTBrwMbTb9aT4KpPDxQby
        IESI7zxYniOQFMeR5gyP382GMMxsHFefJK2Zp+I0ZhuNSfNPXeemNt6oJ8oFOKoR
        Y7ZGaYZ4ASqERwwsjXWcruKin7UEoH/rYGd8DLZyLDZOiMC1/yajqcutHTCjT3ZA
        nAdjs995lmi+ri1cI1oVuFITBO0Z7jijqF8QUvvFUFGP3GGQBGmIkIXTXEqfadBn
        TsPoJZKliyQTLeOfEeI/hyNHzth8A8KLsa37dbBMUOcYtTcKtdvAi/kChKVFWo0A
        ==
X-ME-Sender: <xms:-4HnXu3u_Iu-0KWZT0gukVQBI54CrEEoyPFCebs9w-4Pv2nEQ5LQ1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-4HnXhHFzOkML3f07P49UBh8ulhwXW3Uq8IJQEb39aK7EfcZEwZCyA>
    <xmx:-4HnXm6GSeYyOllvQMOzND4CCEaotsFUAvXv5RfRMvP-O_iB7EzIVg>
    <xmx:-4HnXv18YLJYC-BsqHyGIKRUUmNFbTzVPCOVpqB6rPiYUzS61yRajA>
    <xmx:-4HnXkPDK0KeH5ZqoFaxxSIjVTa3YOHpOgutZN5NB50f3qAOZc8op9bwzx4>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21ACC328005D;
        Mon, 15 Jun 2020 10:13:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL" failed to apply to 5.6-stable tree
To:     mlevitsk@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 16:13:00 +0200
Message-ID: <1592230380387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f4cfcd2d5aea4e96c5d483c476f3057b6b7baf6a Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Sat, 23 May 2020 19:14:55 +0300
Subject: [PATCH] KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL
 unconditionally

This msr is only available when the host supports WAITPKG feature.

This breaks a nested guest, if the L1 hypervisor is set to ignore
unknown msrs, because the only other safety check that the
kernel does is that it attempts to read the msr and
rejects it if it gets an exception.

Cc: stable@vger.kernel.org
Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200523161455.3940-3-mlevitsk@redhat.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c17e6eb9ad43..e0083a08da9e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5242,6 +5242,10 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 				continue;
 			break;
+		case MSR_IA32_UMWAIT_CONTROL:
+			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))

