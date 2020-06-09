Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CA01F4541
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388537AbgFISNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731078AbgFIRuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB82020734;
        Tue,  9 Jun 2020 17:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725054;
        bh=b9vOCKsHxoxrkiASyAMN5922ixYL3wmiSStmpuTWxyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD7j4n9jI0KbkMYtBK6ItHM5wDTsnQRushN2CQJYMiYtcW1AwNSOMrHWX35zxOwXp
         Kls5N7MgZc332VPUi3isGNlsT3TR2LYnaYrKxIWWREYaNR1K0zBs7zCbG1zWXNBX7W
         Ju0u73bnm3BO4zSSuNA2eYT1x3zd4zT+MwpQ54CY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 25/46] net: usb: qmi_wwan: add Telit LE910C1-EUX composition
Date:   Tue,  9 Jun 2020 19:44:41 +0200
Message-Id: <20200609174026.932083653@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 591612aa578cd7148b7b9d74869ef40118978389 ]

Add support for Telit LE910C1-EUX composition

0x1031: tty, tty, tty, rmnet
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1249,6 +1249,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x1bbb, 0x0203, 2)},	/* Alcatel L800MA */
 	{QMI_FIXED_INTF(0x2357, 0x0201, 4)},	/* TP-LINK HSUPA Modem MA180 */
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1031, 3)}, /* Telit LE910C1-EUX */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)},	/* Telit LE922A */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */


