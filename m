Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE833C3EAB
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhGKSD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:03:58 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:59565 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230504AbhGKSD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:03:57 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 15AA51940231;
        Sun, 11 Jul 2021 14:01:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 14:01:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=H3ztmN
        JeuHcY3YkwUpZ2LOaL/mOpSefgqWmckq7dm7c=; b=HP8qcrIBMTn1YAydgYnkgV
        OuPvXpnRrYq06J0UeJmWVw63SlHBow38BJcf8YqW3yM5nRzDgtmBO0yzHqXfxmLi
        vQigO3kUrXHFGsU74jPHQr2ltlMKmt4vzWZUSdKDlBc5A5w9mgSg8hA0L4fd79jl
        KKEWNUeh2pFIbjFno67Y3/dz1X0dcTpAtdSMligDlcSUxifEApmHOZE06kbOKfvR
        sYOBO509R7jIBakbks75ViSzl0NQo8JVLqtNctW2hgU0tX6vCWsdWf9Z4Qzd3MfM
        xfSMbWcglLVa93uHHrntacU6oV5H+hwtpsTYfVg3MMJKuqho/mnBYll/Nb0nzx6g
        ==
X-ME-Sender: <xms:5THrYG0xvL4HP_jb2Ws_R2uBNn7qPnEsAg_Hqaf_PGFl3JCVVVLA9g>
    <xme:5THrYJEV-6jbDwbBQ75lTJwU5sKsPtVXw6eQcobAv76PTbk6CfKi9-hhqgzyVbG0I
    6j2DaB3JM2dyg>
X-ME-Received: <xmr:5THrYO7MVB-iZZaAR0uNm19G3XP3qxUyYmQqTI8P0oIL0w_uGJm3l_ljnVpqG4nu41zrtD8jK0IkmO1lJ_40fKbvqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:5THrYH2BhBsQ9ZRhqOI0tw8Sjit3hnmUppaxPLfjM5jD99CPLG6VIg>
    <xmx:5THrYJE0QcWz5DUKPtazUmzk4KHRmgtFTgCfTcp-Ttriat-4rWUYlQ>
    <xmx:5THrYA9EkEaVPM-nCENc8YCGCnAffSgBj__Fp9snhrGlGFNapchzCQ>
    <xmx:5jHrYHNf6U3LNk2cO4eM0hTmjTeT4YjzzsKqoMniJYmVRt4UY3ZI7w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:01:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't ignore minor_hash when hash is 0" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:01:02 +0200
Message-ID: <16260264623028@kroah.com>
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

