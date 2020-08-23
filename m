Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13724ED29
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHWMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:25:07 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57263 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbgHWMZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:25:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1B19F1940DB8;
        Sun, 23 Aug 2020 08:25:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NicfgW
        kn2smECR3CNAy+dXw9mXVqeS7lgCqDPij6h08=; b=lWY9hjDBfH7X2ftpmfnqu0
        5VSeswc9QZbxBBK7XqEk1si99fqpHYLkiZa9XHwwDoKpa2PzVdaNOQ5mQJxzMN6c
        HHPAORzQqbOsNXDjUliwsLZSWXbm/NUMwKwB0OynJ+5omzFjKwiMEwcIWWoCEbYL
        /fXKPdZsFhd2dfNe1tJ79//QLwa0qyIBTZLo24l7aX3KsJ571D77vv1Goomla3nN
        zhyiXJuPt7qWeXNkTTNLyNL49i+MXJaQ85GEpVrW3YGCpOMsZmr251Xi/X8w9cI8
        L+DoAMX6U3LnTo7E8DMUjq015JNPt1cDXVmSRcJfgoBQ5mGSNYAkGyuUtK4k+A4g
        ==
X-ME-Sender: <xms:H2BCX3XkGK8wcSFJxO9K27jfLXHWecxHp_r1ENknu1DGePbpOGKhJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:H2BCX_l_rESW4cq6ye0VImIssvmE_GIp4ZChU122bhHGAxe6vuGSMQ>
    <xmx:H2BCXzaLWBcvsvlYxXW6lgqmV6FPqehjx4w5oOCgYYO_BH4QzOO7Lw>
    <xmx:H2BCXyU2cewRNM6kv9sxvD-vNlIbUmfEoh-3YgyuPjxW6GYQZH1_kA>
    <xmx:IGBCXwuZ-9HmB8Ng-Ik6MitYaA_jq8Zgv0wpLzAYfKeKAvftG2HaYw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4983E328005A;
        Sun, 23 Aug 2020 08:25:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] jbd2: add the missing unlock_buffer() in the error path of" failed to apply to 4.4-stable tree
To:     yi.zhang@huawei.com, riteshh@linux.ibm.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:25:24 +0200
Message-ID: <15981855242552@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From ef3f5830b859604eda8723c26d90ab23edc027a4 Mon Sep 17 00:00:00 2001
From: "zhangyi (F)" <yi.zhang@huawei.com>
Date: Sat, 20 Jun 2020 14:19:48 +0800
Subject: [PATCH] jbd2: add the missing unlock_buffer() in the error path of
 jbd2_write_superblock()

jbd2_write_superblock() is under the buffer lock of journal superblock
before ending that superblock write, so add a missing unlock_buffer() in
in the error path before submitting buffer.

Fixes: 742b06b5628f ("jbd2: check superblock mapped prior to committing")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20200620061948.2049579-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e4944436e733..5493a0da23dd 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1367,8 +1367,10 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	int ret;
 
 	/* Buffer got discarded which means block device got invalidated */
-	if (!buffer_mapped(bh))
+	if (!buffer_mapped(bh)) {
+		unlock_buffer(bh);
 		return -EIO;
+	}
 
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))

