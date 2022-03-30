Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CAA4EC20B
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345000AbiC3L54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345925AbiC3LzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B6410FA;
        Wed, 30 Mar 2022 04:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1DF39CE1A57;
        Wed, 30 Mar 2022 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83981C340F2;
        Wed, 30 Mar 2022 11:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641163;
        bh=2l3NMKJwTl8iPLfY5ms0FYzbxI/GUgoliNVkJUrhCcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aI9XGevxgfJYkXF/hiA2c98IfuVZjNm6EY3B78uxtSmXmAjvRfqwvGb0rtaVHoWIG
         gJOTwHq6cUh//fk6dFWiwyDnREELffhs1mSWhKGczTzF4QWYxo3nKvo7uyOK2gNXSq
         eN/twQPQWX9oY3TfbQOcMoZRxigpIVDX/ZSqBKo9a8bvAScPkbMXN0B4sS/X9qOS4u
         mvXgFHdP0juOR4x/gmDVrR5UZ4i2LXXVqI4vWzkcFZi1ekQ/Q6806/VjuJ+UafRw6c
         BNAlN/kLbBBq/7O6wMYiBJQt9B+BBQnDd2UzRbs/dGCN0bYVDMPFwJC32uUUUpH4qP
         mm3gzO4zVo4Kg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        tomi.valkeinen@ti.com, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/25] video: fbdev: omapfb: panel-tpo-td043mtea1: Use sysfs_emit() instead of snprintf()
Date:   Wed, 30 Mar 2022 07:52:11 -0400
Message-Id: <20220330115225.1672278-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115225.1672278-1-sashal@kernel.org>
References: <20220330115225.1672278-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

[ Upstream commit c07a039cbb96748f54c02995bae8131cc9a73b0a ]

Use sysfs_emit instead of scnprintf, snprintf or sprintf.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c  | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
index bb85b21f0724..9f6ef9e04d9c 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c
@@ -169,7 +169,7 @@ static ssize_t tpo_td043_vmirror_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->vmirror);
+	return sysfs_emit(buf, "%d\n", ddata->vmirror);
 }
 
 static ssize_t tpo_td043_vmirror_store(struct device *dev,
@@ -199,7 +199,7 @@ static ssize_t tpo_td043_mode_show(struct device *dev,
 {
 	struct panel_drv_data *ddata = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", ddata->mode);
+	return sysfs_emit(buf, "%d\n", ddata->mode);
 }
 
 static ssize_t tpo_td043_mode_store(struct device *dev,
-- 
2.34.1

