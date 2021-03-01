Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B47D327FBB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbhCANjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:39:37 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47949 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235819AbhCANjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:39:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CFE0F19420A2;
        Mon,  1 Mar 2021 08:38:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=e14XkO
        XVSNObujNuMyuPWogd62OKshOfcPdlBp7Vlfs=; b=cNLv+8X29lp7jvLDCywED+
        P7Mm3/eLi19xpoDw6AKqvdfLXuyBxH0OamRFar5K9zgEKaWQKMVCxg+NUozzG7uO
        vvLzgAt2VGxrM0yTxrg+T2qwOx5xtXMP/o2UV0qL6A3icOGKWgaUH6OtnhZ6vSbr
        QwVToD2FFZya+BVpF8cUK8Xjjs6eaW3VtQipWWea4t5ShCLd4Eo/3WlbkGoLK1o8
        RVTl+N7nEo1LgJ4JPvG8oa3PY9theIGXenM6lG1NHOcEKJS0JZ404Kvy6cfqib0Y
        3sIaH2jAo0PXBmyYrJxjzRBFO1XOjD6maJoPJZYpI+48fe4xOGEj80eQUQaD6z8A
        ==
X-ME-Sender: <xms:bu48YOt8HbTCNp2LdGcOivSsXvZqL9CcPZbKNWNctdipwz-EAmGrKQ>
    <xme:bu48YDduY2mxyRSb7JAmq5QpoLRyrirXkJdBW8eTbuI48Vx1L0V0qBOt0-rZ196QN
    RpBQ_fFuaxfng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:bu48YJyvb3j7SIILHt8bQxiJptajqIRd_TXz_pm72DjHwZqpRvVRcA>
    <xmx:bu48YJNZBxD3RKcyo6fiS3o6XcWSYdeEj1atLhqgQSZJcuc7yyP22g>
    <xmx:bu48YO_5Yrev0wglnTuXclkkglspSVGVlJ2kHFt20BUhPbpjTBpKnA>
    <xmx:bu48YDGkUFJjcNp1P_tXV6PBRQd8-lzz0apIC2oK26ZQf0xmNKJ03w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 01F541080057;
        Mon,  1 Mar 2021 08:38:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: flush data when enabling checkpoint back" failed to apply to 5.4-stable tree
To:     jaegeuk@kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:38:51 +0100
Message-ID: <161460593117076@kroah.com>
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

From b0ff4fe746fd028eef920ddc8c7b0361c1ede6ec Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 26 Jan 2021 17:00:42 -0800
Subject: [PATCH] f2fs: flush data when enabling checkpoint back

During checkpoint=disable period, f2fs bypasses all the synchronous IOs such as
sync and fsync. So, when enabling it back, we must flush all of them in order
to keep the data persistent. Otherwise, suddern power-cut right after enabling
checkpoint will cause data loss.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index fc343243799c..429bc00af440 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1892,6 +1892,9 @@ static int f2fs_disable_checkpoint(struct f2fs_sb_info *sbi)
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
+	/* we should flush all the data to keep data consistency */
+	sync_inodes_sb(sbi->sb);
+
 	down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
 

