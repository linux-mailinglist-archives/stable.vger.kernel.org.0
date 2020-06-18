Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2801FF942
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgFRQbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 12:31:06 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:49789 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727880AbgFRQbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 12:31:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 268AE9F1;
        Thu, 18 Jun 2020 12:31:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 12:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4WiI+P
        FP8tdXY2q8DGmROoxD+Dmvf5KYAFUuVYASsUw=; b=loru+4tJwSRIWW/7D4KaqT
        tZfBJygR+WtubKxNenz82hVM3ZhktACRSLF+9dlXSK3t5onMDJ8cgQJcoyva4Gh4
        DYE66VNP3YncfcbuDKEgWmPI82rnqRlyd+VtKDU9YgL9edsx4UHD5/0I/cAtWsmA
        zn/dSUyJkhARqsL7KI8G4FgHLrvWftAuJt9zb1j2Wx2w03ubzvcZAm5P4JdM9XH8
        S70ssWatci/x+QIioLS7xR2fYl4CzpJf76EREatraRydy/kBBbsgktca0McLQKkS
        v6Ikbk18IMW9AQyYg2/+S786UEM22Oo7//DrQz2gvsysaWLi6RcwXtO+PKCyyHhw
        ==
X-ME-Sender: <xms:xpbrXtwNQY0AMVs5nmtkq2XsI2AcR-zLAFkCbSlh2sDBNC0LKzRKgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhs
    thgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:xpbrXtSq7G0-uWajdEu_8ahOErkhkAdMRGIMm-znMT8yGjcW-hCE2g>
    <xmx:xpbrXnWMD7qmDs-h71DEyOoEITUqZ07AH_Nkjru-UhqmCpLXNHVdEg>
    <xmx:xpbrXvhXj2fg9REXYWFibfxwCzx3AAGLnyBoq2Wbi3RmpuScYVYeyw>
    <xmx:xpbrXirjc8TwIkc3vmWiVsPEbsWlwSFXQrVu-5IlC_fAJyjjQulGSMAdkSo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6557F3061CCB;
        Thu, 18 Jun 2020 12:31:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()" failed to apply to 4.14-stable tree
To:     roberto.sassu@huawei.com, tiwai@suse.de, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 18:30:45 +0200
Message-ID: <15924978453121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6cc7c266e5b47d3cd2b5bb7fd3aac4e6bb2dd1d2 Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Wed, 3 Jun 2020 17:08:21 +0200
Subject: [PATCH] ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()

If the template field 'd' is chosen and the digest to be added to the
measurement entry was not calculated with SHA1 or MD5, it is
recalculated with SHA1, by using the passed file descriptor. However, this
cannot be done for boot_aggregate, because there is no file descriptor.

This patch adds a call to ima_calc_boot_aggregate() in
ima_eventdigest_init(), so that the digest can be recalculated also for the
boot_aggregate entry.

Cc: stable@vger.kernel.org # 3.13.x
Fixes: 3ce1217d6cd5d ("ima: define template fields library and new helpers")
Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 02796473238b..df93ac258e01 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -57,6 +57,7 @@ extern int ima_hash_algo_idx __ro_after_init;
 extern int ima_extra_slots __ro_after_init;
 extern int ima_appraise;
 extern struct tpm_chip *ima_tpm_chip;
+extern const char boot_aggregate_name[];
 
 /* IMA event related data */
 struct ima_event_data {
@@ -144,7 +145,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
 			 struct ima_digest_data *hash);
 int ima_calc_field_array_hash(struct ima_field_data *field_data,
 			      struct ima_template_entry *entry);
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
+int ima_calc_boot_aggregate(struct ima_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       struct integrity_iint_cache *iint,
 		       const char *op, const char *cause);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 5201f5ec2ce4..002fdf6994d5 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -806,8 +806,8 @@ static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
  * hash algorithm for reading the TPM PCRs as for calculating the boot
  * aggregate digest as stored in the measurement list.
  */
-static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
-					      struct crypto_shash *tfm)
+static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
+				       struct crypto_shash *tfm)
 {
 	struct tpm_digest d = { .alg_id = alg_id, .digest = {0} };
 	int rc;
@@ -835,7 +835,7 @@ static int __init ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 	return rc;
 }
 
-int __init ima_calc_boot_aggregate(struct ima_digest_data *hash)
+int ima_calc_boot_aggregate(struct ima_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	u16 crypto_id, alg_id;
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index fc1e1002b48d..4902fe7bd570 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -19,7 +19,7 @@
 #include "ima.h"
 
 /* name for boot aggregate entry */
-static const char boot_aggregate_name[] = "boot_aggregate";
+const char boot_aggregate_name[] = "boot_aggregate";
 struct tpm_chip *ima_tpm_chip;
 
 /* Add the boot aggregate to the IMA measurement list and extend
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 9cd1e50f3ccc..635c6ac05050 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -286,6 +286,24 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 		goto out;
 	}
 
+	if ((const char *)event_data->filename == boot_aggregate_name) {
+		if (ima_tpm_chip) {
+			hash.hdr.algo = HASH_ALGO_SHA1;
+			result = ima_calc_boot_aggregate(&hash.hdr);
+
+			/* algo can change depending on available PCR banks */
+			if (!result && hash.hdr.algo != HASH_ALGO_SHA1)
+				result = -EINVAL;
+
+			if (result < 0)
+				memset(&hash, 0, sizeof(hash));
+		}
+
+		cur_digest = hash.hdr.digest;
+		cur_digestsize = hash_digest_size[HASH_ALGO_SHA1];
+		goto out;
+	}
+
 	if (!event_data->file)	/* missing info to re-calculate the digest */
 		return -EINVAL;
 

