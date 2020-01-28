Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0114B6BF
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgA1OHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgA1OHp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:07:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE7424688;
        Tue, 28 Jan 2020 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220464;
        bh=xmqf4R/yqaxyn6B/aXLkj6ePZROjIT/6cr9njFDMExI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15M8xqYm3jZ/NNJ5LaoieOsf7fr0yiHbkCG6GCvDOA9EU+oct2VAZ7U7VBjcOPS9Q
         wYGvyvudVH1FuvZXtjTPk5e/gs9Go5bbVTxeRAB1v9Jd+R21+NTvcxVg6o8HmVwaVT
         tZSeDRdtbKi3uGHPpUHO0/m2lfs0L+gOkPoti1MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 018/183] pinctrl: sh-pfc: sh7269: Add missing PCIOR0 field
Date:   Tue, 28 Jan 2020 15:03:57 +0100
Message-Id: <20200128135831.686680043@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
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



