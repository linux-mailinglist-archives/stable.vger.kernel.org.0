Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163D3269FEB
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgIOHgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:36:39 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36309 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgIOHgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:36:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C3B837DB;
        Tue, 15 Sep 2020 03:36:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 03:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZcFydo
        q/c2WoZa8MNFS30LP7G9ZL3a36shsMLe6u/aE=; b=n1MsWzNYQANn6tqulQQbQW
        dHwgIYkAF8Euo/ShKbZkX0oxNMFHs2vdRr0WTKweGrtSJLsiLIot/+pXxRjwxi2x
        m3lWszw6xSXc0kPJcfcxb5vTs9gnp0XpCR3iC810mVx+sn176tqXKl2kgh/wwdOA
        3/OVCySnLaTlrEvzivvj2sLYO8ORUYOv6uRy7xFv5Ub5tni7lPxkXDSmUO0OLvFx
        fTmDV1V1Xsogd8oDRWGwrqWTe5fQZ1Zsz3zzAgUz2Nr8VIzOt8AoAwgL85UMfywQ
        kk7yuA9BemssLN4FIh1pP764aEji4OZ6bH98FO5VZ1SIWNAu8oiq7tAXHXExKm3w
        ==
X-ME-Sender: <xms:BG9gX37iyN6RnQrxi8Tcpz4sXYmBe0b-npbgtz_qCn_mtcykljfAeg>
    <xme:BG9gX86_I6_3EYr0tHwz--d1A12UvX-slEHj9dnyVBRCgCu5jbcuTFuhrFlPFEfWe
    mU_Sn3B07CVqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BG9gX-cW1B3c0UE-jldx3ghIcQwmS29d5huIfpeT9J1z9QlEeeU_kg>
    <xmx:BG9gX4K2uPPNQMHO9Sbb1TMUGz40-RYMEVJ6-lfsJzqgEiOIS1Vhgw>
    <xmx:BG9gX7JFuvFedBrQSN7nkzsGdASdfqUrPOnDbQTvmPQrUY98JlQP-A>
    <xmx:BW9gXxhQS157i_Bx_3S77oL5bCX7sHAQ_3HNDOexXuN6A4zQSBD0GBn-UU0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CD31328005E;
        Tue, 15 Sep 2020 03:36:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: target: iscsi: Fix data digest calculation" failed to apply to 4.4-stable tree
To:     varun@chelsio.com, martin.petersen@oracle.com,
        michael.christie@oralce.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 09:36:34 +0200
Message-ID: <1600155394177226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5528d03183fe5243416c706f64b1faa518b05130 Mon Sep 17 00:00:00 2001
From: Varun Prakash <varun@chelsio.com>
Date: Tue, 25 Aug 2020 18:05:10 +0530
Subject: [PATCH] scsi: target: iscsi: Fix data digest calculation

Current code does not consider 'page_off' in data digest calculation. To
fix this, add a local variable 'first_sg' and set first_sg.offset to
sg->offset + page_off.

Link: https://lore.kernel.org/r/1598358910-3052-1-git-send-email-varun@chelsio.com
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Christie <michael.christie@oralce.com>
Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c9689610e186..2ec778e97b1b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1389,14 +1389,27 @@ static u32 iscsit_do_crypto_hash_sg(
 	sg = cmd->first_data_sg;
 	page_off = cmd->first_data_sg_off;
 
+	if (data_length && page_off) {
+		struct scatterlist first_sg;
+		u32 len = min_t(u32, data_length, sg->length - page_off);
+
+		sg_init_table(&first_sg, 1);
+		sg_set_page(&first_sg, sg_page(sg), len, sg->offset + page_off);
+
+		ahash_request_set_crypt(hash, &first_sg, NULL, len);
+		crypto_ahash_update(hash);
+
+		data_length -= len;
+		sg = sg_next(sg);
+	}
+
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
+		u32 cur_len = min_t(u32, data_length, sg->length);
 
 		ahash_request_set_crypt(hash, sg, NULL, cur_len);
 		crypto_ahash_update(hash);
 
 		data_length -= cur_len;
-		page_off = 0;
 		/* iscsit_map_iovec has already checked for invalid sg pointers */
 		sg = sg_next(sg);
 	}

