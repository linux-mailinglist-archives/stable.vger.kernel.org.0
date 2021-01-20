Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E432FC7DA
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbhATC2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbhATB0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 582C123132;
        Wed, 20 Jan 2021 01:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105969;
        bh=QYbcRn/BnzG2H2nzpKhuqui5hnSozgbRMaT/E0YsHbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRdjO3TwMi8mwXh/Pkv4PAwhmsgQ1HLUNEDa/QPzm8zoK9mpL18rOa2eQiEEVl5aw
         v4PEKI2JNzjVNFrnfyTLa5r3y7RWLId6M7oaAKtmjQBaS4xYGHlXPAjrAAy4YA85/s
         GreGV8nHhWKp/dgqBdnneJIZv2EvxhMLPvA7R4UjjWl3kXg/pgJx1EH436xU8/rcDh
         2lNc5KPc1UKWyLa+jM4VduylzL1pHlKYWEOOZz1YZ/0BINXtD324ukpmGohq54ovZI
         AOfE15lj0sQ51yTtV5p+06BYsMtGyjLTvrTkBd8EszEkrwKNYW46LkbFQXZzr16PP8
         lhVtf+GKmclSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/45] HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device
Date:   Tue, 19 Jan 2021 20:25:22 -0500
Message-Id: <20210120012602.769683-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit c3d6eb6e54373f297313b65c1f2319d36914d579 ]

Pointstick and its left/right buttons on HP EliteBook 850 G7 need
multi-input quirk to work correctly.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d670bcd57bdef..0743ef51d3b24 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2054,6 +2054,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_SYNAPTICS, 0xce08) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_SYNAPTICS, 0xce09) },
+
 	/* TopSeed panels */
 	{ .driver_data = MT_CLS_TOPSEED,
 		MT_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,
-- 
2.27.0

