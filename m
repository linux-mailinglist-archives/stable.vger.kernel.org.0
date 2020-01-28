Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7674A14BAB2
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgA1OPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbgA1OPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A57C2468D;
        Tue, 28 Jan 2020 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220932;
        bh=qBUsJZlTkUT/fDnIwYTUtqZR2Jfqzu7HRsoZekMt2OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKSPSq4bboxVM95Jt8qQ2jERenioP+8gim0au5ey1tWBASd+1TaJXRNVXTKfd3ftc
         YVFbagq3RlmBaaQRw4LF020bO4MdPtknYzwu31OHyD2GoLdb2Uwhsia67z3jaZo7T4
         cf/x8IjwxsjDS1A/J+Txmd2W502uFdqSp8n8SK+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 021/271] pinctrl: sh-pfc: r8a7794: Remove bogus IPSR9 field
Date:   Tue, 28 Jan 2020 15:02:50 +0100
Message-Id: <20200128135854.248066552@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index ef093ac0cf2fb..fe8c9c24634d8 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7794.c
@@ -4826,7 +4826,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
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



