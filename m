Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF6E33BAC5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhCOOKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233781AbhCOOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EED664DAD;
        Mon, 15 Mar 2021 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816946;
        bh=TdUoMvo2H0GDPyoDwerfi7adSNUUcIwNIB/j/sYxhY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeKyr83Sb/AZVSCukaJzsS8XzB13lEL+lxG3qsaNWQaLKf8qTWVVFARqPVWevaf3a
         hLPFiA8mP4gS29y5uE6XUrG9oA/6VA4CmieUE0UBtb7a2ZYn8t3oJHRfx1HqwMUSjk
         SfHVY3KtdvhT44Xijunt2zWYXVrOqNOrYWUYJq6I=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5.10 204/290] usb: dwc3: qcom: add ACPI device id for sc8180x
Date:   Mon, 15 Mar 2021 14:54:57 +0100
Message-Id: <20210315135548.817625315@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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


