Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98860337B44
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCKRoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:44:05 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60753 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhCKRnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:43:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 14BB4194100A;
        Thu, 11 Mar 2021 12:43:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 12:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=60t78H
        YZe79y1Pkqm1nL5Mga86eU80+wdBJsTC03J2I=; b=qmtyi5Gh3knoMN5ThB956K
        4WyfsBp1DbJU+8nN5OBaZra8yqOS9WmS4z5XnxlrFrIt5Ru+7VpZsRPLy0uQdpjc
        dQCygkSvcn3JT8cc+C/BO59NbGPI2wieLVEbOnsKG38uTJq9W11UAgfTmByVMQVR
        37EflndrkGL9Aop+Sv3SpYMaYR57/t+Etc2YmIbSl0FBDphJlZ5sKX88aso7Gdp8
        DXpbxnGrP3QbWJVkV5eoJe7ISTkHUcsvqFVNRXc9FRCd0dcEgg9isbDLwgJSmR4w
        usANn2oP4HaHEogah4yOsnGkSJLbxOfYNDY9EPxNlSTbhAXSy2BFfFlNotm5gArQ
        ==
X-ME-Sender: <xms:zFZKYG0w-5VQtZETT_IB6agpf2ex6dIsP96pitq9Zmz1-xnzu53FcQ>
    <xme:zFZKYBjntPwraaG-aB8rw2uqyztDf6VuhjQ5XLzrqYSEoaIJt7dahzotKqMI4Di69
    uOwviyUFnNpQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zFZKYPVks94JMBH-DAShroti7Byvb3TqOOXSNBuDSsiQtyKQqqymZg>
    <xmx:zFZKYIXpZ-2YkfFVn2Z3Tg7a6Grksjd3XpnCa5ynUkVUsStqb3Z7Gg>
    <xmx:zFZKYHgK2JxBMy9VuJhxPDu18LSZM7E5t68S2Tv34lkfKhVrXIgM0w>
    <xmx:zlZKYOYOLqiz14F8iIO04-QMyvlhCjGLNntIyGbzjX46MiVtFawjIg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A77024005B;
        Thu, 11 Mar 2021 12:43:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/perf: Fix handling of privilege level checks in perf" failed to apply to 4.19-stable tree
To:     atrajeev@linux.vnet.ibm.com, mpe@ellerman.id.au,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:43:31 +0100
Message-ID: <1615484611128126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 5ae5fbd2107959b68ac69a8b75412208663aea88 Mon Sep 17 00:00:00 2001
From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Date: Thu, 25 Feb 2021 05:10:39 -0500
Subject: [PATCH] powerpc/perf: Fix handling of privilege level checks in perf
 interrupt context

Running "perf mem record" in powerpc platforms with selinux enabled
resulted in soft lockup's. Below call-trace was seen in the logs:

  CPU: 58 PID: 3751 Comm: sssd_nss Not tainted 5.11.0-rc7+ #2
  NIP:  c000000000dff3d4 LR: c000000000dff3d0 CTR: 0000000000000000
  REGS: c000007fffab7d60 TRAP: 0100   Not tainted  (5.11.0-rc7+)
  ...
  NIP _raw_spin_lock_irqsave+0x94/0x120
  LR  _raw_spin_lock_irqsave+0x90/0x120
  Call Trace:
    0xc00000000fd47260 (unreliable)
    skb_queue_tail+0x3c/0x90
    audit_log_end+0x6c/0x180
    common_lsm_audit+0xb0/0xe0
    slow_avc_audit+0xa4/0x110
    avc_has_perm+0x1c4/0x260
    selinux_perf_event_open+0x74/0xd0
    security_perf_event_open+0x68/0xc0
    record_and_restart+0x6e8/0x7f0
    perf_event_interrupt+0x22c/0x560
    performance_monitor_exception0x4c/0x60
    performance_monitor_common_virt+0x1c8/0x1d0
  interrupt: f00 at _raw_spin_lock_irqsave+0x38/0x120
  NIP:  c000000000dff378 LR: c000000000b5fbbc CTR: c0000000007d47f0
  REGS: c00000000fd47860 TRAP: 0f00   Not tainted  (5.11.0-rc7+)
  ...
  NIP _raw_spin_lock_irqsave+0x38/0x120
  LR  skb_queue_tail+0x3c/0x90
  interrupt: f00
    0x38 (unreliable)
    0xc00000000aae6200
    audit_log_end+0x6c/0x180
    audit_log_exit+0x344/0xf80
    __audit_syscall_exit+0x2c0/0x320
    do_syscall_trace_leave+0x148/0x200
    syscall_exit_prepare+0x324/0x390
    system_call_common+0xfc/0x27c

The above trace shows that while the CPU was handling a performance
monitor exception, there was a call to security_perf_event_open()
function. In powerpc core-book3s, this function is called from
perf_allow_kernel() check during recording of data address in the
sample via perf_get_data_addr().

Commit da97e18458fb ("perf_event: Add support for LSM and SELinux
checks") introduced security enhancements to perf. As part of this
commit, the new security hook for perf_event_open() was added in all
places where perf paranoid check was previously used. In powerpc
core-book3s code, originally had paranoid checks in
perf_get_data_addr() and power_pmu_bhrb_read(). So
perf_paranoid_kernel() checks were replaced with perf_allow_kernel()
in these PMU helper functions as well.

The intention of paranoid checks in core-book3s was to verify
privilege access before capturing some of the sample data. Along with
paranoid checks, perf_allow_kernel() also does a
security_perf_event_open(). Since these functions are accessed while
recording a sample, we end up calling selinux_perf_event_open() in PMI
context. Some of the security functions use spinlock like
sidtab_sid2str_put(). If a perf interrupt hits under a spin lock and
if we end up in calling selinux hook functions in PMI handler, this
could cause a dead lock.

Since the purpose of this security hook is to control access to
perf_event_open(), it is not right to call this in interrupt context.

The paranoid checks in powerpc core-book3s were done at interrupt time
which is also not correct.

Reference commits:
  Commit cd1231d7035f ("powerpc/perf: Prevent kernel address leak via perf_get_data_addr()")
  Commit bb19af816025 ("powerpc/perf: Prevent kernel address leak to userspace via BHRB buffer")

We only allow creation of events that have already passed the
privilege checks in perf_event_open(). So these paranoid checks are
not needed at event time. As a fix, patch uses
'event->attr.exclude_kernel' check to prevent exposing kernel address
for userspace only sampling.

Fixes: cd1231d7035f ("powerpc/perf: Prevent kernel address leak via perf_get_data_addr()")
Cc: stable@vger.kernel.org # v4.17+
Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1614247839-1428-1-git-send-email-atrajeev@linux.vnet.ibm.com

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 6817331e22ff..766f064f00fb 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -222,7 +222,7 @@ static inline void perf_get_data_addr(struct perf_event *event, struct pt_regs *
 	if (!(mmcra & MMCRA_SAMPLE_ENABLE) || sdar_valid)
 		*addrp = mfspr(SPRN_SDAR);
 
-	if (is_kernel_addr(mfspr(SPRN_SDAR)) && perf_allow_kernel(&event->attr) != 0)
+	if (is_kernel_addr(mfspr(SPRN_SDAR)) && event->attr.exclude_kernel)
 		*addrp = 0;
 }
 
@@ -507,7 +507,7 @@ static void power_pmu_bhrb_read(struct perf_event *event, struct cpu_hw_events *
 			 * addresses, hence include a check before filtering code
 			 */
 			if (!(ppmu->flags & PPMU_ARCH_31) &&
-				is_kernel_addr(addr) && perf_allow_kernel(&event->attr) != 0)
+			    is_kernel_addr(addr) && event->attr.exclude_kernel)
 				continue;
 
 			/* Branches are read most recent first (ie. mfbhrb 0 is

