Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212C5657E66
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiL1Px1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiL1PxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B7186CC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:53:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F3761563
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315A4C433D2;
        Wed, 28 Dec 2022 15:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242795;
        bh=FuY29uJp6hIWZiVwJwcmwB4odqzVngFs/w6jXr5gCKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6K537WWE0SJH9bMp4gy+er3h5f2sT12LFyPmwIRlpMORsXqkloDVEDy9l3j08LqV
         5N/5sIFx51Q5cgXLF/7cdqVDSGwa+jl2cNS0DWaLeMrAouQ5t5r/euSU4Mgjwscu97
         7XBv60mdE6vO496jj4Tj4YGHekn44nEflTWw/9Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alim Akhtar <alim.akhtar@samsung.com>,
        Aakarsh Jain <aakarsh.jain@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0417/1146] media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC
Date:   Wed, 28 Dec 2022 15:32:36 +0100
Message-Id: <20221228144341.497856956@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aakarsh Jain <aakarsh.jain@samsung.com>

[ Upstream commit f50ebe10f5d8092c37e2bd430c78e03bf38b1e20 ]

Commit 5441e9dafdfc6dc40 ("[media] s5p-mfc: Core support for MFC v7")
which adds mfc v7 support for Exynos3250 and use the same compatible
string as used by Exynos5240 but both the IPs are a bit different in
terms of IP clock.
Add variant driver data based on the new compatible string
"samsung,exynos3250-mfc" for Exynos3250 SoC.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Fixes: 5441e9dafdfc ("[media] s5p-mfc: Core support for MFC v7")
Signed-off-by: Aakarsh Jain <aakarsh.jain@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/samsung/s5p-mfc/s5p_mfc.c    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
index fca5c6405eec..007c7dbee037 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc.c
@@ -1576,8 +1576,18 @@ static struct s5p_mfc_variant mfc_drvdata_v7 = {
 	.port_num	= MFC_NUM_PORTS_V7,
 	.buf_size	= &buf_size_v7,
 	.fw_name[0]     = "s5p-mfc-v7.fw",
-	.clk_names	= {"mfc", "sclk_mfc"},
-	.num_clocks	= 2,
+	.clk_names	= {"mfc"},
+	.num_clocks	= 1,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v7_3250 = {
+	.version        = MFC_VERSION_V7,
+	.version_bit    = MFC_V7_BIT,
+	.port_num       = MFC_NUM_PORTS_V7,
+	.buf_size       = &buf_size_v7,
+	.fw_name[0]     = "s5p-mfc-v7.fw",
+	.clk_names      = {"mfc", "sclk_mfc"},
+	.num_clocks     = 2,
 };
 
 static struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
@@ -1647,6 +1657,9 @@ static const struct of_device_id exynos_mfc_match[] = {
 	}, {
 		.compatible = "samsung,mfc-v7",
 		.data = &mfc_drvdata_v7,
+	}, {
+		.compatible = "samsung,exynos3250-mfc",
+		.data = &mfc_drvdata_v7_3250,
 	}, {
 		.compatible = "samsung,mfc-v8",
 		.data = &mfc_drvdata_v8,
-- 
2.35.1



