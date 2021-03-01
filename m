Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABAF327BA7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhCAKMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:12:12 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39493 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231821AbhCAKMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:12:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 201821940781;
        Mon,  1 Mar 2021 05:11:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iN7m92
        Y5ayK9+sq2ndDhOoqyNHYrdbv1xQ6TGrzKDSw=; b=Q0Hz8o9+K0vulHrDJrw8Bf
        a9UWmeTDVxzTb5pUdRZB6LZR9+cAiX4EXvrW6c72zSQqasfDNER4LjNeTCQ+AWd8
        BG0MOv9ZiTiDcV18vxr7ZNuhPsfIVOp/GyFWoyvRGXwaOHv4OelLuXcupl8H744L
        yZbsgeBdGFRSrfJP6L20+mHFuht0H2AIzkCvSlM//Ubtn2FEU2hd2Ff/EYg2u7BY
        W3iyPQU80QHmHiazqe0qjRIjj1XcdRFLqgleeI3ZfypUMcq1ItU+w/FWlzzYrXee
        IpcufqDN9FPghhs/QkFX/cXGY+nQTm/Q+cvCFFGicUrLYPrqcFF3J+ctdwSOYX8g
        ==
X-ME-Sender: <xms:yb08YNw4oGtf9gFW-Wyt-5jPYHr8vm-arWisMdDUR8lIScMgxQEJJA>
    <xme:yb08YNT5E0EgAL-iGosXNdLxwbE5uDxBgQO6Yod86YH-G9JhffWiqOO4tKuCwRV0V
    Tcs-waL0BIN4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:yb08YHUvxsaK6gQfTuzMISsZi5iFc-okOAErua-OD8hEqV_dyai-hQ>
    <xmx:yb08YPi-xCtjZv8r_wbloxKfHFVFUGgEcwoHoS4ngdlGLVqtdGZXKA>
    <xmx:yb08YPDjO7_8K03M1XY6aAW9KTrWW26SW6VIDlp7lZcidU4TuucpLA>
    <xmx:yr08YGOdk6xL-i9DiqS4_qn8ZIR3Nsr8f-w213HtHI5g85W2mRD-eA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFD3524005C;
        Mon,  1 Mar 2021 05:11:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] KEYS: trusted: Fix incorrect handling of tpm_get_random()" failed to apply to 5.4-stable tree
To:     jarkko@kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, key@linux.vnet.ibm.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:11:13 +0100
Message-ID: <161459347365237@kroah.com>
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

