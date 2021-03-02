Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F072B32AED6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbhCCAGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837222AbhCBHkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 02:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D21D614A7;
        Tue,  2 Mar 2021 07:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614670798;
        bh=g6pdjLMjVTGS9SiLiykgzExBiBmxkTxyDwSNXu1+1cY=;
        h=Subject:To:From:Date:From;
        b=Ocw5rcE6PaGz44PjxTe06XFyMRN7mn8Ltwg83a4Bn3lIjTz21xV5mfd0QUKpReo2W
         TPUkEm9x+UuO+li6UNKVhAbQEaoPuny2cUBAy28b6QW+qc+ulrXl/+OmxACzJy/5wk
         5CAbTIKm50h655SzYRyOnChixCtVJMsXqFTwRLJQ=
Subject: patch "usb: dwc3: qcom: add ACPI device id for sc8180x" added to usb-linus
To:     shawn.guo@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 08:39:45 +0100
Message-ID: <161467078520223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: qcom: add ACPI device id for sc8180x

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1016ecc84404411e39849cfc0d8b6f77cb1a8c96 Mon Sep 17 00:00:00 2001
From: Shawn Guo <shawn.guo@linaro.org>
Date: Mon, 1 Mar 2021 15:57:45 +0800
Subject: usb: dwc3: qcom: add ACPI device id for sc8180x

It enables USB Host support for sc8180x ACPI boot, both the standalone
one and the one behind URS (USB Role Switch).  And they share the
the same dwc3_acpi_pdata with sdm845.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210301075745.20544-1-shawn.guo@linaro.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 846a47be6df7..d8850f9ccb62 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -938,6 +938,8 @@ static const struct dwc3_acpi_pdata sdm845_acpi_urs_pdata = {
 static const struct acpi_device_id dwc3_qcom_acpi_match[] = {
 	{ "QCOM2430", (unsigned long)&sdm845_acpi_pdata },
 	{ "QCOM0304", (unsigned long)&sdm845_acpi_urs_pdata },
+	{ "QCOM0497", (unsigned long)&sdm845_acpi_urs_pdata },
+	{ "QCOM04A6", (unsigned long)&sdm845_acpi_pdata },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dwc3_qcom_acpi_match);
-- 
2.30.1


