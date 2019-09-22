Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53277BA3E2
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389312AbfIVSpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389303AbfIVSpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD8021907;
        Sun, 22 Sep 2019 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177930;
        bh=0UFRwrVqMUuMsxtnEtdiDjvOApLR5fVd8zynEbyvw2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zu8VAFTACDWe6HNo8cWSkqJ0GTpwunY1+WLepmq9Wn7WGwcRlEjQWATxwQT5Sz8VE
         fRNEPJkwZ7EHvyQjWeBeqg3sOW+lWC0vzX+BCZUYpmS+JIwnbUMLyjdr9wXqVCdFDo
         ZvGG9eaJ7vQcL0VnnY5VTwPzdIpQxuWq4XJk5O5g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 041/203] gpio: madera: Add support for Cirrus Logic CS47L92
Date:   Sun, 22 Sep 2019 14:41:07 -0400
Message-Id: <20190922184350.30563-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 74d2d0e68701bcd53d2cf771dd3b3cb9f84bed5c ]

As the gpio is common to all madera codecs all that is needed
is to setup the correct number of GPIO pins for the CS47L92.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20190722090748.20807-4-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-madera.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpio/gpio-madera.c b/drivers/gpio/gpio-madera.c
index 19db5a500eb0d..be963113f6722 100644
--- a/drivers/gpio/gpio-madera.c
+++ b/drivers/gpio/gpio-madera.c
@@ -150,6 +150,11 @@ static int madera_gpio_probe(struct platform_device *pdev)
 	case CS47L91:
 		madera_gpio->gpio_chip.ngpio = CS47L90_NUM_GPIOS;
 		break;
+	case CS42L92:
+	case CS47L92:
+	case CS47L93:
+		madera_gpio->gpio_chip.ngpio = CS47L92_NUM_GPIOS;
+		break;
 	default:
 		dev_err(&pdev->dev, "Unknown chip variant %d\n", madera->type);
 		return -EINVAL;
-- 
2.20.1

