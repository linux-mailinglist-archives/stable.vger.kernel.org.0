Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF33B15C3CC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgBMPo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgBMP1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E039D218AC;
        Thu, 13 Feb 2020 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607660;
        bh=/cBsV2+fZ3tqujiRAUL+RNTm5GPLITKuiZjrgCkDibY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+LI80x7liCmpWwtPM1VYnBh6iGP9e7GSk/rqRX6E6YWQVDAlXbeLOwR/cMOILnLY
         ChqqfH60iBVK8WKp3FwQ/8d0bkYuZGHK1jU9sT+9wQmWWRKqGNs5xB8zx9M+baOA9o
         DYXGIN3/EhFBzMnhJi2pbHYICN7MQPeAq85BiyHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 60/96] ARM: at91: pm: use SAM9X60 PMCs compatible
Date:   Thu, 13 Feb 2020 07:21:07 -0800
Message-Id: <20200213151902.191896192@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 6b9dfd986a81a999a27b6ed9dbe91203089c62dd upstream.

SAM9X60 PMC's has a different PMC. It was not integrated at the moment
commit 01c7031cfa73 ("ARM: at91: pm: initial PM support for SAM9X60")
was published.

Fixes: 01c7031cfa73 ("ARM: at91: pm: initial PM support for SAM9X60")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/1576062248-18514-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -751,6 +751,7 @@ static const struct of_device_id atmel_p
 	{ .compatible = "atmel,sama5d3-pmc", .data = &pmc_infos[1] },
 	{ .compatible = "atmel,sama5d4-pmc", .data = &pmc_infos[1] },
 	{ .compatible = "atmel,sama5d2-pmc", .data = &pmc_infos[1] },
+	{ .compatible = "microchip,sam9x60-pmc", .data = &pmc_infos[1] },
 	{ /* sentinel */ },
 };
 


