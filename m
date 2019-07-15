Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5237694C7
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391530AbfGOO3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:29:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391533AbfGOO3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:29:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7611F205ED;
        Mon, 15 Jul 2019 14:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200955;
        bh=vw/g7f5Dkswi3MkMzI2mORVT3SBrOgShtQ0N7nacFPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFzp3jUZfWxcRp9kWTzRmkfLVida6ncr1CTL6+YcRdQkD2GC1Vhg/Vlgt6Athi4xQ
         VjQ67gRsRft0MphUDxEr2tbaa4sUfoCu03iYthicAIwE3ofG2JERK4yOlDCy+hmxvi
         HsiGZIlIdKnEoCU4ZgS+zATs+Tn7SiQ/LIcDpmtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Gomez <dagmcr@gmail.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 009/105] media: spi: IR LED: add missing of table registration
Date:   Mon, 15 Jul 2019 10:27:03 -0400
Message-Id: <20190715142839.9896-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Gomez <dagmcr@gmail.com>

[ Upstream commit 24e4cf770371df6ad49ed873f21618d9878f64c8 ]

MODULE_DEVICE_TABLE(of, <of_match_table> should be called to complete DT
OF mathing mechanism and register it.

Before this patch:
modinfo drivers/media/rc/ir-spi.ko  | grep alias

After this patch:
modinfo drivers/media/rc/ir-spi.ko  | grep alias
alias:          of:N*T*Cir-spi-ledC*
alias:          of:N*T*Cir-spi-led

Reported-by: Javier Martinez Canillas <javier@dowhile0.org>
Signed-off-by: Daniel Gomez <dagmcr@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index 29ed0638cb74..cbe585f95715 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -186,6 +186,7 @@ static const struct of_device_id ir_spi_of_match[] = {
 	{ .compatible = "ir-spi-led" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ir_spi_of_match);
 
 static struct spi_driver ir_spi_driver = {
 	.probe = ir_spi_probe,
-- 
2.20.1

