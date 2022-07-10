Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5419756D1DC
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 01:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiGJXFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 19:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJXFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 19:05:42 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A532CF597;
        Sun, 10 Jul 2022 16:05:41 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0733C5C010F;
        Sun, 10 Jul 2022 19:05:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 10 Jul 2022 19:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm2; t=1657494339; x=
        1657580739; bh=f9bSjqSEnIXH1UABF2q7HoN67rLpDoOJdF+QGXn1KUY=; b=n
        ImRps3NNA9r8Ob0rontYzLsDJVt0ZKLdUPlwsX95x6GpbRD6x7Lyn02YYRWcPfYL
        0VB408VfRNmsr7fuMixiDSJwzLQyGX6MyZgJHVZs1/aRPXq4IQi+ToW9sgeLHC9r
        3K4OlkDn1n9DDTGW/BcRQZFjZRxwVsJNilVdcAgTFAxSTMjlH2qCbfItNvJ5LN97
        83Z+wBkAHz6Zh8Nn93mhQxkpY1bQHO/H1wI1+TTIM00Nf+lb6a+g3DJUbt6YtT9P
        hI1VuWdLykvFiSBM6s+sIIYmcpm9Zg/ufniYgw50zJLNDfWxBpUc388JdyG1RHCi
        pzlxG/mF50z8cuOY+iFjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657494339; x=1657580739; bh=f9bSjqSEnIXH1UABF2q7HoN67rLpDoOJdF+
        QGXn1KUY=; b=alILd2VqdjjP7T0DMJumMBXvyb06DgdGontjC9CN3A+FDaaueyI
        xVrkIj4AeGQOcN651bBOBMgm+ZVqCW0xNBNjdSS1aFkl30TLmV0/reDYtKe9EMvR
        ptroAa1dMqCNnif0v6TbAJMHh9OsQrN6nxSDioemRAzFhc2rEOq2oyCD+j7Ixp3T
        pCD2m3czGe0Yk3FHgfQn7MKYgQySVfQ5aivwMpIjaK99ZQFzooArZGBHxbp3jhf3
        g/tzSzKRwTElGqtf9VHWQWP8thKU4Y3cFYPWCTrsFxlTCPKob8raooKgyBf6jU3c
        lI8sXehCvrvYYAUinIl7tBTgghiQ2yTspvg==
X-ME-Sender: <xms:QlvLYrYimvrXsyUHJI3Iq8i-pAXr9yFJ4Ov1RskGM0LfEl78Dsk9Uw>
    <xme:QlvLYqZnjkpWuxgjAGGOz-KxJLs2fBE2DIQtn6xlUCnDU68JiTP8pqkU1APSNSs-j
    gzzn9uMDXmtUVo>
X-ME-Received: <xmr:QlvLYt-dKSjZ6RG-qp2MOhAhEnjnf5z2_OlK5_vqSp7XPBGMQDDmLcMkP7sTIM7WZfmMo2qY8oju>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
    hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
    sgdrtghomh
X-ME-Proxy: <xmx:QlvLYhr-Ba7EtRQht-ODUj7gNfFYD1U4pG36EVbcDrX3kWHAUI7rSw>
    <xmx:QlvLYmpRFIPGyFast4ehq-otrzPRgX4xrmXIkzmhjEkVPtfhMciH1g>
    <xmx:QlvLYnSCaoul2rBMKybiCc5DdWMUsyjSKZ5HevK-8z-KoB5mus73FA>
    <xmx:Q1vLYvnWBqnYHkxAO5SDNNEWYqEkpN5YfwGc3B1WLT6XdB0hyatxZA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Jul 2022 19:05:38 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Sun, 10 Jul 2022 19:05:22 -0400
Message-Id: <20220710230522.1563-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
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
Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Changes since v2:

- Use unmap_ops instead of kunmap_ops in the first WARN_ON

Changes since v1:

- Explicitly check for a status other than GNTST_okay instead of
  implicitly checking that it is nonzero.
- Avoid wrapping a line as within a comparison, as this makes the code
  hard to read.

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d4da68570d08d963f6ef40c8d9c37..84b143eef395b1585f3a8c0fdcb301ce9fbc52ec 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,15 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset + i].status != GNTST_okay &&
+			map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
+				map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
