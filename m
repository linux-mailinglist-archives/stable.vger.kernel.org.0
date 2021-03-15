Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C433ADDE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCOIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:48:11 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:45863 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhCOIrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:47:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E02671940919;
        Mon, 15 Mar 2021 04:47:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZxXPMd
        138PG6BzN2tFZfCPqBZNJoxRb92bjYBK0Lfh8=; b=k89fOYz/zjF7XUWsH8+sIi
        nJXcb7oFw5hn7hDc3uaLgDHvqYHed2G471esZRGSu7E5Hzt29tRCbE5fxn6CLPnq
        VHenHdimyx7nP6kFs9fYJAX9e2laXO0g/IzrhznVwT7cyCfklTZcqGWVMhtdLxAR
        UBUIcos3hgft8leUAVSD4Zozid8R2wlfbfYlcUd6KxQHxSqN6bwGFz7OHyjNx6fM
        lVzqOQjfJ+sjFe/xy/3EbASVB1HKoTz8dfDt7FvnWK7wA09f0ICf2baKXxDh20YZ
        IiA0dQS77iWSaKtTZy4eBELkuDJxiiQyWZvQeqTAx4AaDKNcx3O2WAkBzDwF3o4w
        ==
X-ME-Sender: <xms:Kh9PYPiH5KXxSmH2JOlANoawBxrHKojOMzzfyLLgmbPLIjVBmPnnTQ>
    <xme:Kh9PYMDQDKU08YmjGPJQz9VYiKw_olFcP_Fplc-QjuZGrgBZuD7k-FSgufk7deLOX
    a2aaRsVU4dAEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeehfefhveekvdefgeetgfdtvefhuefgieffhfduge
    fhjefhvdeiieetkeejvdekvdenucffohhmrghinheplhhvmhdrlhhvnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Kh9PYPG5YbJpf4_E6RxQeES_5ywqO9dLSjc0iN5DBqCPwsmEImzXTQ>
    <xmx:Kh9PYMQdum2UJBtPnJsTsJeRSJ96YQ-kTggmBuMEA0K-_xrCSSYMeg>
    <xmx:Kh9PYMyI8JPXxMbeyuckmmvmWMElRI7BNiOFTgrjDCAlBLe6gTjdTg>
    <xmx:Kh9PYH9jP63dv_oXFFgl79HygkkgrSsyg0guoT9AeX-h3XqN6Rqteg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B51224005B;
        Mon, 15 Mar 2021 04:47:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged" failed to apply to 5.4-stable tree
To:     wanpengli@tencent.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        zelin.deng@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:47:28 +0100
Message-ID: <16157980481175@kroah.com>
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

