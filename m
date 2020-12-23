Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4ED2E1CF2
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgLWOIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:08:35 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:58681 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728456AbgLWOIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:08:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CC9483B3;
        Wed, 23 Dec 2020 09:07:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o2eNum
        m81TIOVFebvy35/vyxw7TPmfAnuq+P/DF4k9o=; b=BNySGiGyC9D1KNVF9qogwo
        awtSpPAEq1avjeOtOowDVFgNekq3/alGwa1V23rTK25rAPr42FRolHR8IOfSrSsQ
        zyZ/AlGvuWYPnwiZAaP2Y7VkLhEbfiHj6Lv6TttbjS/iotkk6ra4IuEGEPIOH54B
        o0wvPZPj9Hidfrj3JJvOQmpbnyQdV2aQHC/EmeEPAaiqfwI00exfwe+emQ3dOGTr
        UWtI0cKKeojhttR79b2QDqLE2nPEZYsjmyCk/jMipIBKK3pgzLmfJnALmcZioexF
        NEj/OCZivQmfSGRnkF+sTgsY/RAX7Y0NVbGj575IgUjAZWeVkj99lf7zDWOidRFA
        ==
X-ME-Sender: <xms:NE_jX4Qc_zzmolZDvSA30lWYJQ15ww8Oe7GiELVIXxV2UeXIsJBDDw>
    <xme:NE_jX1zY4zXgWVoF9BCyFMSLKxBLrXHfj6NBYP2Y0Q8hsSlrkDiwuKbyt15ryNZUB
    epxy-YKiT53JQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NE_jX10fltqhtVK6TpZIXBMncj8d02bhHh9xEjfS8_lK58Nklngmmw>
    <xmx:NE_jX8BUuMYqxoXxvdvFwZGjU_cpj37KLzqbwGpe4ZEX_b17aIESwA>
    <xmx:NE_jXxha5BVUpL7Ag6fbK9skkQM1Ow4CFbV-PHaoSmzmijIIi4RX7Q>
    <xmx:NE_jX7c60E6_nLDXewazmgGsZV_0P62w5ozgH51Eiok7QdzK-ezNDHECQVU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6703240057;
        Wed, 23 Dec 2020 09:07:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: prevent creating duplicate encrypted filenames" failed to apply to 4.9-stable tree
To:     ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:08:51 +0100
Message-ID: <1608732531208141@kroah.com>
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

From bfc2b7e8518999003a61f91c1deb5e88ed77b07d Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 17 Nov 2020 23:56:07 -0800
Subject: [PATCH] f2fs: prevent creating duplicate encrypted filenames

As described in "fscrypt: add fscrypt_is_nokey_name()", it's possible to
create a duplicate filename in an encrypted directory by creating a file
concurrently with adding the directory's encryption key.

Fix this bug on f2fs by rejecting no-key dentries in f2fs_add_link().

Note that the weird check for the current task in f2fs_do_add_link()
seems to make this bug difficult to reproduce on f2fs.

Fixes: 9ea97163c6da ("f2fs crypto: add filename encryption for f2fs_add_link")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201118075609.120337-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cb700d797296..9a321c52face 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3251,6 +3251,8 @@ bool f2fs_empty_dir(struct inode *dir);
 
 static inline int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 {
+	if (fscrypt_is_nokey_name(dentry))
+		return -ENOKEY;
 	return f2fs_do_add_link(d_inode(dentry->d_parent), &dentry->d_name,
 				inode, inode->i_ino, inode->i_mode);
 }

