Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085B11F2C06
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgFIAT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730580AbgFHXSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53EE52086A;
        Mon,  8 Jun 2020 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658288;
        bh=/7RX4q6YYNqEWB3Wt5oaa6aB5Yf3G9syPTpSwvuEWRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvtlLc88u9Z9lSNVTxlewZQZqioj1j8GpQu3VkW+l3pm6C+GTEiwqljRxasWqIxLp
         XsMLHHBQRNAl16fIeXOZERNyIjAjmAFfi9eehwqR9Lro/bj8dZlyDTW+h6rDu1hefs
         NQNBIbPVDL1oVL/zQKUFGP1npSfJKMgAORH/QYNc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 292/606] Input: dlink-dir685-touchkeys - fix a typo in driver name
Date:   Mon,  8 Jun 2020 19:06:57 -0400
Message-Id: <20200608231211.3363633-292-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 38347374ae3f1ec4df56dd688bd603a64e79a0ed ]

According to the file name and Kconfig, a 'k' is missing in this driver
name. It should be "dlink-dir685-touchkeys".

Fixes: 131b3de7016b ("Input: add D-Link DIR-685 touchkeys driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20200412213937.5287-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/dlink-dir685-touchkeys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/dlink-dir685-touchkeys.c b/drivers/input/keyboard/dlink-dir685-touchkeys.c
index b0ead7199c40..a69dcc3bd30c 100644
--- a/drivers/input/keyboard/dlink-dir685-touchkeys.c
+++ b/drivers/input/keyboard/dlink-dir685-touchkeys.c
@@ -143,7 +143,7 @@ MODULE_DEVICE_TABLE(of, dir685_tk_of_match);
 
 static struct i2c_driver dir685_tk_i2c_driver = {
 	.driver = {
-		.name	= "dlin-dir685-touchkeys",
+		.name	= "dlink-dir685-touchkeys",
 		.of_match_table = of_match_ptr(dir685_tk_of_match),
 	},
 	.probe		= dir685_tk_probe,
-- 
2.25.1

