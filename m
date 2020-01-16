Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDEC213E91B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404931AbgAPRfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404922AbgAPRfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:35:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1FC246A9;
        Thu, 16 Jan 2020 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196112;
        bh=3asVv0LkAlodZ0h3jq+2rgSq3Ucakva943Q5z9tTdW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLPgPv7c0jFViSL0M39xfGN5Ip+ro5t6ykhJRpxUFWfZbXSo05DzROimNrsuHwVnZ
         ypC0tF6IccWRq/hmYWlFDZzkFk9IXvPLTxguCURNTBqfqBiQmW/a3RQY8ApRuShTB9
         DCOL4ilH7VGvFG9wDqRqQ0DEEklW39dC7rbtiTig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 021/251] pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
Date:   Thu, 16 Jan 2020 12:30:55 -0500
Message-Id: <20200116173445.21385-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173445.21385-1-sashal@kernel.org>
References: <20200116173445.21385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9540cbdfcd861caf67a6f0e4bb7f46d41c4aad86 ]

The Port C I/O Register 0 contains 7 reserved bits, but the descriptor
contains only dummy configuration values for 6 reserved bits, thus
breaking the configuration of all subsequent fields in the register.

Fix this by adding the two missing configuration values.

Fixes: f5e811f2a43117b2 ("sh-pfc: Add sh7269 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-sh7269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-sh7269.c b/drivers/pinctrl/sh-pfc/pfc-sh7269.c
index a50d22bef1f4..cfdb4fc177c3 100644
--- a/drivers/pinctrl/sh-pfc/pfc-sh7269.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7269.c
@@ -2119,7 +2119,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 	},
 
 	{ PINMUX_CFG_REG("PCIOR0", 0xfffe3852, 16, 1) {
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		PC8_IN, PC8_OUT,
 		PC7_IN, PC7_OUT,
 		PC6_IN, PC6_OUT,
-- 
2.20.1

