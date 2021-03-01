Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2747327BA5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhCAKMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:12:06 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34189 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231821AbhCAKMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:12:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E86201940668;
        Mon,  1 Mar 2021 05:11:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XXZshX
        wuoeFvctpO1c3VxuH29TMAGNG4d8yJfatk8Gs=; b=LRTN1QnLodKDm+5mxVRvp3
        lm2mOcO0yeR4F18mRRUhRMvIdxkeT/H6El9i7QSLpo62FsEmqFEJQG2txDjDZpu3
        Ifb8vMzKy2fyKyR647G2WQHxRGHWH6wYDI+UBcsf4fMqYEBT2tdAX4hU7GBYN4GO
        khagpHbUawoyPAyfHiN57wPXsSNlueFBZ9+V195R2YbRzgLtZRPwiNYDhd+8bXt9
        fYsZ3TjEMNDDdnllQzzAouWlCbBjHuuQHKYFdOgyN7vz7SrElagJFe68cfrrdHwv
        LAoi3CcQLiAjBNWZGv0IoBv6yN46dSbJ6+mMSFudSKmM0zM16dmDwDjomrC2U+EQ
        ==
X-ME-Sender: <xms:xr08YKfVuUxdf1TXWEBKkQd_OJ6c8xk3BDa7fWbAyZ_5WoBHf7D4Mg>
    <xme:xr08YEMe_rALycHxR78FEntSFBWRhHFVVk3dKeqE4vnj347WNBWJ9Gj1yFh-dLyg0
    RCHclmXEMlh5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:xr08YLhsh6Jg11SPQx820Yem2UPemGwia6uPvUMmhDWW3V9VI8ZqHg>
    <xmx:xr08YH8G2u184FHVkcGnMeNfmq2sDnnqYddNNwD9lpKA6CXMkQ_Fww>
    <xmx:xr08YGuiAoOfsrJSxiSLNvX7HpbwbGbdROiHbTFvJBumXKOxpMd9vw>
    <xmx:xr08YKLGRpbPYXYZqAaXDp25ki9Qr_xpVBWzsVy8e_rhioPMvMTWHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79EF3240057;
        Mon,  1 Mar 2021 05:11:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] KEYS: trusted: Fix incorrect handling of tpm_get_random()" failed to apply to 4.19-stable tree
To:     jarkko@kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, key@linux.vnet.ibm.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:11:13 +0100
Message-ID: <161459347322982@kroah.com>
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

From 5df16caada3fba3b21cb09b85cdedf99507f4ec1 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@kernel.org>
Date: Fri, 29 Jan 2021 01:56:19 +0200
Subject: [PATCH] KEYS: trusted: Fix incorrect handling of tpm_get_random()

When tpm_get_random() was introduced, it defined the following API for the
return value:

1. A positive value tells how many bytes of random data was generated.
2. A negative value on error.

However, in the call sites the API was used incorrectly, i.e. as it would
only return negative values and otherwise zero. Returning he positive read
counts to the user space does not make any possible sense.

Fix this by returning -EIO when tpm_get_random() returns a positive value.

Fixes: 41ab999c80f1 ("tpm: Move tpm_get_random api into the TPM device driver")
Cc: stable@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 74d82093cbaa..204826b734ac 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -403,9 +403,12 @@ static int osap(struct tpm_buf *tb, struct osapsess *s,
 	int ret;
 
 	ret = tpm_get_random(chip, ononce, TPM_NONCE_SIZE);
-	if (ret != TPM_NONCE_SIZE)
+	if (ret < 0)
 		return ret;
 
+	if (ret != TPM_NONCE_SIZE)
+		return -EIO;
+
 	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OSAP);
 	tpm_buf_append_u16(tb, type);
 	tpm_buf_append_u32(tb, handle);
@@ -496,8 +499,12 @@ static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		goto out;
 
 	ret = tpm_get_random(chip, td->nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE)
-		goto out;
+		return -EIO;
+
 	ordinal = htonl(TPM_ORD_SEAL);
 	datsize = htonl(datalen);
 	pcrsize = htonl(pcrinfosize);
@@ -601,9 +608,12 @@ static int tpm_unseal(struct tpm_buf *tb,
 
 	ordinal = htonl(TPM_ORD_UNSEAL);
 	ret = tpm_get_random(chip, nonceodd, TPM_NONCE_SIZE);
+	if (ret < 0)
+		return ret;
+
 	if (ret != TPM_NONCE_SIZE) {
 		pr_info("trusted_key: tpm_get_random failed (%d)\n", ret);
-		return ret;
+		return -EIO;
 	}
 	ret = TSS_authhmac(authdata1, keyauth, TPM_NONCE_SIZE,
 			   enonce1, nonceodd, cont, sizeof(uint32_t),
@@ -1013,8 +1023,12 @@ static int trusted_instantiate(struct key *key,
 	case Opt_new:
 		key_len = payload->key_len;
 		ret = tpm_get_random(chip, payload->key, key_len);
+		if (ret < 0)
+			goto out;
+
 		if (ret != key_len) {
 			pr_info("trusted_key: key_create failed (%d)\n", ret);
+			ret = -EIO;
 			goto out;
 		}
 		if (tpm2)

