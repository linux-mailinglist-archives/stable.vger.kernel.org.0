Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D512A4A7C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCP6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:58:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56141 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726312AbgKCP6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:58:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 94955DF2;
        Tue,  3 Nov 2020 10:58:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0QDB7Q
        I6MBmTKRfTtStfssqAom5eZJUd01dTqVk2HwQ=; b=VRLFtG9BuUaqlOU6hOX8I4
        SegLqVyq9wTiAaVUdrKAaM5wTzIP0hhV2en1ChfiqBpNkOsUdax/wz/IzvxreIF2
        XHplDCcdL2CT2eR9rsoRTxcYD4AyvtZZmu7j2NWMCA95ALFTaqwX21/Sgmhx/1sN
        HMcq/tUt8AoWPeavL516g/WsKi7JlyaHFXr82kpZdnUe+rdJRd3w/6JSCV+hSj1k
        vQy+ELIK4LuMABrNDDxdkcGjyaZ71ltl0c4Op7+OQojqce3GHxTYwVMIVm3WUaNE
        1iex8RHtfass8NY2+mPba+CwxFueg1dDXQw1ZBfbCGt9Bx9qnLCxgZlq9LSEHf9Q
        ==
X-ME-Sender: <xms:MX6hX75WitWa4LiBv7kmEg2NX0hTa1ugCbdd4R1-m1fFsCFzqALM4A>
    <xme:MX6hXw6_8ziEC6hg92VMThgTJyXbvQQ0Gzr7umAysM1T5o9KulxZ7jrkMz3GWEq61
    pje_7c_B8msMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgffhfffffedtkedvkeeiteehheetkefffefhtddvhf
    egudefvddtvedvheegheevnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MX6hXydFt3mt1pjtwnvPJICTJgWK4b3LWyXABl1J_0HYceW7CfU7pw>
    <xmx:MX6hX8LnAFL9_tKLvdJd-IPxune6u0eBlRM1k08uuHlJMG1lGYPB_w>
    <xmx:MX6hX_K9ttkDSyZKym5Le74WE4KLzTmDkgbTk2O1_1ZDDkbHL0B7_g>
    <xmx:MX6hX1hpcDqZoXULVIkXUYkTLt-8fZHKS60CVFVgMFcZjCADHIW98QYJvG0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B79473280068;
        Tue,  3 Nov 2020 10:58:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: fix leaking sysfs kobject after failed mount" failed to apply to 4.4-stable tree
To:     ebiggers@google.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:59:24 +0100
Message-ID: <160441916420417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

