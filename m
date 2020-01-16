Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5E213F6ED
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387994AbgAPRBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:01:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732843AbgAPRBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4766E24679;
        Thu, 16 Jan 2020 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194064;
        bh=xTh3euvaVVF5AgmqiVdq5sDTR7kmFZgmADYOgqlF4xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGek7LsJNc3Ry5COhP05OQ2nSo1uIJyy3rKt70WtSXabgHcFq3aV0qQ8sH11MdJ4n
         kf1VHZmgJasaPBh/ub9/UOtwdL1pMGFERnSdVznOXkqM3lMYXNdEXMbnhVPVZsZ0w1
         eHzFAFvgSygNPsV49/bZn6URRF7i1C6PY+ymG2eU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 175/671] pinctrl: sh-pfc: r8a7791: Fix scifb2_data_c pin group
Date:   Thu, 16 Jan 2020 11:51:24 -0500
Message-Id: <20200116165940.10720-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a4b0350047f1b10207e25e72d7cd3f7826e93769 ]

The entry for "scifb2_data_c" in the SCIFB2 pin group array contains a
typo, thus the group cannot be selected.

Fixes: 5088451962389924 ("pinctrl: sh-pfc: r8a7791 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
index 6236ac55c65d..9eb860c8f917 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
@@ -5239,7 +5239,7 @@ static const char * const scifb2_groups[] = {
 	"scifb2_data_b",
 	"scifb2_clk_b",
 	"scifb2_ctrl_b",
-	"scifb0_data_c",
+	"scifb2_data_c",
 	"scifb2_clk_c",
 	"scifb2_data_d",
 };
-- 
2.20.1

