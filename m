Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155D73C3EA9
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhGKSDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:03:52 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43215 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:03:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7FCD019401A8;
        Sun, 11 Jul 2021 14:01:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 14:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sB48LF
        Ej6AKQ1UKfDiYwpsuuMN+swX8VpNLSCo9bX94=; b=WP5mWVQ3+1LpDCEkh7RJAD
        1YQvvt/rFqY1pN1AiodTm8ZVnVwn31cAXAolWUElZHpQXwGC84tGmqvLJ4SIqdvT
        HbdH5BBSPGdVzHhQ1RXjdLGU+2hdLkxJm4zcCJwzZNfzGaxHYE3+4AWqH+CVd8E3
        hYQjQUYzrv+9i7w9fJrWqKTvS5Ag+d06W7USMamlpS/NubgbEAPIIF11D7GWEM9Q
        CoLVv4Jqb8jb7OTaCryAWQ9/6hLg/6GvGNwaKFHtNyc7wHpgd5A4CK6QtsruAAjO
        4rhStA4IojXCv8KX4pmQtxES4G+XON8rOLytNaP4KJvoRFKVDz/nmSwiLrac5VHQ
        ==
X-ME-Sender: <xms:4DHrYBUyuiM5-5_0WYPGe7fmHcg_OctqB6WR0U2db72aFn2ySdR5ow>
    <xme:4DHrYBlNmChaOz2WHBimMySqSDeovmhEBmCYPKBHNDnYNYAxLicb37Q17RB5Z45Te
    FcljlHLzgNAWQ>
X-ME-Received: <xmr:4DHrYNahidb-yqvo4Kyce2wVoK_4ThBDQYOn6VFOwfWBMDKHXe4bAV8kp_u89bGQE_iuj3NDMdGiaFlNm7w43irlKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:4DHrYEWYKwrrwU-wKgKrrowb0oRX33FD75kUWxTFJPG3d1c7ru4a2A>
    <xmx:4DHrYLmXPfHmjIdl-U4Ohj4sSP0hAz3YJn2hq-nmiWlL-cAgp2_bCA>
    <xmx:4DHrYBds_NrXWeyOu6l-jIGPOE8_-dQzrUc4pvM3D4nLdZ8K1JYOzw>
    <xmx:4DHrYDuHgVsbGDx2E2D-XZzZE7Uuu-2gBrhQcczdnbUs7aeCQOdu5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:01:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't ignore minor_hash when hash is 0" failed to apply to 4.19-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:01:00 +0200
Message-ID: <1626026460236226@kroah.com>
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

From 77f30bfcfcf484da7208affd6a9e63406420bf91 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 27 May 2021 16:52:36 -0700
Subject: [PATCH] fscrypt: don't ignore minor_hash when hash is 0

When initializing a no-key name, fscrypt_fname_disk_to_usr() sets the
minor_hash to 0 if the (major) hash is 0.

This doesn't make sense because 0 is a valid hash code, so we shouldn't
ignore the filesystem-provided minor_hash in that case.  Fix this by
removing the special case for 'hash == 0'.

This is an old bug that appears to have originated when the encryption
code in ext4 and f2fs was moved into fs/crypto/.  The original ext4 and
f2fs code passed the hash by pointer instead of by value.  So
'if (hash)' actually made sense then, as it was checking whether a
pointer was NULL.  But now the hashes are passed by value, and
filesystems just pass 0 for any hashes they don't have.  There is no
need to handle this any differently from the hashes actually being 0.

It is difficult to reproduce this bug, as it only made a difference in
the case where a filename's 32-bit major hash happened to be 0.
However, it probably had the largest chance of causing problems on
ubifs, since ubifs uses minor_hash to do lookups of no-key names, in
addition to using it as a readdir cookie.  ext4 only uses minor_hash as
a readdir cookie, and f2fs doesn't use minor_hash at all.

Fixes: 0b81d0779072 ("fs crypto: move per-file encryption from f2fs tree to fs/crypto")
Cc: <stable@vger.kernel.org> # v4.6+
Link: https://lore.kernel.org/r/20210527235236.2376556-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6ca7d16593ff..d00455440d08 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -344,13 +344,9 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 		     offsetof(struct fscrypt_nokey_name, sha256));
 	BUILD_BUG_ON(BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX) > NAME_MAX);
 
-	if (hash) {
-		nokey_name.dirhash[0] = hash;
-		nokey_name.dirhash[1] = minor_hash;
-	} else {
-		nokey_name.dirhash[0] = 0;
-		nokey_name.dirhash[1] = 0;
-	}
+	nokey_name.dirhash[0] = hash;
+	nokey_name.dirhash[1] = minor_hash;
+
 	if (iname->len <= sizeof(nokey_name.bytes)) {
 		memcpy(nokey_name.bytes, iname->name, iname->len);
 		size = offsetof(struct fscrypt_nokey_name, bytes[iname->len]);

