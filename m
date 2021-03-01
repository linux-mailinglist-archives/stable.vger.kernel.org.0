Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A4C327BA4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhCAKMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:12:03 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53445 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231821AbhCAKMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:12:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 730901940746;
        Mon,  1 Mar 2021 05:11:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:11:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D2YLkG
        rSqC+W6oEcVpWnj3PpdaU1nU3YE9r7vK1TR7A=; b=f66lHvai4MhcPBxewfrjPc
        wa0q2siked45/jf7Ibx+xCoSZbAj2YklmmOsCPGXygogdrOiJRDzfTaXNEAdzfDN
        DsqSAX8YzaX4qbxxpzOEFwRxhEA810dpp+JE4QuTcRBgtdehXlhsc+29iwBvuLZo
        seRZbIACtdo37JAghtu5kvqX5ZIfw4l/fGT1Q8rttAxCEkod5BNiQax7epI1I8/O
        kko6afO4oEchN/zq15ixe4ifC4LGfL6WVdf+22YGuQIWappFD3WxzI9Xagk6gFDv
        YBoMYNXdlNai8UdgkjjoQ8qEnCil2e2bZOWAh4/tMtNluG1G6S9j/AKrslJCxjbw
        ==
X-ME-Sender: <xms:wr08YIDzgCVfYgkAEEWvM-QPf2BocarO-gXSYw_b6gT2JFVU3Dud2g>
    <xme:wr08YKjJopSU2bJVtA6AcPiTrvqj64pE-ulGgNENUlCwdduSKsti3NdunZ3Shszgi
    MShxkCTXENtHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:wr08YLkkvRgCnof2kDB-dHmElY57dCLx-nnle95iY14rG4CtLtIskg>
    <xmx:wr08YOxE9gRR9znpKvGxGx6OrjtwmTO3OUYCeNq5p_ooZohSRjkGyA>
    <xmx:wr08YNQkm8zvlBHTUh5r2dZb3s7GdOReOwWnJZ7anRAr_HK1Dfjmrg>
    <xmx:w708YPekJYoZUYRltk0Pxj9Cs8jJA89ixIBCyGC8LktD2pDM2A4kEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B88724005C;
        Mon,  1 Mar 2021 05:11:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] KEYS: trusted: Fix incorrect handling of tpm_get_random()" failed to apply to 4.9-stable tree
To:     jarkko@kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, key@linux.vnet.ibm.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:11:11 +0100
Message-ID: <1614593471248155@kroah.com>
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

