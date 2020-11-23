Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220002C07D5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgKWMol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733241AbgKWMoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D417221534;
        Mon, 23 Nov 2020 12:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135477;
        bh=hI9u3+G2UlPDYSrs1NXPOVquhZe6DrKAWN8lch3QiJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOlVGyv9s/M34KNLXrvN2WXAOz2GaE5NxPVkhdw+f+kY6YgQZq9ne4vgvOd+OcxQF
         DfR6LxNUo2xPWrojAM/L2XZpbHL6/FUZcSsbgTCwHTpDwCLqWBdbpQ5dBYH/evB2v0
         41HZEeOZU/CwTkVrJo84CvomFbJeBbRy+BBZxc/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filip Moc <dev@moc6.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 053/252] net: usb: qmi_wwan: Set DTR quirk for MR400
Date:   Mon, 23 Nov 2020 13:20:03 +0100
Message-Id: <20201123121838.148275444@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filip Moc <dev@moc6.cz>

[ Upstream commit df8d85d8c69d6837817e54dcb73c84a8b5a13877 ]

LTE module MR400 embedded in TL-MR6400 v4 requires DTR to be set.

Signed-off-by: Filip Moc <dev@moc6.cz>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20201117173631.GA550981@moc6.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1092,7 +1092,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
 	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
-	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE  (China Mobile) */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE (China Mobile) */
 	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
 	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)},


