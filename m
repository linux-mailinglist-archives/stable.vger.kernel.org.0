Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D471C54A5C0
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351414AbiFNCP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353785AbiFNCOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A75B3AA58;
        Mon, 13 Jun 2022 19:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3BE260F1C;
        Tue, 14 Jun 2022 02:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC0C341C4;
        Tue, 14 Jun 2022 02:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172493;
        bh=7lHSFtUY1PHqrzclwXoAD8WLofsBbD+ZxJnchOu5vQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8AQVi4GtfG4hbw3ye4XkZfdjYB+tBXomqDsaeq7x3ErouQV8BeiMJLr6bAekZyog
         /Artt8I+iS+fKCiv/BD01DVyD/RQLMyQ/aZuCvU3XUYFYD3sMmA4FJ38+a9yMvgMGM
         KiEKPss6WqxMFEWzzEofMgXZofsMBUSJMM9A9elQrsth81/+xiIju8Omhe7HOlzlJD
         55VngVP7D1HwXjJaX9CzXiw4dRuriCT2XpVB33P9mnXgRTw2QJX0usfDy1G3ky02Wy
         mbS6gnUm7XveWdhZJpCzRJLyJJza4tFPxAXqX95UaMH366yPhsqq2stnrFDfENpFwm
         uHIxF1QubIPzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     August Wikerfors <git@augustwikerfors.se>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 40/41] platform/x86: gigabyte-wmi: Add support for B450M DS3H-CF
Date:   Mon, 13 Jun 2022 22:07:05 -0400
Message-Id: <20220614020707.1099487-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020707.1099487-1-sashal@kernel.org>
References: <20220614020707.1099487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: August Wikerfors <git@augustwikerfors.se>

[ Upstream commit c6bc7e8ee90845556a90faf8b043cbefd77b8903 ]

Tested and works on my system.

Signed-off-by: August Wikerfors <git@augustwikerfors.se>
Link: https://lore.kernel.org/r/20220608212028.28307-1-git@augustwikerfors.se
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index ad4f789309d6..ebd15c1d13ec 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
-- 
2.35.1

