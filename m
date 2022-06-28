Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1916855D326
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244892AbiF1CaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244736AbiF1C1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594C325EB9;
        Mon, 27 Jun 2022 19:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10B58B81C16;
        Tue, 28 Jun 2022 02:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D61C341CB;
        Tue, 28 Jun 2022 02:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383142;
        bh=eeaBP9D5qgTi5VnY68Jlus768yL8BfTS3ziQKvcbdYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnXEW+q7LSvA1Wp95CvZPt4Jnt0qgl7N2g4aa88uvJO7MMGOY3FPHQLR5RHXX7bRp
         FhD2Gq2Zli6haD0F7N9j+INQVinIuQM8ef7aI2HCUaw+eJSROWVEc8h/w0khyQJO7A
         uZouw8iOSpYPHqtc9wHUpJK2YdKR+XmNcYiy9DAU5/j4HwJI8nTQRvKyUub8emic9q
         QbNAZDJLd9XDQR75OgM5BkXQQGCkbeBJbVj3j8D2Dp/H72RunMNOqQ3t63ww+tgA2J
         2lUmwDeTeL/sGMt50Qx63h4o54M1Wc7bDnO3tBTaL5qRv6rR5SJslpB5lXMI1Llg6V
         lP1SJbltVOYMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang wangx <wangxiang@cdjrlc.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, daniel.vetter@ffwll.ch,
        cssk@net-c.es, svens@stackframe.org, geert@linux-m68k.org,
        bhelgaas@google.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 09/22] video: fbdev: skeletonfb: Fix syntax errors in comments
Date:   Mon, 27 Jun 2022 22:25:04 -0400
Message-Id: <20220628022518.596687-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang wangx <wangxiang@cdjrlc.com>

[ Upstream commit fc378794a2f7a19cf26010dc33b89ba608d4c70f ]

Delete the redundant word 'its'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/skeletonfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/skeletonfb.c b/drivers/video/fbdev/skeletonfb.c
index 812a36cb60c3..ac354909aecf 100644
--- a/drivers/video/fbdev/skeletonfb.c
+++ b/drivers/video/fbdev/skeletonfb.c
@@ -96,7 +96,7 @@ static const struct fb_fix_screeninfo xxxfb_fix = {
 
     /*
      * 	Modern graphical hardware not only supports pipelines but some 
-     *  also support multiple monitors where each display can have its  
+     *  also support multiple monitors where each display can have
      *  its own unique data. In this case each display could be  
      *  represented by a separate framebuffer device thus a separate 
      *  struct fb_info. Now the struct xxx_par represents the graphics
-- 
2.35.1

