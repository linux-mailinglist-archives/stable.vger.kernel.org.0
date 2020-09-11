Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76FF2664EC
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIKQsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbgIKPHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:07:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0699322248;
        Fri, 11 Sep 2020 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829102;
        bh=wbfMpO1CvzPj98oV+GB0cklZ4KO/EvDvcqxWWtPeAu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoP6Yba63VhlowSyhDafCvgek1QrdcV18Pa5sDVRqfh+HOvDPnSSwlA7mt4nSvnC+
         edEGBIj4cp6q0wZegQsVIXJu9fXQt6miDatMLtqqp5Kzie815f7ej7YaysBwQ8mbcr
         RN/5URWhRMDo/gZPtvxvnxvUItANu/z1cd90W7tQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Kloc <petr_kloc@yahoo.com>,
        Teemu Likonen <tlikonen@iki.fi>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 38/71] qmi_wwan: new Telewell and Sierra device IDs
Date:   Fri, 11 Sep 2020 14:46:22 +0200
Message-Id: <20200911122506.828242015@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 60cfe1eaccb8af598ebe1bdc44e157ea30fcdd81 ]

A new Sierra Wireless EM7305 device ID used in a Toshiba laptop,
and two Longcheer device IDs entries used by Telewell TW-3G HSPA+
branded modems.

Reported-by: Petr Kloc <petr_kloc@yahoo.com>
Reported-by: Teemu Likonen <tlikonen@iki.fi>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6104500314d18..d812335600212 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -910,6 +910,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1199, 0x9056, 8)},	/* Sierra Wireless Modem */
 	{QMI_FIXED_INTF(0x1199, 0x9057, 8)},
 	{QMI_FIXED_INTF(0x1199, 0x9061, 8)},	/* Sierra Wireless Modem */
+	{QMI_FIXED_INTF(0x1199, 0x9063, 8)},	/* Sierra Wireless EM7305 */
+	{QMI_FIXED_INTF(0x1199, 0x9063, 10)},	/* Sierra Wireless EM7305 */
 	{QMI_FIXED_INTF(0x1199, 0x9071, 8)},	/* Sierra Wireless MC74xx */
 	{QMI_FIXED_INTF(0x1199, 0x9071, 10)},	/* Sierra Wireless MC74xx */
 	{QMI_FIXED_INTF(0x1199, 0x9079, 8)},	/* Sierra Wireless EM74xx */
@@ -928,6 +930,8 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1201, 2)},	/* Telit LE920, LE920A4 */
+	{QMI_FIXED_INTF(0x1c9e, 0x9801, 3)},	/* Telewell TW-3G HSPA+ */
+	{QMI_FIXED_INTF(0x1c9e, 0x9803, 4)},	/* Telewell TW-3G HSPA+ */
 	{QMI_FIXED_INTF(0x1c9e, 0x9b01, 3)},	/* XS Stick W100-2 from 4G Systems */
 	{QMI_FIXED_INTF(0x0b3c, 0xc000, 4)},	/* Olivetti Olicard 100 */
 	{QMI_FIXED_INTF(0x0b3c, 0xc001, 4)},	/* Olivetti Olicard 120 */
-- 
2.25.1



