Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B772E3586
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgL1Jen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:34:43 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:54583 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1Jem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:34:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C719C769;
        Mon, 28 Dec 2020 04:33:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:33:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Lk3Q2b
        pRAdYvij2p3DikP0f/eJy1w1r1npb85MJl/EA=; b=iwciRNvnQZw7qjis4AA9N8
        BrtxV+GGAQWXcG7m2jArruJNMbVGZ4gTzR80si+1CxL9N2F4EkKxp2bATHsL1Fp+
        z2RSdSZWMM0Hp4jvq3Ohs4AH6ByKZpaPqk5j+JO7m0lt75oa/uB40sV/S6P644tg
        C/n/lQo0bSaYVvQH9j7L6RhdZFBl6r5v476qNTVriHu324jSV1UATOAUjShMl/i3
        w0yTN88X8hm3SHiRQqahIYu0lj3odVkKSwRaXiGd4Qg5ZEBmbEzqLA9bDL1gJafK
        J8nwGIFRcUi2L/pp9E5hCwslKFw8HIF1UUotEz6rGKLRne25ythm7R1F0bGQxndQ
        ==
X-ME-Sender: <xms:cKbpX_LhAtjDM0tMUQok5c176fV6mjC-Vik8ZQJpTKHthGIYmTSd-Q>
    <xme:cKbpXzK8R_-Cvwx-QdGbpWJ6KndvQPBeXQ495l-Ki5CUV8vn0hp6lwbV3UiiWMrRn
    19SMSNqodGFiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:cKbpX3tlGPblnJhSmHJiz32fnQqB4BL57Q6qWW_bnpCteibeMUOuKA>
    <xmx:cKbpX4Yj1y9GFzJLLUlw4MQZHF7T-7vsm3nF_Q8S8JQNHfdPHdp_OQ>
    <xmx:cKbpX2ZIUNj8PIYE40_40PRyw7B5_zbubIThFYFtHAX1FTNDRQLScw>
    <xmx:cKbpX5zZgEELKAL78FUoNPa8hZ9bhWIcHY5uUnQdZ3nJ6PK2h5FdIjHc4WM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 942D21080059;
        Mon, 28 Dec 2020 04:33:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] SMB3.1.1: do not log warning message if server doesn't" failed to apply to 5.4-stable tree
To:     stfrench@microsoft.com, pshilov@microsoft.com,
        sprasad@microsoft.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:34:58 +0100
Message-ID: <1609148098104221@kroah.com>
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

From 7955f105afb6034af344038d663bc98809483cdd Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Wed, 9 Dec 2020 22:19:00 -0600
Subject: [PATCH] SMB3.1.1: do not log warning message if server doesn't
 populate salt

In the negotiate protocol preauth context, the server is not required
to populate the salt (although it is done by most servers) so do
not warn on mount.

We retain the checks (warn) that the preauth context is the minimum
size and that the salt does not exceed DataLength of the SMB response.
Although we use the defaults in the case that the preauth context
response is invalid, these checks may be useful in the future
as servers add support for additional mechanisms.

CC: Stable <stable@vger.kernel.org>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index acb72705062d..fc06c762fbbf 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -427,8 +427,8 @@ build_preauth_ctxt(struct smb2_preauth_neg_context *pneg_ctxt)
 	pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
 	pneg_ctxt->DataLength = cpu_to_le16(38);
 	pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
-	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
-	get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
+	pneg_ctxt->SaltLength = cpu_to_le16(SMB311_LINUX_CLIENT_SALT_SIZE);
+	get_random_bytes(pneg_ctxt->Salt, SMB311_LINUX_CLIENT_SALT_SIZE);
 	pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
 }
 
@@ -566,6 +566,9 @@ static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
 	if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
 		pr_warn_once("server sent bad preauth context\n");
 		return;
+	} else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength)) {
+		pr_warn_once("server sent invalid SaltLength\n");
+		return;
 	}
 	if (le16_to_cpu(ctxt->HashAlgorithmCount) != 1)
 		pr_warn_once("Invalid SMB3 hash algorithm count\n");
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index fa57b03ca98c..204a622b89ed 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -333,12 +333,20 @@ struct smb2_neg_context {
 	/* Followed by array of data */
 } __packed;
 
-#define SMB311_SALT_SIZE			32
+#define SMB311_LINUX_CLIENT_SALT_SIZE			32
 /* Hash Algorithm Types */
 #define SMB2_PREAUTH_INTEGRITY_SHA512	cpu_to_le16(0x0001)
 #define SMB2_PREAUTH_HASH_SIZE 64
 
-#define MIN_PREAUTH_CTXT_DATA_LEN	(SMB311_SALT_SIZE + 6)
+/*
+ * SaltLength that the server send can be zero, so the only three required
+ * fields (all __le16) end up six bytes total, so the minimum context data len
+ * in the response is six bytes which accounts for
+ *
+ *      HashAlgorithmCount, SaltLength, and 1 HashAlgorithm.
+ */
+#define MIN_PREAUTH_CTXT_DATA_LEN 6
+
 struct smb2_preauth_neg_context {
 	__le16	ContextType; /* 1 */
 	__le16	DataLength;
@@ -346,7 +354,7 @@ struct smb2_preauth_neg_context {
 	__le16	HashAlgorithmCount; /* 1 */
 	__le16	SaltLength;
 	__le16	HashAlgorithms; /* HashAlgorithms[0] since only one defined */
-	__u8	Salt[SMB311_SALT_SIZE];
+	__u8	Salt[SMB311_LINUX_CLIENT_SALT_SIZE];
 } __packed;
 
 /* Encryption Algorithms Ciphers */

