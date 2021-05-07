Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC56D37684E
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhEGPwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:52:01 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34793 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234693AbhEGPwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:52:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id D701B19415C2;
        Fri,  7 May 2021 11:50:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 07 May 2021 11:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=X06GPV
        ALsnmPPSeViwLyVzH2db6Z/NDyG1dbxdGgRvI=; b=lwLtLJNk3RzwX/LbZGRjhv
        ZscmCkLiNJ/lvouDH6qIpBsTGWxsyA2eiwEZCC5nXb73ik2uz2UEbNqJ2jBBx6l/
        6i2wuWNK2JwzcZ9MjUGATC3jOpAIihKyUD8SG6UWkijoc/5MehHPc4CV0a7JHXrB
        QYrW8YC1i0+Hz45btdaj9Z+8GMU/PNRm+c45nrfsdS4JPt9pkGe4bg0atQKTy0Kd
        qxTKx4v8JUXCwh5gMuTbFxBSGTHH28hvd0+lKQs8Wl4SmO1H8d+H3l07Y72Vz2Mf
        rwBvraRwI4KPf1BL36ivQXGISpGVbk+X2ZNVjhXhxJ9PH7yeJlWC+WBiyiMIFUog
        ==
X-ME-Sender: <xms:42GVYJHDR6XcGM86e_tLR8Vrz2iwsjPcR4PgTiOiSCQVi9JdxN0tMg>
    <xme:42GVYOWm5Ch1Z8WY13FC3r77LHDn4dlqGP8S1L5Wd8rYaykoWYzMnmuvU1fDEZSIh
    Oh3onqnBN1QOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:42GVYLIlyT-QKiZI_iL0iu8X5n4k5yg3XuYATMty7FUnpTRGX4UJ7A>
    <xmx:42GVYPFkfkE6yJvUNM8BsW9fE-kX-shkt6SwhG2aKdEAHKD9gDRp-Q>
    <xmx:42GVYPVE8bnUIL53CIB-b0UUVpg5ksDZ6RYkHbhoBQM-Xat1gJTNqw>
    <xmx:42GVYGe9KFNbxpH_z-oYjL91IsDOmNekuukohObfoFEDb0bPq80plg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:50:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] posix-timers: Preserve return value in clock_adjtime32()" failed to apply to 4.14-stable tree
To:     chenjun102@huawei.com, richardcochran@gmail.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 17:50:55 +0200
Message-ID: <1620402655187231@kroah.com>
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

From 2d036dfa5f10df9782f5278fc591d79d283c1fad Mon Sep 17 00:00:00 2001
From: Chen Jun <chenjun102@huawei.com>
Date: Wed, 14 Apr 2021 03:04:49 +0000
Subject: [PATCH] posix-timers: Preserve return value in clock_adjtime32()

The return value on success (>= 0) is overwritten by the return value of
put_old_timex32(). That works correct in the fault case, but is wrong for
the success case where put_old_timex32() returns 0.

Just check the return value of put_old_timex32() and return -EFAULT in case
it is not zero.

[ tglx: Massage changelog ]

Fixes: 3a4d44b61625 ("ntp: Move adjtimex related compat syscalls to native counterparts")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414030449.90692-1-chenjun102@huawei.com

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index bf540f5a4115..dd5697d7347b 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1191,8 +1191,8 @@ SYSCALL_DEFINE2(clock_adjtime32, clockid_t, which_clock,
 
 	err = do_clock_adjtime(which_clock, &ktx);
 
-	if (err >= 0)
-		err = put_old_timex32(utp, &ktx);
+	if (err >= 0 && put_old_timex32(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }

