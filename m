Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CFB2666BE
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgIKRcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgIKMzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F236122242;
        Fri, 11 Sep 2020 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828867;
        bh=lZ5TKnTvsDFLdz1tt3WI/zKtO1wcb+Jobwo0hp1g1GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzvjdlILZUYaqX77EnGyJhw4E+zLxdL3wsZye+0vAR9liNIGzEr3yABcfjlUNzuWq
         EDi3FIBwien6Q/JV2UbZuQ+F72hcF1rjR/EE41ghHfdLIzG1SJHUe2d2qmT7Oh1LF1
         /t4fF8ZwW3DILZsWbSJN7Ie5r7CNHTgtoHJATAe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rogan Dawes <rogan@dawes.za.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 38/62] usb: qmi_wwan: add D-Link DWM-222 A2 device ID
Date:   Fri, 11 Sep 2020 14:46:21 +0200
Message-Id: <20200911122504.292512553@linuxfoundation.org>
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

From: Rogan Dawes <rogan@dawes.za.net>

[ Upstream commit 7d6053097311643545a8118100175a39bd6fa637 ]

Signed-off-by: Rogan Dawes <rogan@dawes.za.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 36aadc89175f8..ce3b810395224 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -886,6 +886,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x19d2, 0x2002, 4)},	/* ZTE (Vodafone) K3765-Z */
 	{QMI_FIXED_INTF(0x2001, 0x7e19, 4)},	/* D-Link DWM-221 B1 */
 	{QMI_FIXED_INTF(0x2001, 0x7e35, 4)},	/* D-Link DWM-222 */
+	{QMI_FIXED_INTF(0x2001, 0x7e3d, 4)},	/* D-Link DWM-222 A2 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
 	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
-- 
2.25.1



