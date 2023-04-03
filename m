Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558E6D3F32
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjDCIkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjDCIkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:40:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBDB188
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 193EE611B6
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B8C433D2;
        Mon,  3 Apr 2023 08:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680511209;
        bh=HmaAtDxVSmSg4vJpagIdeFBfKQklHJMo4AdgEHOsGYY=;
        h=Subject:To:Cc:From:Date:From;
        b=2s5BTug82ONtN+kEzb702QNZjV/skWNqbLjYGE5mufEXTrCxqCenBUWyIG1ZrgZJn
         NKduxzDGrQSWl1MWvY3GYkXwtbqAgKLMwQjkFB5GxLA8Rxo0az7wk/KRge0X0NUUuw
         M6isTnS7Abghhuy4JISCce4bUpmiomfHyVQEdC1o=
Subject: FAILED: patch "[PATCH] powerpc: Don't try to copy PPR for task with NULL pt_regs" failed to apply to 4.19-stable tree
To:     axboe@kernel.dk, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:40:05 +0200
Message-ID: <2023040304-splashed-consult-3a39@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x fd7276189450110ed835eb0a334e62d2f1c4e3be
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040304-splashed-consult-3a39@gregkh' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

fd7276189450 ("powerpc: Don't try to copy PPR for task with NULL pt_regs")
47e12855a91d ("powerpc: switch to ->regset_get()")
6e0b79750ce2 ("powerpc/ptrace: move register viewing functions out of ptrace.c")
7c1f8db019f8 ("powerpc/ptrace: split out TRANSACTIONAL_MEM related functions.")
60ef9dbd9d2a ("powerpc/ptrace: split out SPE related functions.")
1b20773b00b7 ("powerpc/ptrace: split out ALTIVEC related functions.")
7b99ed4e8e3a ("powerpc/ptrace: split out VSX related functions.")
963ae6b2ff1c ("powerpc/ptrace: drop PARAMETER_SAVE_AREA_OFFSET")
f1763e623c69 ("powerpc/ptrace: drop unnecessary #ifdefs CONFIG_PPC64")
b3138536c837 ("powerpc/ptrace: remove unused header includes")
da9a1c10e2c7 ("powerpc: Move ptrace into a subdirectory.")
68b34588e202 ("powerpc/64/sycall: Implement syscall entry/exit logic in C")
965dd3ad3076 ("powerpc/64/syscall: Remove non-volatile GPR save optimisation")
fddb5d430ad9 ("open: introduce openat2(2) syscall")
793b08e2efff ("powerpc/kexec: Move kexec files into a dedicated subdir.")
9f7bd9201521 ("powerpc/32: Split kexec low level code out of misc_32.S")
b020aa9d1e87 ("powerpc: cleanup hw_irq.h")
0671c5b84e9e ("MIPS: Wire up clone3 syscall")
45824fc0da6e ("Merge tag 'powerpc-5.4-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fd7276189450110ed835eb0a334e62d2f1c4e3be Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 26 Mar 2023 16:15:57 -0600
Subject: [PATCH] powerpc: Don't try to copy PPR for task with NULL pt_regs

powerpc sets up PF_KTHREAD and PF_IO_WORKER with a NULL pt_regs, which
from my (arguably very short) checking is not commonly done for other
archs. This is fine, except when PF_IO_WORKER's have been created and
the task does something that causes a coredump to be generated. Then we
get this crash:

  Kernel attempted to read user page (160) - exploit attempt? (uid: 1000)
  BUG: Kernel NULL pointer dereference on read at 0x00000160
  Faulting instruction address: 0xc0000000000c3a60
  Oops: Kernel access of bad area, sig: 11 [#1]
  LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=32 NUMA pSeries
  Modules linked in: bochs drm_vram_helper drm_kms_helper xts binfmt_misc ecb ctr syscopyarea sysfillrect cbc sysimgblt drm_ttm_helper aes_generic ttm sg libaes evdev joydev virtio_balloon vmx_crypto gf128mul drm dm_mod fuse loop configfs drm_panel_orientation_quirks ip_tables x_tables autofs4 hid_generic usbhid hid xhci_pci xhci_hcd usbcore usb_common sd_mod
  CPU: 1 PID: 1982 Comm: ppc-crash Not tainted 6.3.0-rc2+ #88
  Hardware name: IBM pSeries (emulated by qemu) POWER9 (raw) 0x4e1202 0xf000005 of:SLOF,HEAD hv:linux,kvm pSeries
  NIP:  c0000000000c3a60 LR: c000000000039944 CTR: c0000000000398e0
  REGS: c0000000041833b0 TRAP: 0300   Not tainted  (6.3.0-rc2+)
  MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 88082828  XER: 200400f8
  ...
  NIP memcpy_power7+0x200/0x7d0
  LR  ppr_get+0x64/0xb0
  Call Trace:
    ppr_get+0x40/0xb0 (unreliable)
    __regset_get+0x180/0x1f0
    regset_get_alloc+0x64/0x90
    elf_core_dump+0xb98/0x1b60
    do_coredump+0x1c34/0x24a0
    get_signal+0x71c/0x1410
    do_notify_resume+0x140/0x6f0
    interrupt_exit_user_prepare_main+0x29c/0x320
    interrupt_exit_user_prepare+0x6c/0xa0
    interrupt_return_srr_user+0x8/0x138

Because ppr_get() is trying to copy from a PF_IO_WORKER with a NULL
pt_regs.

Check for a valid pt_regs in both ppc_get/ppr_set, and return an error
if not set. The actual error value doesn't seem to be important here, so
just pick -EINVAL.

Fixes: fa439810cc1b ("powerpc/ptrace: Enable support for NT_PPPC_TAR, NT_PPC_PPR, NT_PPC_DSCR")
Cc: stable@vger.kernel.org # v4.8+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[mpe: Trim oops in change log, add Fixes & Cc stable]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/d9f63344-fe7c-56ae-b420-4a1a04a2ae4c@kernel.dk

diff --git a/arch/powerpc/kernel/ptrace/ptrace-view.c b/arch/powerpc/kernel/ptrace/ptrace-view.c
index 2087a785f05f..5fff0d04b23f 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -290,6 +290,9 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 static int ppr_get(struct task_struct *target, const struct user_regset *regset,
 		   struct membuf to)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return membuf_write(&to, &target->thread.regs->ppr, sizeof(u64));
 }
 
@@ -297,6 +300,9 @@ static int ppr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count, const void *kbuf,
 		   const void __user *ubuf)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &target->thread.regs->ppr, 0, sizeof(u64));
 }

