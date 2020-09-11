Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725492666C0
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgIKRcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgIKMzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58E022243;
        Fri, 11 Sep 2020 12:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828870;
        bh=RMtP8Iwp68EL2Eh3y6PGWnoyQ3InvTXOA/Ug+UA7llw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8hSeFU06pS4iIIjPgvufXgSsIopZciSGBdc8ofzVpXeEfAJma1ch3oMhr3bMLk91
         vqvf8SxYJyPA3CGyzi52vdmV83OKKEEk4/2U7f5urVMq0EZq9B00UFfWflba8SuBQE
         I5z/u2Vy9qaIR+FYLcdqvDx0n9+5avCpBdUdaywI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 39/62] net: usb: qmi_wwan: add Telit ME910 support
Date:   Fri, 11 Sep 2020 14:46:22 +0200
Message-Id: <20200911122504.341258188@linuxfoundation.org>
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

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 4c54dc0277d0d55a9248c43aebd31858f926a056 ]

This patch adds support for Telit ME910 PID 0x1100.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index ce3b810395224..c5c8224fc8cb3 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -921,6 +921,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
+	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1201, 2)},	/* Telit LE920, LE920A4 */
 	{QMI_FIXED_INTF(0x1c9e, 0x9b01, 3)},	/* XS Stick W100-2 from 4G Systems */
-- 
2.25.1



