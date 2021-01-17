Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7A2F92CC
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbhAQORl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:17:41 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:42559 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728918AbhAQORk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:17:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 60FDE198230A;
        Sun, 17 Jan 2021 09:16:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TlGth9
        Xmm0Jmtu4aEZKMtAsboR+L+U56dd4gNIT2o9k=; b=Ey9vuaRULrvd2+Cu6kBqhZ
        f0P+A4vQHu8uph22pQ83h3VWbiOiWdEmddfeXw/eiyFt857M2rUywvfYhZPcNPAY
        QaT3POH0iKQRiZj7u8lF8IoB8XgR5S8eMrINM5ceo9Iqg8Tx2i4w0+HfWdkESf6w
        xc4SYgZHRgOA234+TDdXvVQbe9lxz39ZMbDeal8Y0+VX94I2CIJnNhyCC1OLh0xA
        1COXIawtvhD5hh4lbKl9lgvdecWArW+xwcBz8m3NVefyWWPLuquiSjsMaz6YBeSk
        4QODfwkchA5irqmzFKbnsVI+8UsrSj4t7EGcQdELmdfmice8vFPNj8br9dmZzQ3w
        ==
X-ME-Sender: <xms:pUYEYLiJuzgvexFxZjSZZF1-6H-o7Ud3Lk1ppbPFiQweQlAdmY4a7g>
    <xme:pUYEYIAPK3NsB8nBs_RgCdUcGK-iK9IAs_vg7iSv3g6cFpuymB84TxiXy_X0uzWB_
    a8vyRk48DUkAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pUYEYLHxovrCsS1u9DLB1bHLPnWO9B78vi9N5XNXm5EZ0-KpxrKNSA>
    <xmx:pUYEYIRala6bziV0lyIVd539zn2vXvsNIjh4QOtpBqT4kMoWt3NLtg>
    <xmx:pUYEYIzm3aqMLzU92u5__atZNS21W6eTgiAzZU-PZUhaeb2Vsw9ydA>
    <xmx:pUYEYOYzAIm3VuXQmdCsFQzQ3tFcaTIbE2bLoBcHYLYyOTjbGvuA4Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23E5224005B;
        Sun, 17 Jan 2021 09:16:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: don't leak old mountpoint samples" failed to apply to 5.4-stable tree
To:     tytso@mit.edu, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:16:01 +0100
Message-ID: <161089296114675@kroah.com>
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

