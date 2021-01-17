Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2AA2F92CB
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbhAQORk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:17:40 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39581 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728875AbhAQORk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:17:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4FB6E1982198;
        Sun, 17 Jan 2021 09:16:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zpMK5I
        2Edg6yhZ8gPnvYcjCAAX7ZUyJXJ6JezwKOLtI=; b=PenK0lUiKPnpsiAaxXIx6T
        5uS8RoqQRN/F1E5lOaBzrE3KUi3qZsulzL9EL2uRNomNDh4AgAk7tZYjRhVKvBxT
        iDLhaf7qZJLEKyCvejC9bnev4U3XbV7q9dKcIrHk/anGDhxSXMyHtFOD1C1l1NXB
        qcvGx4DOqoPPz1o5x5VPsOythgBC2q8DyrCdODQ5y6f4BmtPfbMLqK68f5ZVjPNS
        4UjSgua+mWMZDOjsnFcvdGxIIsWkFswxS9ceUREX89eElRrlCsCE87q8iu6/VF+l
        QDOxme7idOk1JMhL5R01VEjdEOCY8ZkKMq+UGb96vB6PzTVuX5ti2J5efCZ787IA
        ==
X-ME-Sender: <xms:oUYEYKrRfdgcffO7lTvq1hvYlkxTJIizTLRqXcTDP6RYrn2Kc6mtDw>
    <xme:oUYEYIodnzQKcs3Agl3JkdNgM_rZen6NBrnAjd-EeZBefiAr6uqwVAAUiAb4EB9jx
    QHc09HvaqlWug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:oUYEYPPn4TqWU4uy2oPjK9HWTzFdeWZvi2td0D9VksMkoOwRhiv6Mg>
    <xmx:oUYEYJ6Ae9swpmMMBNE7At2T_efM4fHmev5q_0JaKEgX3426NDAyuw>
    <xmx:oUYEYJ57DztPRIeAI8zCh9xdOjw9yd0H3IBrM7Xwd5knt5daJO0KdQ>
    <xmx:okYEYGjwmoF7oFN7v1y4ja3kd0jOFz9pE6LFTQ5WsVnmn741lPAD8g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A422C108005C;
        Sun, 17 Jan 2021 09:16:01 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: don't leak old mountpoint samples" failed to apply to 5.10-stable tree
To:     tytso@mit.edu, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:16:00 +0100
Message-ID: <161089296095181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5a3b590d4b2db187faa6f06adc9a53d6199fb1f9 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 17 Dec 2020 13:24:15 -0500
Subject: [PATCH] ext4: don't leak old mountpoint samples

When the first file is opened, ext4 samples the mountpoint of the
filesystem in 64 bytes of the super block.  It does so using
strlcpy(), this means that the remaining bytes in the super block
string buffer are untouched.  If the mount point before had a longer
path than the current one, it can be reconstructed.

Consider the case where the fs was mounted to "/media/johnjdeveloper"
and later to "/".  The super block buffer then contains
"/\x00edia/johnjdeveloper".

This case was seen in the wild and caused confusion how the name
of a developer ands up on the super block of a filesystem used
in production...

Fix this by using strncpy() instead of strlcpy().  The superblock
field is defined to be a fixed-size char array, and it is already
marked using __nonstring in fs/ext4/ext4.h.  The consumer of the field
in e2fsprogs already assumes that in the case of a 64+ byte mount
path, that s_last_mounted will not be NUL terminated.

Link: https://lore.kernel.org/r/X9ujIOJG/HqMr88R@mit.edu
Reported-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 1cd3d26e3217..349b27f0dda0 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -810,7 +810,7 @@ static int ext4_sample_last_mounted(struct super_block *sb,
 	if (err)
 		goto out_journal;
 	lock_buffer(sbi->s_sbh);
-	strlcpy(sbi->s_es->s_last_mounted, cp,
+	strncpy(sbi->s_es->s_last_mounted, cp,
 		sizeof(sbi->s_es->s_last_mounted));
 	ext4_superblock_csum_set(sb);
 	unlock_buffer(sbi->s_sbh);

