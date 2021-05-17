Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566D73826E7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhEQI0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:26:35 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37065 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQI0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:26:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1FA50A0B;
        Mon, 17 May 2021 04:25:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7vqvFs
        oiRHz01/pP8OjlXl6hrkUr5gDuCHW9R9CSev8=; b=iaC66S5f8qBOrOE5I7BuRI
        9dy+iIxK/xcQyGWO7MevwUc9f7aJrZfX8XBkA6IfA+tU1Cea4Ukah5ZLv+HWzDlr
        bfaO8omOufeCrWtEvlhtRSPlxCrfPZJRWOk8GwlJgLf26HgtaAw6WI32so9v6LKn
        EGeov9r2khwtPj4FpV3pHzyJRsiQ9+82gnUOJwySif6VSlkzO+MY6UR2G4IpPxq4
        nd+ib35cjyq+z2j/pFrRNbmBVri7vEHGC49vI27A+YfIEnaJbe6ugvL/73Jw1Wyu
        8d+uGCIMqqzZi/2hL5ZemG0s0Xw+kdsgodPsdP7lKG50qN8u/BpqPCimn51fe2IQ
        ==
X-ME-Sender: <xms:bSiiYPpcV5M19SFoZY-q9673m4qqAY7fmyKtgbGSfFI6i3R97RP8Nw>
    <xme:bSiiYJpOKQRHd7XSyK6REm6TqtQf_3G5M1cg-Tr7kUiGE6DMGeAiF_v0a3dIJUpom
    heqPV4t3fytdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:bSiiYMMrjds6_wW53B4T2hHHEKgKs6KK6p0Q381r_HClLIqVivGCNg>
    <xmx:bSiiYC5AFAfvaA5w6dl9FTaPU0zDGR9VfLPg2sBRrzVC-pVdOV5GCg>
    <xmx:bSiiYO5r9H9dZwdBMfylQ7hYO1fOXLywr7ey0Z44lAf9pdyp8wi67Q>
    <xmx:bSiiYOHIu3W6zbBVSV_qaajrp6_Xl_Tnrj0ZUVvbg13YMTEdH1WKRLslGLg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:25:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Emulate RDPID only if RDTSCP is supported" failed to apply to 5.4-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com,
        reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:25:01 +0200
Message-ID: <162123990171131@kroah.com>
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

From 85d0011264da24be08ae907d7f29983a597ca9b1 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:21 -0700
Subject: [PATCH] KVM: x86: Emulate RDPID only if RDTSCP is supported

Do not advertise emulation support for RDPID if RDTSCP is unsupported.
RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
inject a #UD.

Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
but this is a KVM bug and will eventually be fixed.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-3-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 19606a341888..c0e8c5e92189 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	case 7:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		entry->eax = 0;
-		entry->ecx = F(RDPID);
+		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			entry->ecx = F(RDPID);
 		++array->nent;
 	default:
 		break;

