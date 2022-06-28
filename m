Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4FD355CAC8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244195AbiF1Caw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiF1C2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3A625598;
        Mon, 27 Jun 2022 19:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32720B81C0D;
        Tue, 28 Jun 2022 02:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C1C34115;
        Tue, 28 Jun 2022 02:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383230;
        bh=lacPAtZsEPiZpm46yptQlJb7OhqxDdXtZKNT0DH6wYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9vFJ0m77ec6dtiszo8G/+JgQLwWen/gEQYLzOc69gIsFOiQbqODIQ2oSgIPRHQdA
         ECRAlFHto6ehvKyXJYTtKMLRoCCgo3etcJiKiJm4JleFb0tQUQtBN0kozug8n8oCc3
         oW7afg+MQSoaK66DOUeAQYiu+eJCObAgBqg++GyHZekZ2skNJ4J7XYfBHY3E3ZdDMo
         OyPsCQ/Fzg9oi40HyMKI2sTinqSp35lomzXnyUJ0ayv5u7yCDm1k7IrSXo8hMXsG78
         TRtRuKPjSJq1OtueuVW82VcmdLyKkt/npq2AvK6zv0UAxW02aGh6FtLlsXtCjwBWWX
         criFOEqYwAlLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang wangx <wangxiang@cdjrlc.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, cssk@net-c.es, tzimmermann@suse.de,
        bhelgaas@google.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.9 05/13] video: fbdev: skeletonfb: Fix syntax errors in comments
Date:   Mon, 27 Jun 2022 22:26:49 -0400
Message-Id: <20220628022657.597208-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022657.597208-1-sashal@kernel.org>
References: <20220628022657.597208-1-sashal@kernel.org>
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
index f948baa16d82..254bb6e2187c 100644
--- a/drivers/video/fbdev/skeletonfb.c
+++ b/drivers/video/fbdev/skeletonfb.c
@@ -96,7 +96,7 @@ static struct fb_fix_screeninfo xxxfb_fix = {
 
     /*
      * 	Modern graphical hardware not only supports pipelines but some 
-     *  also support multiple monitors where each display can have its  
+     *  also support multiple monitors where each display can have
      *  its own unique data. In this case each display could be  
      *  represented by a separate framebuffer device thus a separate 
      *  struct fb_info. Now the struct xxx_par represents the graphics
-- 
2.35.1

