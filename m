Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF151302AB3
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731106AbhAYSuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbhAYStC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28093206FA;
        Mon, 25 Jan 2021 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600527;
        bh=zKb5H06GpRQDY5QCgEVf4RPqkwLCkUsm81D+OU6n8gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IJEnRBxK7Iu6AkFkwcF3oVdrtaAUMYwsPpaJ8RRJdCmYGBmq0A1a4rkXmIXafV3c
         /xrNqxRQmdzizQp70blUiJ9b+lbeZs+Xc+KW9rQ8fQMu3o9zCz7empT69zNvg2bSMh
         IkgaKxQgLA1LXYJHcBjDmSSJ9hz8Dcv+TyhC0NPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/199] HID: logitech-dj: add the G602 receiver
Date:   Mon, 25 Jan 2021 19:37:51 +0100
Message-Id: <20210125183218.330760336@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Laíns <lains@archlinux.org>

[ Upstream commit e400071a805d6229223a98899e9da8c6233704a1 ]

Tested. The device gets correctly exported to userspace and I can see
mouse and keyboard events.

Signed-off-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 1ffcfc9a1e033..45e7e0bdd382b 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1869,6 +1869,10 @@ static const struct hid_device_id logi_dj_receivers[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		0xc531),
 	 .driver_data = recvr_type_gaming_hidpp},
+	{ /* Logitech G602 receiver (0xc537) */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		0xc537),
+	 .driver_data = recvr_type_gaming_hidpp},
 	{ /* Logitech lightspeed receiver (0xc539) */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1),
-- 
2.27.0



