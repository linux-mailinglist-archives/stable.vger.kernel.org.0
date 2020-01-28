Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EDE14B6BD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgA1OHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgA1OHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:07:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA8022522;
        Tue, 28 Jan 2020 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220459;
        bh=2hFrrx/DS7TzgvF22Xr5ZQqJGWQoXFcLYIohIHSILRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgAz8bVYZYqqUubu27H68rAKNypQPMd4UFPnvDQvdvL2bvG3cteSqyIAOSo4iLV8M
         AJUl1rlJlaYv2FNGJpwEJC9XqSSiyXahSe9Ny9K4vhtB4S52YzGUqgi7IAvlyh3Dln
         1MIQYZoHdQhd/ZYZmUlEfZ9eTIp9x2qgs3YBf9FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 016/183] pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
Date:   Tue, 28 Jan 2020 15:03:55 +0100
Message-Id: <20200128135831.446347639@linuxfoundation.org>
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

[ Upstream commit 6a6c195d98a1a5e70faa87f594d7564af1dd1bed ]

The Peripheral Function Select Register 9 contains 12 fields, but the
variable field descriptor contains a 13th bogus field of 3 bits.

Fixes: 43c4436e2f1890a7 ("pinctrl: sh-pfc: add R8A7794 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7794.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7794.c b/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
index 086f6798b1294..3b79e893b5ed3 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
@@ -4046,7 +4046,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		FN_AVB_MDC, FN_SSI_SDATA6_B, 0, 0, }
 	},
 	{ PINMUX_CFG_REG_VAR("IPSR9", 0xE6060044, 32,
-			     1, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3) {
+			     1, 3, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3) {
 		/* IP9_31 [1] */
 		0, 0,
 		/* IP9_30_28 [3] */
-- 
2.20.1



