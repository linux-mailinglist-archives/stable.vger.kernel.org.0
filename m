Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E603C3EAA
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhGKSDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:03:54 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33281 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhGKSDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:03:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 46B8419401D8;
        Sun, 11 Jul 2021 14:01:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 14:01:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j2TWRB
        qxFrlMxtBT/1LRIJZqjFLf0NF34TSAnxhpidE=; b=mNStcxH36EzIsa8q2UoAz6
        WYkQYMDalIIn9n+vfVQUv6Ld47P/qPDM8h3ZmmFw8VPfeYGMz8AEX9dGrGb5HsvU
        6XyG6ok6YEBGzaGEO6XjvJ4F0O8cfU1R4BF8ZOnLKkwqdY2TQH4bAJYbzcGGC0H1
        hVFx2XEW4NXnnP370HQnK8r66EmZnm7hctacPP+XkcObjyiJdFm7yvKZFE3nCuZM
        Wgj2AEPd8RzbaPtQv8ryYK0HQI9feTwbNqfC77nljC6wyBiTn0Rplw9dkLawoQVR
        dDydrE88EjXESO2qgIPG9LkNGj6z0dy0nQRtl/1TQuN5d1F+Iwz0Nj2ZzkuOg3Gg
        ==
X-ME-Sender: <xms:4jHrYDWkaW6Qb5blpBd7GuDPEaM7KhiuPV4rfD4yud6eQ3xoFPzbVA>
    <xme:4jHrYLmkVIv1klTaESCK80XBM6aI3ah_S1QHDFa6AJMP-tnrRnOsRu4jtbtqqQtcf
    vWP_3ohnCDbCw>
X-ME-Received: <xmr:4jHrYPaw9J5pmDC5kE5niJDZOIhYHnYu6yaVSyBbEDZao94H6PiGpnrfr44clQQU0mkMIyLx1O5Q2Fy4Tx_nz1QIRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:4jHrYOXI10DaSoTm3PD7HBkpbp5tttrNKZMpA-kRBfm7dz-Te6_OIA>
    <xmx:4jHrYNkLvn9D89_b0vc4RTjs08jSuMd8GlOvrXOu7EnBp4pGcvz-4Q>
    <xmx:4jHrYLedgr1jBIsgAUEHAP4svZzEwUQxTFgbiS0sX3TiQXwSQqOrUA>
    <xmx:4jHrYNsrB8HCl-93_lJ_8uhCA_pbMJHEhG5PI9RPWs0AfzvcUukVJA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 14:01:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fscrypt: don't ignore minor_hash when hash is 0" failed to apply to 4.14-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 20:01:01 +0200
Message-ID: <162602646116363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

