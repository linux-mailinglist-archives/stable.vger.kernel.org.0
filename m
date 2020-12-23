Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBBD2E1D4C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgLWOPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:33 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56331 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729235AbgLWOPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:15:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 62CCF1B91;
        Wed, 23 Dec 2020 09:14:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:14:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=65x1Ep
        Mo8bm5rnfcSYwvRtjeXhr6FOQuWFgWjemHM/8=; b=HGj7OuXmcz3uFJD+q2lUqA
        4sTnSwhcrUDcYryjxrQFU5g+vkih6fCSguU60TwoL+brw+h2K3NT2T3FwL55sU+f
        x6HB7jsr8wuvtnnvCsTOw02NUfQDTJUCY+o6fT9q1nDEEVbthM74FCT7iWosAGCV
        xbUMSHbuHhbtE5ds0MjHYKX+M3td5i5tOc9/832qxXYkEpxZpC5B0HXoUcnHbMFj
        VSwIPcKJU98GLR9obY8cB1Owp4Wgfr0kZX1aW8yVZgc9U3ngBTkdX1d7ZSld+LEO
        /jl514wjG9HzU5knSJs6Fys9Zno5eU60Iy/2TkZ28BytzNMI124zj5tuG6NYN7hA
        ==
X-ME-Sender: <xms:vFDjX6DOCXcGciPsPgAeKr_5LtcMui9KXJrA7zxoOFEd_xeU6lKSrQ>
    <xme:vFDjX0jWRgIz_xVVw0X1SWi2X7f1KH4knmcP1GlPs2sHOP1_FuTurFSmpSBJdncaL
    KZAK-raVPtE3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:vFDjX9lEbo4r6PD94zvioyDxMBRnmPQV57vXBMSRPO45CWTGbUVzXw>
    <xmx:vFDjX4yyvaHYdglC5ZUosQrni3k29aced9bKFL6WbdFosfenHeQeBQ>
    <xmx:vFDjX_SRgolWvCSCvq2QBwZmkOcv49sGH-2PVXApc2STvt6261wi5g>
    <xmx:vVDjXyOKZGqlBMFW-yyCgIWzdtt_0J_8zySFXIst3NZsLkJA_Olpv7r5ocs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAFC6108005C;
        Wed, 23 Dec 2020 09:14:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] ext4: prevent creating duplicate encrypted filenames" failed to apply to 4.4-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:15:30 +0100
Message-ID: <16087329307125@kroah.com>
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

