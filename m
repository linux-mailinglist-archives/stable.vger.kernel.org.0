Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD2E2666AD
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgIKRbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgIKMzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0103022240;
        Fri, 11 Sep 2020 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828862;
        bh=OvGlPySaLooJfRF8h/ybUnhPjoQM+UqHv0gL8PVKjwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZ6M1AD/jecOA8YFcXrs6z9LBo8FhynAH+eiWPElcXHbKFVkIN8wyXiEZwxAdVqsO
         7GK5MtxmNJIImEjNihks5M9S1qIH/Fhn/LppYf9NoPHL06//Lf8wR/6uuTNUj0vJ7/
         6xjbsd56T5Ehgntw4ptCmPvGIWgC64CgFDc47HJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 36/62] NET: usb: qmi_wwan: add support for Telit LE922A PID 0x1040
Date:   Fri, 11 Sep 2020 14:46:19 +0200
Message-Id: <20200911122504.192780631@linuxfoundation.org>
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

[ Upstream commit 9bd813da24cd49d749911d7fdc0e9ae9a673d746 ]

This patch adds support for PID 0x1040 of Telit LE922A.

The qmi adapter requires to have DTR set for proper working,
so QMI_WWAN_QUIRK_DTR has been enabled.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index ffb2499a222da..d48639cfec370 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -919,6 +919,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1c9e, 0x9b01, 3)},	/* XS Stick W100-2 from 4G Systems */
-- 
2.25.1



