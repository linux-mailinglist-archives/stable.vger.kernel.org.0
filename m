Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282161EAB4E
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgFASQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730605AbgFASQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:16:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CCB42068D;
        Mon,  1 Jun 2020 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035368;
        bh=/7RX4q6YYNqEWB3Wt5oaa6aB5Yf3G9syPTpSwvuEWRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1c868+0GPz9kXCqqIG3ffkpIUSbeXYk2BoPw6rGHUlUw0DoLQJ3JGJT7YF/wIJ+fe
         iC4V6n6+b3kxizhQ3a+rhI4RNRswo4X/kTbh8DFLsVZIYSXbVipZlHa0v5xELH+fN+
         m1lznCSKjDQDL2u+Y3zIuA5EFAm1G9lAK72x+6XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 088/177] Input: dlink-dir685-touchkeys - fix a typo in driver name
Date:   Mon,  1 Jun 2020 19:53:46 +0200
Message-Id: <20200601174056.207113223@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



