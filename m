Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F137C3DECF3
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhHCLop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236013AbhHCLoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9235C60ED6;
        Tue,  3 Aug 2021 11:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991046;
        bh=ze9idPzWLupSin9vh0mYCZQNLmWZal6ly8TfpzwUxNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lh0brk3hI2qRyBVk8c9U8XhTGcigOXLPUIxk+yKTpPnx5hLaGnXxlTWLyynX1YshF
         ar4NmpI5bhzRK57uCsxq8/L+wc+GNJKDHXcSKlwn42nO7ztURKZwvwhoRbUdSJlRI8
         MQiqx1+bM/joVvd36uskbvsIO0HHdPTb2EjyOON62He72Noc3I2xcg5NowJXgCw++i
         aSdno6vXDVqQ2yDg2W2PNqHy+9+UV1WFgpil8/FtwBcu1/0tG659Gb2mYgWSi4WpWF
         qfO/ueWROZab7ofTBMADOUMcfU35qZf6fsYnc7dYIY5Ch4CeNpTi+MQpmQnvdnqbif
         1y0vujG0N5W0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/11] platform/x86: gigabyte-wmi: add support for B550 Aorus Elite V2
Date:   Tue,  3 Aug 2021 07:43:51 -0400
Message-Id: <20210803114352.2252544-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114352.2252544-1-sashal@kernel.org>
References: <20210803114352.2252544-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 2b2c66f607d00d17f879c0d946d44340bfbdc501 ]

Reported as working here:
https://github.com/t-8ch/linux-gigabyte-wmi-driver/issues/1#issuecomment-879398883

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20210726153630.65213-1-linux@weissschuh.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 5529d7b0abea..fbb224a82e34 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
-- 
2.30.2

