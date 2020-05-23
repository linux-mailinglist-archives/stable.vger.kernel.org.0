Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36B81DF720
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387772AbgEWMNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:13:48 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:50837 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387721AbgEWMNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 08:13:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6F81D1940B2D;
        Sat, 23 May 2020 08:13:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 23 May 2020 08:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=b9fjpZ
        cPD5KfOHQHeVLMMb5jGf53RUznL6LccmW3Zk0=; b=AxgtHO8xvD1u/JSDe31gr0
        6CCC3/HdaJSTRzrhbrE+7U9NV5Hrxyd80naE9psnIu1h1bD/iUAGO3G7anacOSuK
        5EF5e/Z+0K9unFoBFSx7jmd4JV3S/gcj+fX6hUszWfXhXqEDC5Jml+FRztxqy0rJ
        mxiUMB/jS6uEtnecAvqARBjE7292QlFVYbjqtO1V1aKhjQ9v3d3hYorOGqZISZvM
        TarsYdHBVOHhjau3Fz6SHeJG5u/NrztxbYbvrR8Wch6bDMywjNwfnHL5gwhR7Xe5
        5WyzAEoAoLdkEPby8Sbdldpqje42/ypLTQcVNhDw9fVFUOiR/8W3rEUDWqUWFlQA
        ==
X-ME-Sender: <xms:exPJXhGi6CosQkQEFvN-wSmIVBxktyssjk-M1S1bC0mjPbNWwRmp1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduhedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:exPJXmVjSrQaufbvr17k6Ql1ytMAFeURKsWHfzPP6Qb-wGRAJdVesA>
    <xmx:exPJXjJodcesIuk4lEvUAn1MM1mfX3tMacDnoOHbGsWDN9Mn-Mz8nw>
    <xmx:exPJXnG1lRdeF4hEuFwo81Vg3VyN4Fu1HOfephClG9SkljNnWbRl3A>
    <xmx:exPJXvjdaow54mb11LPq888S7JkZtuzObJ8OpsWesQdxPGcv3aT3vA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 123713280060;
        Sat, 23 May 2020 08:13:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/64s: Disable STRICT_KERNEL_RWX" failed to apply to 4.14-stable tree
To:     mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 23 May 2020 14:13:37 +0200
Message-ID: <159023601736250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

