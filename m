Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5A2A5021
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgKCT2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:28:45 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57047 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729665AbgKCT2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:28:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B59631942CD8;
        Tue,  3 Nov 2020 14:28:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:28:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iwBQt9
        ybpuQKk6CC3dSZt9QeINpmN2J7cxp3ni3G/4A=; b=mCabERoVnXCnk1FRDNHjTV
        32+2BYGLYXnsFhwalARrqGZERceutgQczCGmqTweI0tCIEhM1JxVUCkeiRUlBNCs
        GO9AbrB1jRaZgZP0YosCK2I2N5CxGETSYcn8/O4IWOxDp/VvRfKGG2la3LXYhYYB
        fN7rylZKnNHB1YzROE49ATccoOeG6OTW6yk1+1Zew0LmS2Q3us91E8c8leAhVCMv
        3JD59pNfTof6rDa+5Ps7FHiGxZVXwjxH645ZLtuEj07L7tpOjUZ0vkRpfmgDNdWw
        PtcywcZl4JLYUsPlRbqqbCQ2kQvlR7+m9snXGUnP8SxEgWFanU2OWYDDQA8lU0zA
        ==
X-ME-Sender: <xms:a6-hX99QtWx5NkFu4b8J5uLo99CY9lbxf3m6c4hd_S-KiBL2Mtj5jA>
    <xme:a6-hXxvlZWdUZGAVCYc7J_37Uvkvfey9suVljjkF2iGbLgox76X9B1mdINsHTCxiJ
    0BmFKzvTXNf3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:a6-hX7AmfSjVRKAdIlsB8hxH38L_-8GuO7yp2DFYWL4rjDRc80GXpQ>
    <xmx:a6-hXxcFLz1gsj0Zcx6VLHvXUmaxrORAAFOeHvqoONYOtZtVf7jnhQ>
    <xmx:a6-hXyOZDyuy3O4N5Big4J6sT-qzF36r5OCxB95GDedR-BUZ-4OHpg>
    <xmx:a6-hX0384jfyHIWttWEuIKcQm_dR9GVpll0vDjVxwUWCPqjNeN1Hdw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 527E4306467E;
        Tue,  3 Nov 2020 14:28:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] time: Prevent undefined behaviour in timespec64_to_ns()" failed to apply to 4.14-stable tree
To:     prime.zeng@hisilicon.com, arnd@arndb.de, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:28:40 +0100
Message-ID: <1604431720215233@kroah.com>
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

From cb47755725da7b90fecbb2aa82ac3b24a7adb89b Mon Sep 17 00:00:00 2001
From: Zeng Tao <prime.zeng@hisilicon.com>
Date: Tue, 1 Sep 2020 17:30:13 +0800
Subject: [PATCH] time: Prevent undefined behaviour in timespec64_to_ns()

UBSAN reports:

Undefined behaviour in ./include/linux/time64.h:127:27
signed integer overflow:
17179869187 * 1000000000 cannot be represented in type 'long long int'
Call Trace:
 timespec64_to_ns include/linux/time64.h:127 [inline]
 set_cpu_itimer+0x65c/0x880 kernel/time/itimer.c:180
 do_setitimer+0x8e/0x740 kernel/time/itimer.c:245
 __x64_sys_setitimer+0x14c/0x2c0 kernel/time/itimer.c:336
 do_syscall_64+0xa1/0x540 arch/x86/entry/common.c:295

Commit bd40a175769d ("y2038: itimer: change implementation to timespec64")
replaced the original conversion which handled time clamping correctly with
timespec64_to_ns() which has no overflow protection.

Fix it in timespec64_to_ns() as this is not necessarily limited to the
usage in itimers.

[ tglx: Added comment and adjusted the fixes tag ]

Fixes: 361a3bf00582 ("time64: Add time64.h header and define struct timespec64")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1598952616-6416-1-git-send-email-prime.zeng@hisilicon.com

diff --git a/include/linux/time64.h b/include/linux/time64.h
index c9dcb3e5781f..5117cb5b5656 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -124,6 +124,10 @@ static inline bool timespec64_valid_settod(const struct timespec64 *ts)
  */
 static inline s64 timespec64_to_ns(const struct timespec64 *ts)
 {
+	/* Prevent multiplication overflow */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return KTIME_MAX;
+
 	return ((s64) ts->tv_sec * NSEC_PER_SEC) + ts->tv_nsec;
 }
 
diff --git a/kernel/time/itimer.c b/kernel/time/itimer.c
index ca4e6d57d68b..00629e658ca1 100644
--- a/kernel/time/itimer.c
+++ b/kernel/time/itimer.c
@@ -172,10 +172,6 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	u64 oval, nval, ointerval, ninterval;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
-	/*
-	 * Use the to_ktime conversion because that clamps the maximum
-	 * value to KTIME_MAX and avoid multiplication overflows.
-	 */
 	nval = timespec64_to_ns(&value->it_value);
 	ninterval = timespec64_to_ns(&value->it_interval);
 

