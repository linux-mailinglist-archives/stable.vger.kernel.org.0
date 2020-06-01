Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9B31EAEC3
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgFASAc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgFASAa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E54D2065C;
        Mon,  1 Jun 2020 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034429;
        bh=PkdW5MIE/xVsJ3P/RLDQdhXyZozb/Kq6uznN5go3Yag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bk3XEIBLbD7hd/zMZOsD/zh6ohXmeY6hknfnuiPke8ltnlu47ktRJXOTJ7E2QGm/k
         NpfKi4pzdgS16n33M4JboiF9ERAUELSYMlvV2dGBZgHQ2EIDFhLyhnF7k9IKvGC5FL
         uygLrsGQs2DlEROD2m3LFF7+RNWdxUc2GMllbMas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/77] Input: dlink-dir685-touchkeys - fix a typo in driver name
Date:   Mon,  1 Jun 2020 19:53:33 +0200
Message-Id: <20200601174021.628862977@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
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
index 88e321b76397..6fe4062e3ac2 100644
--- a/drivers/input/keyboard/dlink-dir685-touchkeys.c
+++ b/drivers/input/keyboard/dlink-dir685-touchkeys.c
@@ -142,7 +142,7 @@ MODULE_DEVICE_TABLE(of, dir685_tk_of_match);
 
 static struct i2c_driver dir685_tk_i2c_driver = {
 	.driver = {
-		.name	= "dlin-dir685-touchkeys",
+		.name	= "dlink-dir685-touchkeys",
 		.of_match_table = of_match_ptr(dir685_tk_of_match),
 	},
 	.probe		= dir685_tk_probe,
-- 
2.25.1



