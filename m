Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B00A3F549E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhHXA4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhHXAzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC63A61462;
        Tue, 24 Aug 2021 00:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766468;
        bh=/yfbhdg/LeFCR5Vt31anJKUzSxxgsUSUGF1icSjmWVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owqD93nuRXP5J+sA0bFlAdEin95X0itNuw//bLU3PryK3vEgn+GgA+DAUM5Tnrz7r
         rcrQtNGqK7CmdPkpK4gi/8jBCYSrApmICYyrAxeO3s7/zaR0XAGTzfPUaBH9idYE1H
         F73pXyg8EVpq+bgfIvBIQZe0AaXgrI0bMUhOVFIobXTym89HO1L8LMIHpYfs3Pu0HT
         8rPMurPyic/qTcvUxMRuN466notZVeNro4z1Ypsb4p7Q0X7x+VjdVxd/bftj2aJk3E
         lGhHGjssEo52iIXuWs52FgINByaWEYNKmGWihwXlF3vBMKT+TnZsxU4DOgHsCO6Hk/
         9qe1wUTj5uxRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 24/26] platform/x86: gigabyte-wmi: add support for B450M S2H V2
Date:   Mon, 23 Aug 2021 20:53:54 -0400
Message-Id: <20210824005356.630888-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

