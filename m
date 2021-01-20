Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699012FC6C6
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbhATB27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbhATB2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826682336D;
        Wed, 20 Jan 2021 01:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106027;
        bh=T4UKDtTLH3uErx25Eb+nAvlGUQBbaXBFMPyk+zDVVGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOPdNqgbgn1Vo4b8wNpOjD7Hjnu4K8yJurx0zlC7KHfKagSqb8OsV4nMZu70oSoU8
         o0ll6XPx8oDukufHzFhcLZfbjXHAqjQ+MdzuVCncbbNNa4rwAaxGjE6eZUUs/1bcjk
         WXiMZwtGDDagz4HEJrFi8+oH8BmSQLnbTF1wHk9A7phOab9pQrRqkhEDV1YDyAKjt0
         0gVcruuGtNJxJl0rqHWpN1rz3X1FfnTQ0DSSY6hb6wn7aQc/yeWrUUv332Vy8AfsZY
         3pVDXRk4/CiT7XprUYAh3jIRM20ItpOQg/8vPupeFPX84nWJtpvm8Bt9K1t9usrsf9
         Mw62DZbuV+sGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/26] HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device
Date:   Tue, 19 Jan 2021 20:26:39 -0500
Message-Id: <20210120012704.770095-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index 128d8f4319b9f..d91e6679afb18 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2084,6 +2084,10 @@ static const struct hid_device_id mt_devices[] = {
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

