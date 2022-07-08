Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD80856C064
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 20:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbiGHQj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 12:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbiGHQj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 12:39:28 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8365237C3;
        Fri,  8 Jul 2022 09:39:27 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 795D63200991;
        Fri,  8 Jul 2022 12:39:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 08 Jul 2022 12:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1657298365; x=1657384765; bh=Y+RlhIU6vcdXRbbN1vVgH9bjMqskW29Y/Ef
        fMgEqJZQ=; b=i0/UL2zjjaZXX/VULC54735TU47noiExIU73NHexI5Bxj2aiX0F
        PjAdIyLfS5znmLt3U1EGUiwZEdG1A6flSJXWRrMUCa2tkjwlI543rATLXmAUNsrI
        pH1Ds2+O0W8FbSA6Ij/JSpjmzJpcmHLj6/RmOg5Zgxu5ZnTNQnV3lR/tZLItROmH
        hX8FIXzq+o4uo6H2xTZZVCwwxd8EORCvTEpkmvlOVd/bobdCWkSFCI/1n5+f0gj9
        GoJZ38iv25vQfBxx2Xw5rF1QdSwCXAeJwqDRnTJ/XBIXgn7G6ML8PfwdiFCgh/iO
        zAqAfbSgIdZfPeN2BoYmok605G8ljA7/7Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657298365; x=1657384765; bh=Y+RlhIU6vcdXR
        bbN1vVgH9bjMqskW29Y/EffMgEqJZQ=; b=UsExiFmmlq5Bhu1AZQbdi1EhWgfBR
        raj6TZCIoz3BqdlBkU8FnClfQyAswdg2uPwh4SwBA0lS9QJCb4WIv/6SD3oLYTK5
        cIWCyhVU/KmdjWMxaoYU3tZc0Bg1cKnF8z1kibyqnUDvtD5vzZciVrMrt2bm1XYv
        odBZRxmKeM0axP7J85s/7c6WM9wzminmaU1SaR/EH6HbBpjDkcZsH3dKEysBWiOZ
        nrvkWxJcuolGzP3jOtgCDoM+ZIKZ/oiiK0EH1TKmgY/YhsqAcpjxL5YWVTG287s8
        syxYcvHp1BGRpe94zwHU6e8Yp+kq/djehOfu/DDXH8rvT7jz2WXpofDhw==
X-ME-Sender: <xms:vV3IYqI6jheKGhkURnoxoSqnWuGs1MoBNNgkf7mV8UVVKezTasm7Ww>
    <xme:vV3IYiKfiqE-u2Mj07TRNTlWZ8wyuyOTdc17jlXTct0Wa687zUvXIHBKBgB5S7T3x
    3nC8lkocInfjBg>
X-ME-Received: <xmr:vV3IYqultnkRO46ewMSbEnok5qFmkQ2wCO6Th2T4ww5uiiAKMnNV46z37a1X9GqRyyf2YCOIDhyL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeijedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
    hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedune
    curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
    shhlrggsrdgtohhm
X-ME-Proxy: <xmx:vV3IYvaXIzSs7HSh9-niG60_7mC8dxhN4dXd2uNk-GEq62m6kUA0FQ>
    <xmx:vV3IYhZ8utSLjtpJYdxbJMhPpQilL3tBb9YS81LYnZj5M0c0LZko3w>
    <xmx:vV3IYrA1ERjb6zpU7xGjGbx51C76tLnMb9XlpP5kpqR70GMKLDiUaA>
    <xmx:vV3IYmOMZxSPHJvKjCRpxWornVVrllMG9AQ_EVmeHXHBsm5vYcFCZw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Jul 2022 12:39:25 -0400 (EDT)
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
Subject: [PATCH master] Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Fri,  8 Jul 2022 12:37:51 -0400
Message-Id: <20220708163750.2005-8-demi@invisiblethingslab.com>
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
Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
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
