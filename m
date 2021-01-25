Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248463031CB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbhAYSoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbhAYSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13B59230FC;
        Mon, 25 Jan 2021 18:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600221;
        bh=T4UKDtTLH3uErx25Eb+nAvlGUQBbaXBFMPyk+zDVVGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/vMzD/4OoAInLR8z8jvTQkYtjEox+vBwCpkWotlvC5kW58lMJQJr8ePmZ3V7Ubrl
         v5FBHqq/mUhWwskHyL0yXN+xeCcsOtDso4a+EPrMLW9JIk3DbquX1/v37Yj+K5wj/Y
         viB0lxGObWZa9+tZA+/rtOZXIvJKz7zy84CkS82c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/86] HID: multitouch: Enable multi-input for Synaptics pointstick/touchpad device
Date:   Mon, 25 Jan 2021 19:39:01 +0100
Message-Id: <20210125183201.858660293@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



