Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37CA8E97
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbfIDR6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387606AbfIDR6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFDD2233FF;
        Wed,  4 Sep 2019 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619932;
        bh=dkHU3hRpMZ1VdQXl6nFX+RS2OUk0M+f1rczffQ+YAEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOEUXj9UoG/IpqyLozztEa/Il/IIt4h9F2SUx8ysyiKzn8M0u7bPtb3xrhgIxkjYc
         Jo4upqXRztzA45PEmj1t5mSUIn/MV9zjPxecjkMGDqoCHIBQOrWHWdLtI04u1QvOJD
         8mbzkmq+jrHP+fMuTjECsD58/GUNZMcnuShpRdx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Ham <bob.ham@puri.sm>,
        "Angus Ainslie (Purism)" <angus@akkea.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 11/83] net: usb: qmi_wwan: Add the BroadMobi BM818 card
Date:   Wed,  4 Sep 2019 19:53:03 +0200
Message-Id: <20190904175304.780171453@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9a07406b00cdc6ec689dc142540739575c717f3c ]

The BroadMobi BM818 M.2 card uses the QMI protocol

Signed-off-by: Bob Ham <bob.ham@puri.sm>
Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index d51ad140f46d2..05953e14a064e 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -892,6 +892,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2001, 0x7e35, 4)},	/* D-Link DWM-222 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
+	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */
-- 
2.20.1



