Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15573FDC8B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345418AbhIAMvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346375AbhIAMty (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B21461213;
        Wed,  1 Sep 2021 12:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500084;
        bh=/yfbhdg/LeFCR5Vt31anJKUzSxxgsUSUGF1icSjmWVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o19s6VJ7nLxge6pacplaKUnU3wwiVQwC05cTR0mWNbGiDOa1qhSg8p5vbko/GUiJl
         Y9/n/pbauoTHLp/xxMcByo9S3TfVWWbFk2tDvZB+ajQHAbJUnPWE08w/UT5msI6PvY
         pGn1sZkOSy7TZG9jc85Ds3hqWZqfTbnjAbpSc0Ts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 095/113] platform/x86: gigabyte-wmi: add support for B450M S2H V2
Date:   Wed,  1 Sep 2021 14:28:50 +0200
Message-Id: <20210901122305.128126499@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 1e35b8a7780a0c043cc5389420f069b69343f5d9 ]

Reported as working here:
https://github.com/t-8ch/linux-gigabyte-wmi-driver/issues/1#issuecomment-901207693

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20210818164435.99821-1-linux@weissschuh.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 9e8cfac403d3..7f3a03f937f6 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
-- 
2.30.2



