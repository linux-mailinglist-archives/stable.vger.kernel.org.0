Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A55837684F
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhEGPwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:52:10 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41011 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234870AbhEGPwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:52:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6D89019415BC;
        Fri,  7 May 2021 11:51:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 May 2021 11:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=88DM9E
        4V5JNz8l6a8aV5cIj3jTtWpRZTQBZGvLNftsE=; b=bWDamhhuwfeHN7EpqdK62k
        YVAafHJtxOCWEiIOYc67vsyegdmmnbYa0sGXGTuBmC8++9jXTQRMf4oXCC9AX8ks
        4jS+aWSwzHhrLKF9LeA5uAWYsWlvo2JH697pokSmmHNX6CjphCOGUdWYqoRblkqy
        T9Y7p1VEFr5bXcJSJfCP+/l5IVofZ6F/HhE4NNsVLXuaaFv+og3cpyeQnrbaxeBf
        tmWq2EcaCygIFL9aDgzBBfCo3doXYw0W9Thjw3Fv8rPTC9im858lXgNULy7IgG+x
        OY6Y5xYTjXu0U7Qllt4L6rfFa5stEhCaZ9ZlE5ERM2PEqUlMJW5fuXxFbeKw3v9w
        ==
X-ME-Sender: <xms:7GGVYPauVm23Du0MM0w9_HPXb_8nP_BVmGsnR7seBLLQ1k_ZPIkk6Q>
    <xme:7GGVYOae11Uq31yNiCYdjUSBk5c6bD-de3wVvcZWzlCJ0wHlnPqxQsliuUPPUnPga
    5QYcXc2dCAHZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7GGVYB-k-Syo2a5f8id7YY4ISFippM6oDqeLS_IA_gLJgOBcxfKK6A>
    <xmx:7GGVYFonNuPmziqnMEY80xL29rBd7WZQOmlbzdIWPrkpilWvDECQ9w>
    <xmx:7GGVYKphpfSDxeUIxwxNveAgl45iUIt43oJ-bTwlHUOTrVMJcxBASA>
    <xmx:7GGVYPADxZ1xBYBMo_NxuCSdEhDRbaZIEdALJu-sMBR7B8MfxqTZEA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:51:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] posix-timers: Preserve return value in clock_adjtime32()" failed to apply to 4.19-stable tree
To:     chenjun102@huawei.com, richardcochran@gmail.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 17:50:57 +0200
Message-ID: <162040265791232@kroah.com>
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

