Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB37B1D0F35
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732653AbgEMJqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732649AbgEMJqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D6423128;
        Wed, 13 May 2020 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363191;
        bh=I0TmloKQ6w6s4+E/SMRj3wAX70TDF9lXgtII0GZLDBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQ2sbRWP0G0AErFv+p39HDJvNwyB7cVDMLXTslrdfRIDOj1frBKWkEQhzLOLfImp0
         8m7KCGlejxRaFuB6laii/aundtSXWLJXCT6uZR7XyYEyyeQZpmKuDwYb3cFzajXKDL
         mxTBSyVjej+oChJKd6fpA1OXuhPhLbYVUARa8ErM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Jolly <Kangie@footclan.ninja>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/48] net: usb: qmi_wwan: add support for DW5816e
Date:   Wed, 13 May 2020 11:44:35 +0200
Message-Id: <20200513094354.213038007@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Jolly <Kangie@footclan.ninja>

[ Upstream commit 57c7f2bd758eed867295c81d3527fff4fab1ed74 ]

Add support for Dell Wireless 5816e to drivers/net/usb/qmi_wwan.c

Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1294,6 +1294,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x413c, 0x81b3, 8)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 8)},	/* Dell Wireless 5811e */
 	{QMI_FIXED_INTF(0x413c, 0x81b6, 10)},	/* Dell Wireless 5811e */
+	{QMI_FIXED_INTF(0x413c, 0x81cc, 8)},	/* Dell Wireless 5816e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 0)},	/* Dell Wireless 5821e */
 	{QMI_FIXED_INTF(0x413c, 0x81d7, 1)},	/* Dell Wireless 5821e preproduction config */
 	{QMI_FIXED_INTF(0x413c, 0x81e0, 0)},	/* Dell Wireless 5821e with eSIM support*/


