Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85402C0612
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgKWM1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:27:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730264AbgKWM1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:27:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854872076E;
        Mon, 23 Nov 2020 12:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134434;
        bh=GREe4+dIe5+PgkEen7fAPcgRYBz5qrxYPEAp7Km37kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwnnrGUg/fFj3XbAysfRJld3SltSatQ1LY+Nq4KCms0A1n+8mPxmEz2F9rEQ2KBzH
         REdAHJsxgYL/3hKbquKH8pfOCRBF510XUveIW8JHP01gIITn14iDmZE7vEbg3wwTTm
         AMxhX1yDvx4ihyX7oGbecxKpWFzQYWBuMphdFYAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filip Moc <dev@moc6.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 18/60] net: usb: qmi_wwan: Set DTR quirk for MR400
Date:   Mon, 23 Nov 2020 13:22:00 +0100
Message-Id: <20201123121805.900880334@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.028396732@linuxfoundation.org>
References: <20201123121805.028396732@linuxfoundation.org>
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
@@ -1029,7 +1029,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x05c6, 0x9011, 4)},
 	{QMI_FIXED_INTF(0x05c6, 0x9021, 1)},
 	{QMI_FIXED_INTF(0x05c6, 0x9022, 2)},
-	{QMI_FIXED_INTF(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE  (China Mobile) */
+	{QMI_QUIRK_SET_DTR(0x05c6, 0x9025, 4)},	/* Alcatel-sbell ASB TL131 TDD LTE (China Mobile) */
 	{QMI_FIXED_INTF(0x05c6, 0x9026, 3)},
 	{QMI_FIXED_INTF(0x05c6, 0x902e, 5)},
 	{QMI_FIXED_INTF(0x05c6, 0x9031, 5)},


