Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54D9226BD1
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgGTPlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729839AbgGTPlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A0B22CB3;
        Mon, 20 Jul 2020 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259672;
        bh=1YHdk25NViAvmSs9pzPF5CB4v5JKe+5n4gcCPLAhJA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0aAL+T0O9QQ1umDP1o2ZZb18ZwG3deZpteVR/qzkpSicE37jLbtTKkNcfDDEGH00
         /Nw93iVivDbrnesxtDmYVlLWTWTzi7A8nsynCQiq0DKNvAe8q+tPmEvqeigveqMeyH
         Fk+GqjDXXRo4Kk7op4oqUR/8WreYU+ISC58uWyas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 31/86] net: usb: qmi_wwan: add support for Quectel EG95 LTE modem
Date:   Mon, 20 Jul 2020 17:36:27 +0200
Message-Id: <20200720152754.727800608@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

[ Upstream commit f815dd5cf48b905eeecf0a2b990e9b7ab048b4f1 ]

Add support for Quectel Wireless Solutions Co., Ltd. EG95 LTE modem

T:  Bus=01 Lev=01 Prnt=01 Port=02 Cnt=02 Dev#=  5 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0195 Rev=03.18
S:  Manufacturer=Android
S:  Product=Android
C:  #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -962,6 +962,7 @@ static const struct usb_device_id produc
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0125, 4)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
+	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
 	{QMI_FIXED_INTF(0x2c7c, 0x0296, 4)},	/* Quectel BG96 */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0306, 4)},	/* Quectel EP06 Mini PCIe */
 


