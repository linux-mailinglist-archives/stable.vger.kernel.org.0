Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60411C74AD
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 17:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbgEFP1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 11:27:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbgEFP1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 11:27:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C1472068E;
        Wed,  6 May 2020 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588778834;
        bh=xScnzIDvRD60xUyR/pyixQ1/r75Pu+K/MwlIc5PWwos=;
        h=Subject:To:From:Date:From;
        b=zmrCIaElO2xM1DxlAgi5RFhTCSmCUYRANcegBHzadvO50nNbvHqhLFASNln/zW54u
         /Ofj8RedetPpYPlUB+0i5U16oajQ4R9Vi/Fkw+nfx7xZar3SYuqsSMDLV3CuF0C3Oe
         qYBmZ/Od2Y9G09eUhpCo/WC5UkFx8rGOfZw0NmgU=
Subject: patch "USB: serial: qcserial: Add DW5816e support" added to usb-linus
To:     Kangie@footclan.ninja, johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 06 May 2020 17:27:04 +0200
Message-ID: <158877882415660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: qcserial: Add DW5816e support

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 78d6de3cfbd342918d31cf68d0d2eda401338aef Mon Sep 17 00:00:00 2001
From: Matt Jolly <Kangie@footclan.ninja>
Date: Sun, 3 May 2020 01:03:47 +1000
Subject: USB: serial: qcserial: Add DW5816e support

Add support for Dell Wireless 5816e to drivers/usb/serial/qcserial.c

Signed-off-by: Matt Jolly <Kangie@footclan.ninja>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/qcserial.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 613f91add03d..ce0401d3137f 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -173,6 +173,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d0)},   /* Dell Wireless 5819 */
 	{DEVICE_SWI(0x413c, 0x81d1)},   /* Dell Wireless 5818 */
-- 
2.26.2


