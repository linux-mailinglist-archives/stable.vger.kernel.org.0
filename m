Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70177147BCD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgAXJq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbgAXJqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:46:25 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A716A22522;
        Fri, 24 Jan 2020 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859185;
        bh=xmqf4R/yqaxyn6B/aXLkj6ePZROjIT/6cr9njFDMExI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evXpDkCfIHyxiJByG90tvEco44OMkbhqtD9rd5+8hzIG8ScR53k9yqiyc/Cdvk7ZL
         IKW87C+qA6N9Pqz9XOu8E7naKuEg1Lh8fo30COtaaG8xHo5jyQA64AgvFS1AKXukdl
         Etaawt1Auyhl7vfi7HpB2Ok2ZSlHMq9J/0heQScQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 039/343] pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
Date:   Fri, 24 Jan 2020 10:27:37 +0100
Message-Id: <20200124092924.949560221@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a50d22bef1f44..cfdb4fc177c3e 100644
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



