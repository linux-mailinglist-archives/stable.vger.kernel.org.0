Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129CD56BF77
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiGHQjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238087AbiGHQjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:39:21 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12B24964;
        Fri,  8 Jul 2022 09:39:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5D1173200993;
        Fri,  8 Jul 2022 12:39:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 08 Jul 2022 12:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1657298358; x=1657384758; bh=YHeW7qifHVJ0i9ystBYmFItIOJUEYVweocj
        CTyeUqgE=; b=jozxi6B7GVXnmh3t8QDbYoD0le9OiP6un3wxgt4UxfGn6p4Ox6G
        3Mt9davcEK5cq4PpMoo7jkdEexw6g4/okj2ltO/VMAK/z/CrhrgEYmiy5IFO0uMp
        3lWrqlgMjepPOJB+UGXbDCH7fLHWsNis93BMNE3mtst/BcR4VPxERE3QQhhDPu0y
        WxA9NyTF7kUyow/dgs+JOObprVZAncPSjiH43W98FHXLfs++FVdcNGzbXOo1JiM/
        OH3Obm1JMQSOk6X6SPg3GIm6qq2mX+j5ZGe0dJb6gBoj2Ri7NxwIlxAuIXhBimxv
        BiBUsjcOx2rcriKSpZEHamPe3pvKwEuBeMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657298358; x=1657384758; bh=YHeW7qifHVJ0i
        9ystBYmFItIOJUEYVweocjCTyeUqgE=; b=t33tFCk2Kzkm8oAuKC+Qik1G4G6qh
        u60fY7a133jXVHsUkPzf+0CHG36quOgdZd7wQCQXqW65EJDh122LyPggu4UxJ3Hu
        U06nNVUmU7+YDJMkYVHQUlp6v/kvxR7CJNibtS5bzhmJRvks7pq4TC4HauNlhYT1
        Y9pe2FKHTpnUJizyoS49hxHq/+XDY0whzFn+sAhHPb9NGsZ+CnA0Eo7DCy3g72Uf
        rHKfqNY4nnmYNVsACKGN+yzyamrUQk91bApUdFw5jYXORWEtaVqNQQtQ1+RdtxW8
        1NF9bWXc2ujrnyX5NaaJ5wC3ElfMkK9GNwbuxbPuPO7aarr6WmhB7IoZg==
X-ME-Sender: <xms:tl3IYgCOKbxledbg6WLTijHDgxeJckES73cvQJtH6iu5MhLeN5MHew>
    <xme:tl3IYiiSO6PflvmXD-vJKrbqkBMcgBVNSbW1BN03CjyMq0l79oH7h_ZziDfAd8tSG
    IwRLerrSF4R8nU>
X-ME-Received: <xmr:tl3IYjmD7WkH-QiB2lIlw3lUBP1vkRpng2MGXQJumXF9kE5NWdjGwzmjHcpCg9_Tug7-iavFYa96>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:tl3IYmyBdSnmq1wF-bQNg__Ho-1-_4KDEYriyr50ihZRJmN8rWPrPg>
    <xmx:tl3IYlTnIm0xiQRQHZELEd_kSHIvj7Ob1jE4lEXAWi5RkvMBWi4LwQ>
    <xmx:tl3IYhaTCG5tmRZpot-6XnffDpK__cQTrgjDaJG7DQ0Ugi3NtXvBYw>
    <xmx:tl3IYkFzFh2d5oSKKoTg72TzLGDtav6hTQi9BHXZBtSKW3sCk_bBVQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:39:18 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     Linux kernel regressions <regressions@lists.linux.dev>,
        stable@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Xen developer discussion <xen-devel@lists.xenproject.org>
Subject: [PATCH 5.15] Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Fri,  8 Jul 2022 12:37:49 -0400
Message-Id: <20220708163750.2005-6-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708163750.2005-1-demi@invisiblethingslab.com>
References: <20220708163750.2005-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not INVALID_GRANT_HANDLE.  The handle field of any
page that was not successfully mapped will be INVALID_GRANT_HANDLE, so
this catches all cases where unmapping can legitimately fail.

Suggested-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: 87a54feba68f ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d4da68570d08d963f6ef40c8d9c37..22fcd503f4a4487d0aed147c94f432683dad8c73 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,17 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset+i].status &&
+			map->unmap_ops[offset+i].handle !=
+			INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset+i].status &&
+				map->kunmap_ops[offset+i].handle !=
+				INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
