Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4515868103D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbjA3OBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbjA3OBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C0D76A4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B208261036
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B93CC433D2;
        Mon, 30 Jan 2023 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087263;
        bh=24SmoVPrrLsw/V4ZCXScCKOQE+2HunAS5YBa2iYOwP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2qGfDCDHIn6X2zlQSFSq/qm+xqJ4soh39WeinyomKkebAqpdZyWJ150tI/fByGF3
         w5BNHQkxb1QVTNt3gkhObprC+5grH37tW76tfBCZpWuBJb026d0cRwEQhzkvhGkzif
         b47qUXRDnCdMU3oGG70KK49NZi/es4iyEM0ZfDWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Aniol=20Mart=C3=AD?= <aniol@aniolmarti.cat>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/313] ASoC: amd: yc: Add ASUS M5402RA into DMI table
Date:   Mon, 30 Jan 2023 14:49:46 +0100
Message-Id: <20230130134343.694331168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aniol Martí <aniol@aniolmarti.cat>

[ Upstream commit a0dd7fcab5cd221fa960f594c586e1f9f16c02c0 ]

ASUS VivoBook 13 OLED (M5402RA) needs this quirk to get the built-in microphone working properly.

Signed-off-by: Aniol Martí <aniol@aniolmarti.cat>
Link: https://lore.kernel.org/r/20221227224932.9771-1-aniol@aniolmarti.cat
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 469c5e79e0ea..0d283e41f66d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -206,6 +206,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.0



