Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C3F61FA58
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiKGQsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiKGQsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:48:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A1EC
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 100FC611B9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F61BC433D7;
        Mon,  7 Nov 2022 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839700;
        bh=BUpMLAqOwblJlkDGKEXJFI/F/T/QP5WQPQNn4R6F4jw=;
        h=Subject:To:Cc:From:Date:From;
        b=afo7j6Ni1gT65uTKMCqPf5Tx+3Rn5MMIz/dq3sWTCuwXTipdeE7b8NjOdJM7MqyGt
         c1jh/imKFUJaj/oBCQpvChB05VC8sPzH2+RIW9s2+gFygHoRuseXnp4BnkSCP9f1w+
         BN0H8AL13RW/j1bPwxBZKwh6JsugWAXB3QTpp0us=
Subject: FAILED: patch "[PATCH] KVM: x86: Mask off reserved bits in CPUID.80000001H" failed to apply to 4.14-stable tree
To:     jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:48:06 +0100
Message-ID: <1667839686209184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0469e56a14bf ("KVM: x86: Mask off reserved bits in CPUID.80000001H")
bd7919999047 ("KVM: x86: Override host CPUID results with kvm_cpu_caps")
09f628a0b49c ("KVM: x86: Fold CPUID 0x7 masking back into __do_cpuid_func()")
90d2f60f41f7 ("KVM: x86: Use KVM cpu caps to track UMIP emulation")
b3d895d5c415 ("KVM: x86: Move XSAVES CPUID adjust to VMX's KVM cpu cap update")
3ec6fd8cf0ba ("KVM: VMX: Convert feature updates from CPUID to KVM cpu caps")
9b58b9857f22 ("KVM: SVM: Convert feature updates from CPUID to KVM cpu caps")
66a6950f9995 ("KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking")
9e6d01c2d908 ("KVM: x86: Refactor handling of XSAVES CPUID adjustment")
fb7d4377d513 ("KVM: x86: handle GBPAGE CPUID adjustment for EPT with generic code")
dbd068040c64 ("KVM: x86: Handle Intel PT CPUID adjustment in VMX code")
733deafc00df ("KVM: x86: Handle RDTSCP CPUID adjustment in VMX code")
d64d83d1e026 ("KVM: x86: Handle PKU CPUID adjustment in VMX code")
e574768f841b ("KVM: x86: Handle UMIP emulation CPUID adjustment in VMX code")
5ffec6f910dc ("KVM: x86: Handle INVPCID CPUID adjustment in VMX code")
6c7ea4b56bfe ("KVM: x86: Handle MPX CPUID adjustment in VMX code")
e745e37d4977 ("KVM: x86: Refactor cpuid_mask() to auto-retrieve the register")
b32666b13a72 ("KVM: x86: Introduce cpuid_entry_{change,set,clear}() mutators")
4c61534aaae2 ("KVM: x86: Introduce cpuid_entry_{get,has}() accessors")
5e12b2bb34e9 ("KVM: x86: Replace bare "unsigned" with "unsigned int" in cpuid helpers")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0469e56a14bf8cfb80507e51b7aeec0332cdbc13 Mon Sep 17 00:00:00 2001
From: Jim Mattson <jmattson@google.com>
Date: Fri, 30 Sep 2022 00:51:58 +0200
Subject: [PATCH] KVM: x86: Mask off reserved bits in CPUID.80000001H

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.80000001:EBX[27:16] are reserved bits and
should be masked off.

Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7065462378e2..834feeb0a828 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1133,6 +1133,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->eax = max(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
+		entry->ebx &= ~GENMASK(27, 16);
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;

