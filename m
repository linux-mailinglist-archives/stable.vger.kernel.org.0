Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4446265FE5
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 14:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgIKM4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 08:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgIKMzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DC62222E;
        Fri, 11 Sep 2020 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828855;
        bh=PzYoJXKrSnqCth4TYncDPbCZXJWhG5/jzJXPUlAr6dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gERwoZzxJ1XsJJ/JJHER8cIsnBZu914M2DkriOFuHWhfDkdiPjg7stxg0PcZPfcUl
         PGyEM8uJXObP/4Q20uIh3MOWQ/g93+dHXcz4iPFojgd75/3FAOMOcR3WbzSt9hnEjL
         S1ql0f1TqhmAxXTiFa5QPAPcprJ5a9GpChH+5MoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik Halfar <patrik_halfar@halfarit.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/62] Add Dell Wireless 5809e Gobi 4G HSPA+ Mobile Broadband Card (rev3) to qmi_wwan
Date:   Fri, 11 Sep 2020 14:46:16 +0200
Message-Id: <20200911122504.043662497@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrik Halfar <patrik_halfar@halfarit.cz>

[ Upstream commit fb5eb24cdd5cdb83be77d3e4b2f16e92e06bd9e9 ]

New revison of Dell Wireless 5809e Gobi 4G HSPA+ Mobile Broadband Card has new idProduct

Bus 002 Device 006: ID 413c:81b3 Dell Computer Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x81b3
  bcdDevice            0.06
  iManufacturer           1 Sierra Wireless, Incorporated
  iProduct                2 Dell Wireless 5809e Gobi™ 4G HSPA+ Mobile Broadband Card
  iSerial                 3
  bNumConfigurations      2

Signed-off-by: Patrik Halfar <patrik_halfar@halfarit.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f8d00846b4a59..977df611164a6 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -913,6 +913,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x413c, 0x81a8, 8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a9, 8)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81b1, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x03f0, 0x4e1d, 8)},	/* HP lt4111 LTE/EV-DO/HSPA+ Gobi 4G Module */
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
-- 
2.25.1



