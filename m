Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD20F68308C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjAaPD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjAaPCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3975422C;
        Tue, 31 Jan 2023 07:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 577B1B81D58;
        Tue, 31 Jan 2023 15:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27858C4339B;
        Tue, 31 Jan 2023 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177247;
        bh=n8Hio6+XVc1JL+1LkjfNJWCmSJmAHqg6Y5zxk4lWsec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoVk6mH9E8zBkOcF2RS+gNSqFZ6B9c9zZxSL6Z2OQ2fl4L/DiLzGyLf2Wpx26yOxf
         JZeCfEgyDPkpiPy2CQacVKOZxR29+uNgtYIi6r/NMIbkkxWZQCR750ubDJTrY8QgD3
         GKU15wGJIGkvj8tddzZHMUbmrmwLXOZ0GhF6lqEvuoRk1ZyIic2sTSToPAIdez7KwZ
         nM2jbm7wvEbaf/aTAWRXve7Iz/KgfQKM97ycWB5eSLW0w37dhaNmSTAtfb0bIOgyVZ
         UUtvhrHDTsQdGglNuMjD8dtLc3mTnwVNyM6X6ryNP1HrabEjRH1323E99ObeiLY+f/
         RKoAQNE+Ul0QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Kuriakose <kevinmkuriakose@gmail.com>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, thomas@weissschuh.net,
        markgross@kernel.org, platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/12] platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF
Date:   Tue, 31 Jan 2023 10:00:27 -0500
Message-Id: <20230131150030.1250104-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Kuriakose <kevinmkuriakose@gmail.com>

[ Upstream commit a410429a3b7e748a9db9f357e71e2e085a21c902 ]

To the best of my knowledge this is the same board as the B450M DS3H-CF,
but with an added WiFi card. Name obtained using dmidecode, tested
with force_load on v6.1.6

Signed-off-by: Kevin Kuriakose <kevinmkuriakose@gmail.com>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230119150925.31962-1-kevinmkuriakose@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index ebd15c1d13ec..0163e912fafe 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
-- 
2.39.0

