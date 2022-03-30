Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1718D4EC290
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244974AbiC3MAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbiC3LzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB5D625C;
        Wed, 30 Mar 2022 04:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C046B81C25;
        Wed, 30 Mar 2022 11:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F5CC340F3;
        Wed, 30 Mar 2022 11:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641190;
        bh=Owx5cXHHiohKZCzYmdkV7BuW9d3Ur7SqGy69wNLF/4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1PyY3/zdMMpf4SWiW3JG1XBxJTAldgdlaD8Pyo6TrpLwF5uQW4M6Np2Q49+OEf8I
         cRAQvX3PkpTAy1Nokia9Lvad+9W7zvjZBRHBLKa4mx0PEobJWi8HV9nPgDm37jNbaF
         JLAgWIm+wJBkmL59upFJzU73nzDV0RI2jcN/LE/OMlxHBPY3baBxgd8Y7Dabwmb8qM
         hXCa2YbiXOon5u95/xFmhfs4WzaSK5nHSb+337jirZ1YeIVmH3k+GOD2MYcb7zRnFe
         xQK6w/oWUenzg0TjkQv8OxOOvPHJ/TyQeI/Iq9i8BjJ2Vxwjl1c5LkBec9kMeNGqM9
         ujWfz2OqrN5Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, tomi.valkeinen@ti.com,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/22] video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
Date:   Wed, 30 Mar 2022 07:52:45 -0400
Message-Id: <20220330115303.1672616-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115303.1672616-1-sashal@kernel.org>
References: <20220330115303.1672616-1-sashal@kernel.org>
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 24565bc4115961db7ee64fcc7ad2a7437c0d0a49 ]

coccinelle report:
./drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:
479:9-17: WARNING: use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
index f2c2fef3db74..87c4f420a9d9 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c
@@ -487,7 +487,7 @@ static ssize_t show_cabc_available_modes(struct device *dev,
 	int i;
 
 	if (!ddata->has_cabc)
-		return snprintf(buf, PAGE_SIZE, "%s\n", cabc_modes[0]);
+		return sysfs_emit(buf, "%s\n", cabc_modes[0]);
 
 	for (i = 0, len = 0;
 	     len < PAGE_SIZE && i < ARRAY_SIZE(cabc_modes); i++)
-- 
2.34.1

