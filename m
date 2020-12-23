Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFFF2E1D53
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgLWOPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:53 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36831 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728890AbgLWOPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0EBF895D;
        Wed, 23 Dec 2020 09:14:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZIpyoX
        x0TBsGKN/nUiQxxPSOhrUXU8k+kO3nIfRfh4Y=; b=ciHdcMmSmH/VNhDC7sr+dx
        GcpGLKh2hlSpUdF9TMGRNIC3/wld63qgmAHbL/uT/y64/j5rQ1NRjE0miDseF+6i
        PZuW5YqWBIpn4iVhynPGwy2+k7jLVMlCvs3u2L822tDXpxxTbvlJXcqiClO1ak4h
        xN0ERAbQmWtqkk9o/cBbsZfCLy4Ds3ynhzwVeQ6ZIBZOss1HJl24mk1WW9LCEPpG
        hbjl6Ow36DrTJSupW4480lSRTCP83lJW7jIyk1PSZXfc4tDppkReD8Kf25B+1y8V
        hhNBAKAX/j5c8gtIP9rNETx+hLh+4E4zheTO6DK4x9mxS2FT610UTKyRigiPfYPA
        ==
X-ME-Sender: <xms:u1DjX9mtIfaInu4oF21tWDlEFYvbPZAEeMoHkBKMU8ci-YzrGgAJeQ>
    <xme:u1DjX40XisifcJ2zo58Op345-SJW2uDMF7trAn1JT2QqBFeEzmUX8DjqrnFLuMNEN
    Q_xMFLVg845Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:u1DjXzoNUWc40Y1EkQ7rrtulYS5hKYUnq5f1uqv76K3OagK_-vOIqQ>
    <xmx:u1DjX9kpwJH9hXmI0VgqTt4lYyzZhQr9MT9qBhsUg_N08L2zWYPzkQ>
    <xmx:u1DjX72LurKT2tbU9d-LLhodiyk6u2xbES-yY76W0_mltNWkXEjEZw>
    <xmx:u1DjXwjPkgibOw5wZOkvqiij7KvGbxvOugMRpKz4X7jBHGWuGtfZ8lLUECI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5945E24005D;
        Wed, 23 Dec 2020 09:14:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: prevent creating duplicate encrypted filenames" failed to apply to 4.9-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:30 +0100
Message-ID: <160873293042227@kroah.com>
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

From 75d18cd1868c2aee43553723872c35d7908f240f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:06 -0800
Subject: [PATCH] ext4: prevent creating duplicate encrypted filenames

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on ext4 by rejecting no-key dentries in ext4_add_entry().

Note that the duplicate check in ext4_find_dest_de() sometimes prevented
this bug.  However in many cases it didn't, since ext4_find_dest_de()
doesn't examine every dentry.

Fixes: 4461471107b7 ("ext4 crypto: enable filename encryption")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 33509266f5a0..793fc7db9d28 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2195,6 +2195,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 	if (!dentry->d_name.len)
 		return -EINVAL;
 
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
+
 #ifdef CONFIG_UNICODE
 	if (sb_has_strict_encoding(sb) && IS_CASEFOLDED(dir) &&
 	    sb->s_encoding && utf8_validate(sb->s_encoding, &dentry->d_name))

