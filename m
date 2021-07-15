Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA73CA938
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbhGOTFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239608AbhGOTEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:04:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0658F6140C;
        Thu, 15 Jul 2021 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375640;
        bh=HDtToeUWPZsFEOlPRMfiW8xFcEzbc6m4na45d4HkCJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gR6+6DuC782gkTA69XNjLxuAMWHgXe5c5x0PU9FPCmljI7a2pcrHzLZ1VYVw+xKOn
         4G+tHCCuzo4at5hXtgQqr/T+NUpkYvUNrF/A0zjpB/vdvdUZB0lSKhlz0Q6jNOBR6e
         8TvKjtywHWQC6WpsLA13TiUiwNflyZdeK/zSUNak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachi King <nakato@nakato.io>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.12 174/242] pinctrl/amd: Add device HID for new AMD GPIO controller
Date:   Thu, 15 Jul 2021 20:38:56 +0200
Message-Id: <20210715182623.858675726@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit 1ca46d3e43569186bd1decfb02a6b4c4ddb4304b upstream.

Add device HID AMDI0031 to the AMD GPIO controller driver match table.
This controller can be found on Microsoft Surface Laptop 4 devices and
seems similar enough that we can just copy the existing AMDI0030 entry.

Cc: <stable@vger.kernel.org> # 5.10+
Tested-by: Sachi King <nakato@nakato.io>
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20210512210316.1982416-1-luzmaximilian@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -991,6 +991,7 @@ static int amd_gpio_remove(struct platfo
 static const struct acpi_device_id amd_gpio_acpi_match[] = {
 	{ "AMD0030", 0 },
 	{ "AMDI0030", 0},
+	{ "AMDI0031", 0},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, amd_gpio_acpi_match);


