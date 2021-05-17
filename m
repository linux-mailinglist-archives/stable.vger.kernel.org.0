Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4273826E6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbhEQI0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:26:32 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42599 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQI0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:26:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 8DDB09FA;
        Mon, 17 May 2021 04:25:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 May 2021 04:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MC2Qvo
        5Obj1B+utrVkC3VNiKZ/Kqzw96mfrvXzhcqQo=; b=LoDWb+cmq5BgCEBA5DYjZT
        dvc4eCHY4iTySf0o4BQELd7F9ldaqFkEHgTCJWGtDp//R0EjGNESlImezdTU8bqG
        019MJAI0SUnG3PVc64JSF1aPm4NpVg/ud+uZ1PCsGQGEyOEWUvtHVovCmCTFRg45
        UGAH/T+PL/AdcutSp4LTqsFGYzYfxC7fTbGjlMjOz8Wmyh+5b9T/MwFcCF5Oo9ro
        tJ/SqDjekToahgttl4Bgs5/lmi8kZSmtHuiURD2DOqR4SthwrvobRNnzRozRd13Z
        l5S/HxH2pFxl5tLzpfvz6M6rgSk29ZG3h+125MHfOMY8B5G4EF6TDiruiuyiY7Ug
        ==
X-ME-Sender: <xms:ayiiYFFuqifsZ9eFVTHCNLFTcndgetMOknoNkYAHX1lNbycwTeSRug>
    <xme:ayiiYKXaTzsif_m8P5Nv3V5iCKzp15yAwtXZXDCnTWJOgIaE6MctcfadiqVEatYba
    cARJ7EyLOc2SA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ayiiYHKu7Jw7hP8k8d2RTFhvp9knlR6uPFLf0t-JgNZuxI3RnRm0dA>
    <xmx:ayiiYLEefGcnoGn8TYDwuIUIoDj7YckL4Lo9vWa7zboeYPSTbldNUw>
    <xmx:ayiiYLXb25ivkIqhi0JbXRDGswASbQE45hou9eN389WAOOM-2-9b_A>
    <xmx:ayiiYIjKwCoMHx5LJwZaVyL8hhpoV78XxXlc8xETIdLVbS6G2M2ITsnv_yk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:25:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Emulate RDPID only if RDTSCP is supported" failed to apply to 4.14-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com,
        reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:25:00 +0200
Message-ID: <162123990010435@kroah.com>
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

