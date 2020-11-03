Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674992A4A7A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgKCP6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:58:32 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:42335 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCP6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:58:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DC1C0D4E;
        Tue,  3 Nov 2020 10:58:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:58:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BEXS5o
        eOcwxwALl681NEXE2IoKhNOnRasrpwfqzt5T0=; b=N0N4ijGVjOa2IQocfY8r+E
        vDCNVET9tlgydlTH7ocCtiDDNMOGMJcj/i3inFyieeXpz1WetFrUv7VcJ1xSxbku
        +kzTjBut6JbFvJQCiewN4gep6XL7OgN4CMTPpMLCWJuhaCsIexK6rIuR437W7FZu
        JC0t8EyAUgl3ffe4MCHERA0DwuARpxMPloTJrxFAlCm0laxeMsUSDiB1bYqhPdFq
        T4H4dPcIGZ/ZDKJlFRBk+QjGE94YptbbW2XE1Zr1ke8xP3aLa5B2IhNrLdcMCdR3
        a+FMq32+NF06rkdSze9cx2kBWgEdHz78iFtb98X2D+f3I3zXqNGEV4LfB5MSdWWA
        ==
X-ME-Sender: <xms:Jn6hX32uobykX6eLHU372V-86_ac_zWySXnWexjX_EEABqRQLdvPHQ>
    <xme:Jn6hX2G1zRwuOxCwZtvPVuiTq2CX_VOtlCAPSNIx1iJcm6MpD4rcFFA8iF0OZl5p1
    ZmSTQv-LGYZ7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgffhfffffedtkedvkeeiteehheetkefffefhtddvhf
    egudefvddtvedvheegheevnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Jn6hX364V19_a3DBVjC30qwLJTbi2E4_UOnmFiO1bHUkE4by8ORZWg>
    <xmx:Jn6hX80tJgX9gMTGS1C3_I4jHrlM5X53V9hQnAhZqkitfxYLMUuokw>
    <xmx:Jn6hX6Fyp7lZ8mtIYRXhFgG0Jm7uUXaJpJWsC6zXNA0fovOQb2G9gA>
    <xmx:Jn6hX8NFVm3jiTpNQOhFuxmdRbNzXuDOOW6DjuuRQs9AwGsUKh-OMOB-Axg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D89A33064674;
        Tue,  3 Nov 2020 10:58:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix leaking sysfs kobject after failed mount" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:59:23 +0100
Message-ID: <160441916384118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb8d53d2c97369029cc638c9274ac7be0a316c75 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 22 Sep 2020 09:24:56 -0700
Subject: [PATCH] ext4: fix leaking sysfs kobject after failed mount

ext4_unregister_sysfs() only deletes the kobject.  The reference to it
needs to be put separately, like ext4_put_super() does.

This addresses the syzbot report
"memory leak in kobject_set_name_vargs (3)"
(https://syzkaller.appspot.com/bug?extid=9f864abad79fae7c17e1).

Reported-by: syzbot+9f864abad79fae7c17e1@syzkaller.appspotmail.com
Fixes: 72ba74508b28 ("ext4: release sysfs kobject when failing to enable quotas on mount")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20200922162456.93657-1-ebiggers@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea425b49b345..41953b86ffe3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4872,6 +4872,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 failed_mount8:
 	ext4_unregister_sysfs(sb);
+	kobject_put(&sbi->s_kobj);
 failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:

