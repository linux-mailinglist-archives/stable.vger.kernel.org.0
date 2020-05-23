Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD5E1DF71E
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbgEWMNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:13:41 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:36877 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387721AbgEWMNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 08:13:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6C5F51940A3F;
        Sat, 23 May 2020 08:13:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 23 May 2020 08:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NuwbFH
        MrueZvHhX85ffQZYxAtQ3uKrh3ZN23ASn8IRM=; b=fX9xzKtNtmcjZMuNg3mfCv
        736Fd7ZAP0G4GVqhm+Ip4ElYgsV35YsmwWsVDczT99oPA8btYXbZFNQnDA81LHcd
        eKzO4n5Nn8rnInVNlVULcGUAiWMcsUyoQP3R37oITKMwkKEuslEcsxx68Ctw7NSz
        dqtm2itjikCWE63azGPZF/iicAk9UgqTGx1HjnAAWMd3m/PzixWe5SKrbSNECO3a
        s8qCQxJ30CpodcEH0pI+obD9qk5sFmJOctlEFp8aPFSxwAv06J8p+I2ZK3Xgvigt
        LsonmQWT2wFBh4wwB21x4uBFEvNx41AZ7IN4JXmtSsE1RCUpLEQov0sFgDKSlQ4Q
        ==
X-ME-Sender: <xms:cxPJXr0fTEJ2qWSrHd59eIa0EE4tBK9LY0HlfEwjQIxCqdgPHIHsgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduhedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cxPJXqFtHw8n8t-_TpszasanpeBe4lGTb1yDk9h2NmVc2eAUE_HH0w>
    <xmx:cxPJXr6rrFKdJ5tMntADT7j1-o-MjEZvyS72UQzW_A76btjDYi_R9w>
    <xmx:cxPJXg1A3bEkt43-l92iuJ6S66NXaiqCTgUoiPSDn6Y3JJaPFCeZFg>
    <xmx:dBPJXiTlJ1n1T1ZmBYwwuxiZ1yoCZaGpJ99C6N7StmMwRJojh4rfOA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C69E73280060;
        Sat, 23 May 2020 08:13:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64s: Disable STRICT_KERNEL_RWX" failed to apply to 5.4-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 14:13:35 +0200
Message-ID: <1590236015151171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 8659a0e0efdd975c73355dbc033f79ba3b31e82c Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Wed, 20 May 2020 23:36:05 +1000
Subject: [PATCH] powerpc/64s: Disable STRICT_KERNEL_RWX

Several strange crashes have been eventually traced back to
STRICT_KERNEL_RWX and its interaction with code patching.

Various paths in our ftrace, kprobes and other patching code need to
be hardened against patching failures, otherwise we can end up running
with partially/incorrectly patched ftrace paths, kprobes or jump
labels, which can then cause strange crashes.

Although fixes for those are in development, they're not -rc material.

There also seem to be problems with the underlying strict RWX logic,
which needs further debugging.

So for now disable STRICT_KERNEL_RWX on 64-bit to prevent people from
enabling the option and tripping over the bugs.

Fixes: 1e0fc9d1eb2b ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX for some configs")
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200520133605.972649-1-mpe@ellerman.id.au

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 924c541a9260..d13b5328ca10 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -130,7 +130,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC32 && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64

