Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92609696E8
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbfGOOCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387571AbfGOOCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:02:13 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B21E21530;
        Mon, 15 Jul 2019 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199333;
        bh=j1lDdqYNqnK+aEApFgVCRclHKlxP7K2HeiG+aldf/nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXEL9S3D7Y2UPT/ILhyilqpQ/Q9+ibtqMjZUPyBBeXNqMbXGeBfjZFPT15gSfSBgH
         x0I5yOUQKHxuZaabmrf1Z2p/urOYyQ3azUAJLxbtrEIdZKNVpGZy4Qx/sbWwH5nguH
         ihhAIVIbJMsENIw1sgTSk3uW2+CgyzmTPGHxGjRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@gmail.com>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 236/249] Bluetooth: Add new 13d3:3501 QCA_ROME device
Date:   Mon, 15 Jul 2019 09:46:41 -0400
Message-Id: <20190715134655.4076-236-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: João Paulo Rechi Vita <jprvita@gmail.com>

[ Upstream commit 881cec4f6b4da78e54b73c046a60f39315964c7d ]

Without the QCA ROME setup routine this adapter fails to establish a SCO
connection.

T:  Bus=01 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=13d3 ProdID=3501 Rev=00.01
C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
I:  If#=0x1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 21fa5c889857..6d61f5aafc78 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -266,6 +266,7 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_DEVICE(0x04ca, 0x301a), .driver_info = BTUSB_QCA_ROME },
 	{ USB_DEVICE(0x13d3, 0x3491), .driver_info = BTUSB_QCA_ROME },
 	{ USB_DEVICE(0x13d3, 0x3496), .driver_info = BTUSB_QCA_ROME },
+	{ USB_DEVICE(0x13d3, 0x3501), .driver_info = BTUSB_QCA_ROME },
 
 	/* Broadcom BCM2035 */
 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = BTUSB_BCM92035 },
-- 
2.20.1

