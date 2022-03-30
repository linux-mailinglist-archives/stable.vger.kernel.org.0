Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E937C4EC2A9
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbiC3MAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344196AbiC3Lzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02E22B250;
        Wed, 30 Mar 2022 04:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A0B8B81ACC;
        Wed, 30 Mar 2022 11:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368DCC340F3;
        Wed, 30 Mar 2022 11:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641224;
        bh=Owx5cXHHiohKZCzYmdkV7BuW9d3Ur7SqGy69wNLF/4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBEx/I6MWNvqwOXZM/RAhUJ1P8D9NP93LW38GrmyCSBG/SlH8yPycsJQ5jOaVWHZI
         uLbXwmKzil2yvkoLx5QsCdsc9uDRF3rogkqpWkQnhUy5xKfENc1otx+XxNz4TUEYYD
         TWtnYfDOok3MUDo5G0Kwc2e6rVjdMHMNqKLb/9vfhZ6onwTv4UVE6hLZSTFw3ji1fG
         KvGRhXOGf203iZI9Ed0MGRWwnEuU3uuUDXS6hAdLc8/ksYE+j+xfDys3bl4jmaD99i
         qrS+tiv+Ejzl+KDv2Ibk6haw9+Dfl9tm3QySrQWaLWI1X3K1OY00W6mthv6LST4Fap
         tx1441KyLZ3vw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, tomi.valkeinen@ti.com,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/20] video: fbdev: omapfb: acx565akm: replace snprintf with sysfs_emit
Date:   Wed, 30 Mar 2022 07:53:20 -0400
Message-Id: <20220330115336.1672930-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115336.1672930-1-sashal@kernel.org>
References: <20220330115336.1672930-1-sashal@kernel.org>
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

