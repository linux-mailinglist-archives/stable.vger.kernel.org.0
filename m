Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0526E2C0576
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgKWMWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729339AbgKWMWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:22:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 944552076E;
        Mon, 23 Nov 2020 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134163;
        bh=VSQjcOFuD0hkmHmQgGU4s70I31pVYEZ89NgxhROrHbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V98l0jPM3LlanFgY2fg+eQPAm0UxZK3a0sdVi4RII/IBAljCVDXF1s0iLyJYdcUf/
         8Zu0GMUhdmeCEzAmT2+naVHb5XlL2swv0EXaXi4GQKY6yew+HN5h2VyQst3+nzYpj1
         mONr7HKINqMd9a6Ouko3Zi6nmeI/YUhYU9xHvI7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filip Moc <dev@moc6.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 11/38] net: usb: qmi_wwan: Set DTR quirk for MR400
Date:   Mon, 23 Nov 2020 13:21:57 +0100
Message-Id: <20201123121804.855290783@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
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
@@ -702,7 +702,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
 	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
-	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE  (China Mobile) */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE (China Mobile) */
 	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
 	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)},


