Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56A2D1383
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGOYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbgLGOYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 09:24:41 -0500
Subject: patch "usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607351034;
        bh=wO2+5+/UznH+aqisTjmhrv/MSX/YoqA7/Pt76MkH25k=;
        h=To:From:Date:From;
        b=JKOBzmPwcfJxxNn8nLjVqgepOU3QZBPmtPqxOABshSN2oA3c9/MdbI/zvEBKjkBRY
         a5C7Bg0FI/krkEzQOFtme3sVIXTEkmEzNp7Ss4wJGMe2ZGP4L0dkx0FgsDqh4P46qj
         42RRkUvDeI/gnIWBRY1vzrYefX8JW2sRdACrWmBY=
To:     festevam@gmail.com, gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Dec 2020 15:24:57 +0100
Message-ID: <160735109789206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From c7721e15f434920145c376e8fe77e1c079fc3726 Mon Sep 17 00:00:00 2001
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 7 Dec 2020 10:09:09 +0800
Subject: usb: chipidea: ci_hdrc_imx: Pass DISABLE_DEVICE_STREAMING flag to
 imx6ul

According to the i.MX6UL Errata document:
https://www.nxp.com/docs/en/errata/IMX6ULCE.pdf

ERR007881 also affects i.MX6UL, so pass the
CI_HDRC_DISABLE_DEVICE_STREAMING flag to workaround the issue.

Fixes: 52fe568e5d71 ("usb: chipidea: imx: add imx6ul usb support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201207020909.22483-2-peter.chen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 25c65accf089..5e07a0a86d11 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -57,7 +57,8 @@ static const struct ci_hdrc_imx_platform_flag imx6sx_usb_data = {
 
 static const struct ci_hdrc_imx_platform_flag imx6ul_usb_data = {
 	.flags = CI_HDRC_SUPPORTS_RUNTIME_PM |
-		CI_HDRC_TURN_VBUS_EARLY_ON,
+		CI_HDRC_TURN_VBUS_EARLY_ON |
+		CI_HDRC_DISABLE_DEVICE_STREAMING,
 };
 
 static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {
-- 
2.29.2


