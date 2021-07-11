Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049873C3EA8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhGKSDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:03:48 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51943 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:03:48 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 579D21940160;
        Sun, 11 Jul 2021 14:01:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 11 Jul 2021 14:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QtxFDT
        1AwbKlbmK1EV/D8aDkJHSKDTCcCQXehx++ze4=; b=vp8O/DPbjJeX8yCuqUFR/8
        eduChaPwtiokV8Hyy+7F+jV5nIPMji7Q8RZb8sHxFNyb75S7UzNL1eStGTgfu25+
        RdaJCfXE7y3k3XkJnoa+RRtwExev7n0WMfzOdJBKWWMj5YHUrp0gcqYF0A6A8003
        vUBYJFT/4kI0+MOigjY8Nn7kzGW5FWpO32DK8K7UhGNRAXT9jefg3sGZfcEGeyZX
        1kRgy4Eoh8Z4HBZzCfT5aiORogbVvrmpsVlcOKk5O6HTTntArOe0xS625AKz9pzU
        EtvBN6Y89SYpY+rCKoRLRRODULftOD1hacdjsrKP2Fw7tV37GH6pl+0w1DNwx5kQ
        ==
X-ME-Sender: <xms:3DHrYF_bLzatGuRmj7BRo1rHwZP7BLmns2EPckQQ4-I_WPGFkRAsUA>
    <xme:3DHrYJvdAfcwpyJbSPCkzr-OBFQsrgA6tRbwn16WyN6HZmn7M5N6WWFc2sq1T-IF3
    LVzJ-lVfjXjpg>
X-ME-Received: <xmr:3DHrYDD1KIVpSysw1shinPzjIlb4S7GKQV4GOFXbF7CbtJjXo8AvRkUZ_mOVkUg2ItSoDLOYHe203_uAMnuTzq_EDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:3THrYJfx3Gushq6hBjDcjfIChrsUhlN3H4VvvosW9GI6JcXZQHLoHA>
    <xmx:3THrYKNLmFP8LHs0fYDfQddTRtnpt5TrqoRKSy1BpEUZNQKNIBWBDw>
    <xmx:3THrYLlC9wAikvSHDXp_vxe8XEjUAyrjXyUEy1GZl_CLMJVoK0s4aw>
    <xmx:3THrYM34sfDeP0bWDSRMiaDRKy9CbbneLk4CXZ15RAfQuB6deFgvhg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:01:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't ignore minor_hash when hash is 0" failed to apply to 5.4-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:00:59 +0200
Message-ID: <162602645949183@kroah.com>
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

