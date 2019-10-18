Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA6DD3FA
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbfJRWGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbfJRWGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD80B222CD;
        Fri, 18 Oct 2019 22:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436372;
        bh=kjo9ICuQPkhOav4Yl9dBwJDDgT/2AfUsxxAO5HKP1Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZr0YxpW2Z7PnLpagBopHJ6AkvQj5nbff1UKvgWRldGgeoGyKVdFNSrZrxM6GhBBH
         w6ImvCPT8ZpVoaqn4Q0FE6OjLwIbdH3kOD+VHoue8tM3dSZn/Ke7sIZlA5XgQLVCBz
         SASC4myCOulwdNLv4tU/PBsTXT0qpddMamJijxK8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     NOGUCHI Hiroshi <drvlabo@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 026/100] HID: Add ASUS T100CHI keyboard dock battery quirks
Date:   Fri, 18 Oct 2019 18:04:11 -0400
Message-Id: <20191018220525.9042-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NOGUCHI Hiroshi <drvlabo@gmail.com>

[ Upstream commit a767ffea05d2737f6542cd78458a84a157fa216d ]

Add ASUS Transbook T100CHI/T90CHI keyboard dock into battery quirk list, in
order to add specific implementation in hid-asus.

Signed-off-by: NOGUCHI Hiroshi <drvlabo@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d988b92b20c82..01bed2f6862ee 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -328,6 +328,9 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYMBOL,
 		USB_DEVICE_ID_SYMBOL_SCANNER_3),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
+		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.20.1

