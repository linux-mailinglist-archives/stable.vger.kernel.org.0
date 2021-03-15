Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2865133B9E8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhCOOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233530AbhCOOB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D0CD64F2B;
        Mon, 15 Mar 2021 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816916;
        bh=TdUoMvo2H0GDPyoDwerfi7adSNUUcIwNIB/j/sYxhY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A76y2s90lb8ahwjZKg3pbzH49xBvibvYDb4ThHOxnV5WtAxWdXSkgO+thkfrjTnWt
         0u5qAScPfVGwkuai8Lh/8QNStPkgzF84g2q3e/tS6uaTLyhBguswmIyQnO6YsuLq4D
         A0pVNJIJG28I6kDCAvS49XELzWpwEZnrBeB6R7pM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5.11 200/306] usb: dwc3: qcom: add ACPI device id for sc8180x
Date:   Mon, 15 Mar 2021 14:54:23 +0100
Message-Id: <20210315135514.396961452@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shawn Guo <shawn.guo@linaro.org>

commit 1edbff9c80ed32071fffa7dbaaea507fdb21ff2d upstream.

It enables USB Host support for sc8180x ACPI boot, both the standalone
one and the one behind URS (USB Role Switch).  And they share the
the same dwc3_acpi_pdata with sdm845.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Link: https://lore.kernel.org/r/20210301075745.20544-1-shawn.guo@linaro.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -935,6 +935,8 @@ static const struct dwc3_acpi_pdata sdm8
 static const struct acpi_device_id dwc3_qcom_acpi_match[] = {
 	{ "QCOM2430", (unsigned long)&sdm845_acpi_pdata },
 	{ "QCOM0304", (unsigned long)&sdm845_acpi_urs_pdata },
+	{ "QCOM0497", (unsigned long)&sdm845_acpi_urs_pdata },
+	{ "QCOM04A6", (unsigned long)&sdm845_acpi_pdata },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dwc3_qcom_acpi_match);


