Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3AE56D1B2
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiGJVzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJVzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 17:55:13 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0A7B1C7;
        Sun, 10 Jul 2022 14:55:12 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 02C375C00CD;
        Sun, 10 Jul 2022 17:55:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 10 Jul 2022 17:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm2; t=1657490111; x=
        1657576511; bh=bYOYM3GJ4HWkYd9UXZfvKiZiP3sprP1rEpmhtfOFK64=; b=j
        Lqce5XkEg5NecSrWF/ZNV9oQHlQQ3GQwHTc/gapx6tjo0+tJg7/HHKnOK/q52nOi
        GeRlf+BOrE30UEjcGF9o991q4uADYBGc8s3A0SS4jDNFX5/xroAqHpdz7nszH3pz
        wj4bVFYHflH4vD+8JF3XXk+evdFsGyPlozvVri/T3vMLpZtM5gcg8et9OU3lp+BD
        Hz1Gy1fwVdOdXAukQp+Up+qxmCF+oCUW1uyvqbEGPmW/LvPsSq2K4N21IKt8LnLB
        tMa7XOruY+7+F0UqXrEgHDQ83rF7DKLIp93mQlezxl2WnGWvU5Hzkvvf45V8+mgN
        8yQQqmZDKoYx5lbB/6eWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657490111; x=1657576511; bh=bYOYM3GJ4HWkYd9UXZfvKiZiP3sprP1rEpm
        htfOFK64=; b=0as6LkJDhNwIofcsWDFsJRMrgeUub4XTmSzrAHgZp2YHey+HExs
        h1LIFGSid3YuYbLt1xcMURPi37PC/YYWvG0YFRVypPlKjDrZbz00aorOEhQjgkkH
        FXaFMsgE3OTaCagnWfl4FiGY6+y07uuAMYx90zW1Db/L2gzhteQbykLJIO4yBrnj
        8pKvnlfTuq6cwXKB+HnAtUYAo/LQge5PGXOWuZN+nySxr5bZiTAC7re6TUWS7IG/
        xcaTYqyjtyVzlAEoogDL4UBta8gXhUn4Z5dxH9M8u5yPqfDiEZkoskTDUu18j20S
        L58itg4AlLKu41DqFQzWc1z3n8KBAOAvxNQ==
X-ME-Sender: <xms:v0rLYiXqdi6NJSbRdYJmrkW2Z5WvFEDmAxbqxycEbQFRPBrmFKXiuA>
    <xme:v0rLYukLEdeGwx1GBOCOpNVCUrsne9EgoLJ2dI4BLcctF-8mAgXkuvBqt7dSOBhAG
    axUODUnC3ZoP3M>
X-ME-Received: <xmr:v0rLYmbAIeOlRa-Sc1x6CyVwtKNIRFqxP8IONab5GgquAqyyV7E8WnbYeHYKA51WJPOIof5NOop1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejvddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepvdefgeekvdekgfffgeekhfeijedtffek
    hefhleehfeejueetgfelgefgtdevieelnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
    sgdrtghomh
X-ME-Proxy: <xmx:v0rLYpX7JR83nx0pP35LjqP9081tCjFv0uFV-lWvH3a7c0r2KEVATw>
    <xmx:v0rLYsnA08J8QUFc5WF8M2CuoowDtVLgOGMpGqmfkk_v21BmcSIOrw>
    <xmx:v0rLYudHkLtJ34oE0Rz2vkHA9vZSJM8sdgk1Nf9fbZE6b7ia7lS1vA>
    <xmx:v0rLYtAiGyRkdkinWa-hr5BI4ZGN9IaMjdc33Ytk0nykjkqN3ihdSQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Jul 2022 17:55:11 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v10] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Sun, 10 Jul 2022 17:54:37 -0400
Message-Id: <20220710215437.1351-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
---
 drivers/xen/gntdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d4da68570d08d963f6ef40c8d9c37..44a1078da21b8a2333b4432900a8dbdfb8e13c53 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,15 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
+			map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
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
