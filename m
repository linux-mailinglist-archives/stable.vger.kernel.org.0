Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A423AE7A6
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhFUKyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:54:04 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58147 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhFUKyD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:54:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 34FCE19402AA;
        Mon, 21 Jun 2021 06:51:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 06:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=s+qiYS
        3GJq5VeWMRLEse8RBMRLvexZ4P+11slcnm/AM=; b=dwjJU7wE5LKhR7k13adkxR
        LIc7Y/J50DipJ7yMYFKHl1trs94NAc/fMeDCLyLEbUJ8NySreT0RcBQjg5HhOB0p
        /aerwVzd4cnnJ4yKjZTtDTnyfj5KIxJeNq6Ctv5EaOGWS9XD0huejii09R+CBviE
        k6oQox3fTELaD+AnAAPwZa1E+CTZdVHXsTitxW4rrzANG3VP2+sWlpz7U/s7AqpR
        /QxH293vO7bZmOFi20k5x/Ekpt/Rg/vcnye4bKxjf3JaYl4e5YHIIxpqy9HMFHCI
        ZJ9Ztk4191DEDHLXv2O43vnRo386My6au7JBCitL7KSZQr5KA/0UobKTgCDbAnVg
        ==
X-ME-Sender: <xms:RG_QYI__RaDeDURZUdBIsTnu6nhhUvaS1kZuIOmV7FJtI2Xgo7KePg>
    <xme:RG_QYAtmMgOkEnl44FhT4PcrJ2zqtttYZz0tm8vP-t1Je9Vky7K7j6uEE_oVO7sI4
    zzGUNZSnM6QRQ>
X-ME-Received: <xmr:RG_QYOCspzdIlARWO_YhuDwXAV2QdmRm02invz1saP19grti8YwYoko00scOMebG7YlcsDhu1S8AbOhcdFj65e5S6NKdMagx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:RG_QYIdHGTsqfvOHO_H8bxY9W2Oo8lYP71HFaSkNPep4GuUo_Cm7PQ>
    <xmx:RG_QYNOCvh44jJnTt2-MFrIeZR3MIguoeyf0Axo-u4UvyhSi-DyKvA>
    <xmx:RG_QYCniEVYitdnnVIpU3kxpPeIsyG_QVAFLjg1ksUwEUFI1SjSsew>
    <xmx:RW_QYCqGkIztE8v0kfwjOKk0g5EgQMAsyow4y_8Y_h8gE-jwS5TTJw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:51:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/fpu: Invalidate FPU state after a failed XRSTOR from a" failed to apply to 5.4-stable tree
To:     luto@kernel.org, bp@suse.de, dave.hansen@linux.intel.com,
        riel@surriel.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:51:46 +0200
Message-ID: <162427270623162@kroah.com>
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

From d8778e393afa421f1f117471144f8ce6deb6953a Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 8 Jun 2021 16:36:19 +0200
Subject: [PATCH] x86/fpu: Invalidate FPU state after a failed XRSTOR from a
 user buffer

Both Intel and AMD consider it to be architecturally valid for XRSTOR to
fail with #PF but nonetheless change the register state.  The actual
conditions under which this might occur are unclear [1], but it seems
plausible that this might be triggered if one sibling thread unmaps a page
and invalidates the shared TLB while another sibling thread is executing
XRSTOR on the page in question.

__fpu__restore_sig() can execute XRSTOR while the hardware registers
are preserved on behalf of a different victim task (using the
fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
modify the registers.

If this happens, then there is a window in which __fpu__restore_sig()
could schedule out and the victim task could schedule back in without
reloading its own FPU registers. This would result in part of the FPU
state that __fpu__restore_sig() was attempting to load leaking into the
victim task's user-visible state.

Invalidate preserved FPU registers on XRSTOR failure to prevent this
situation from corrupting any state.

[1] Frequent readers of the errata lists might imagine "complex
    microarchitectural conditions".

Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144345.758116583@linutronix.de

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index d5bc96a536c2..4ab9aeb9a963 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -369,6 +369,25 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 			fpregs_unlock();
 			return 0;
 		}
+
+		/*
+		 * The above did an FPU restore operation, restricted to
+		 * the user portion of the registers, and failed, but the
+		 * microcode might have modified the FPU registers
+		 * nevertheless.
+		 *
+		 * If the FPU registers do not belong to current, then
+		 * invalidate the FPU register state otherwise the task might
+		 * preempt current and return to user space with corrupted
+		 * FPU registers.
+		 *
+		 * In case current owns the FPU registers then no further
+		 * action is required. The fixup below will handle it
+		 * correctly.
+		 */
+		if (test_thread_flag(TIF_NEED_FPU_LOAD))
+			__cpu_invalidate_fpregs_state();
+
 		fpregs_unlock();
 	} else {
 		/*

