Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78033ADDB
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhCOIrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:47:39 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:44859 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhCOIrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:47:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2233519408FC;
        Mon, 15 Mar 2021 04:47:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ux5tKY
        thX79vatR3nne6fBd2iuPEaHOVmDF86hHprck=; b=qAg85SO84Rs4DV+0bZ9SzV
        EpK92RTOOWbpcjL4FfIefdcl6BwdO7a3WungFp3DjM9/xtSslxXThyv2aNaIe/de
        uiqB2D1QSMg5VawZdUUOYkrPbVS2kIsuvkdFYFfD0kCiYWzH7A9Z4ycbGzYM+/w0
        lqQhUM9RFQAY7WDu6/38czI3VEfprWQkgeam0Fp4+Kj/vktPgo3b/oocpTzIVacl
        PW1HF2h8bg7Fp9e63jhS0EPhkMceuY1iKrrlHqctB0vFAbuPmFqBbrEVneuH+Df9
        QAH7CidiKpYI3hJXwtrlOOgchvuuq2qaTy65+yM+Q75t8aJKgaX5GZT/xrNQ8Xcg
        ==
X-ME-Sender: <xms:IR9PYOvd75UsyR1uuG7yFbqCmLitQKMDpHBHK5q_--eolUenKOuUYQ>
    <xme:IR9PYDe7HP9QSzMlFVr82NU4rC0gOoT2wZPGyEaaaxfbpNeJqPYe1JOk2ghVvVyXH
    FGVpfrkHYuxyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehfefhveekvdefgeetgfdtvefhuefgieffhfduge
    fhjefhvdeiieetkeejvdekvdenucffohhmrghinheplhhvmhdrlhhvnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IR9PYJx4g6_jWCG0icPniNETTAhhZ7lvNzSo7TwwslcpOh5KiOPqwg>
    <xmx:IR9PYJPuCZb1lKKTsgfZt3hs2Auk2OJez4kdHB3OnNp9XnUGxL4_TQ>
    <xmx:IR9PYO9qWnRH6OcoN7TReT6uO8wZ4OqUcZLiwF2iIrcxuPv_XOU7xA>
    <xmx:Ix9PYAJHaMpM2NXKoBwXQCcGTbIr3xEXq23HfNU1CGeDyHGKhQ2kSA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7600C1080064;
        Mon, 15 Mar 2021 04:47:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged" failed to apply to 4.19-stable tree
To:     wanpengli@tencent.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        zelin.deng@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:47:27 +0100
Message-ID: <161579804781146@kroah.com>
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

From d7eb79c6290c7ae4561418544072e0a3266e7384 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Wed, 24 Feb 2021 09:37:29 +0800
Subject: [PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged

# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                88
On-line CPU(s) list:   0-63
Off-line CPU(s) list:  64-87

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=/dev/mapper/cl-root ro
rd.lvm.lv=cl/root rhgb quiet console=ttyS0 LANG=en_US .UTF-8 no-kvmclock-vsyscall

# echo 1 > /sys/devices/system/cpu/cpu76/online
-bash: echo: write error: Cannot allocate memory

The per-cpu vsyscall pvclock data pointer assigns either an element of the
static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
kvmclock_setup_percpu() which returns -ENOMEM. It's broken for no-vsyscall
and sometimes you end up with vsyscall disabled if the host does something
strange. This patch fixes it by allocating this dynamically memory
unconditionally even if vsyscall is disabled.

Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org#v4.19-rc5+
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index aa593743acf6..1fc0962c89c0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -268,21 +268,20 @@ static void __init kvmclock_init_mem(void)
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
-#ifdef CONFIG_X86_64
-	u8 flags;
+	kvmclock_init_mem();
 
-	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
-		return 0;
+#ifdef CONFIG_X86_64
+	if (per_cpu(hv_clock_per_cpu, 0) && kvmclock_vsyscall) {
+		u8 flags;
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	if (!(flags & PVCLOCK_TSC_STABLE_BIT))
-		return 0;
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		if (!(flags & PVCLOCK_TSC_STABLE_BIT))
+			return 0;
 
-	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+		kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
+	}
 #endif
 
-	kvmclock_init_mem();
-
 	return 0;
 }
 early_initcall(kvm_setup_vsyscall_timeinfo);

