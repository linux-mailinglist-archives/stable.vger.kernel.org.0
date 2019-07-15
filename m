Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17168AE1
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfGONhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730263AbfGONhk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:37:40 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DBE32080A;
        Mon, 15 Jul 2019 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197858;
        bh=VRgrytHTVCFlT5csoh3aKEF0uzbhluzYmPoRtKfok/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYJK2+OXZni6MbammLA6D47NZ6ig9ebOA1ax/FiMAr9M58WWQAfmdCNn8oJeK2bbC
         5mgPtC43dxyzgiVN4Eoqul2R/NqAOfwSFd6jr/8Uu2ITSJRcRra9ltMDrFslrYDn3l
         yoV4Fvs6cbbz/v4gukBWqW7DAvu4vTfuQLXiYeyA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Gomez <dagmcr@gmail.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 020/249] media: spi: IR LED: add missing of table registration
Date:   Mon, 15 Jul 2019 09:32:01 -0400
Message-Id: <20190715133550.1772-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133550.1772-1-sashal@kernel.org>
References: <20190715133550.1772-1-sashal@kernel.org>
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
index 66334e8d63ba..c58f2d38a458 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -161,6 +161,7 @@ static const struct of_device_id ir_spi_of_match[] = {
 	{ .compatible = "ir-spi-led" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ir_spi_of_match);
 
 static struct spi_driver ir_spi_driver = {
 	.probe = ir_spi_probe,
-- 
2.20.1

