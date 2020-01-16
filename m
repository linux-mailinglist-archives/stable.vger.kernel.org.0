Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 606C713EA36
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393876AbgAPRnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393862AbgAPRnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:43:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCCAE24718;
        Thu, 16 Jan 2020 17:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196585;
        bh=lUlCwCexTDZ3NR5DpiFBuA6C6iX4HlYozf/mvEvlh3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gn8jDO7tK8qCN8K8umtt1Y++z2tyFGfcfcTTjtAosjyWRuRLNqmT/7GnKeKxrZ/BY
         +I/25Zj1FU7ZqiQl/K2NJymKYKNzhifHYIJ9PZ3AB4ag8vRSCMNqJasecTSSTRpKuZ
         DZbg8vCPxUu5+0TpJzroSiV+F3JRuYqY2ttTGMR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 010/174] pinctrl: sh-pfc: r8a7740: Add missing LCD0 marks to lcd0_data24_1 group
Date:   Thu, 16 Jan 2020 12:40:07 -0500
Message-Id: <20200116174251.24326-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 96bb2a6ab4eca10e5b6490b3f0738e9f7ec22c2b ]

The lcd0_data24_1_pins[] array contains the LCD0 D1[2-5] pin numbers,
but the lcd0_data24_1_mux[] array lacks the corresponding pin marks.

Fixes: 06c7dd866da70f6c ("sh-pfc: r8a7740: Add LCDC0 and LCDC1 pin groups and functions")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7740.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
index aa7c346dff6d..bc2ee07fa92f 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
@@ -2155,6 +2155,7 @@ static const unsigned int lcd0_data24_1_mux[] = {
 	LCD0_D0_MARK, LCD0_D1_MARK, LCD0_D2_MARK, LCD0_D3_MARK,
 	LCD0_D4_MARK, LCD0_D5_MARK, LCD0_D6_MARK, LCD0_D7_MARK,
 	LCD0_D8_MARK, LCD0_D9_MARK, LCD0_D10_MARK, LCD0_D11_MARK,
+	LCD0_D12_MARK, LCD0_D13_MARK, LCD0_D14_MARK, LCD0_D15_MARK,
 	LCD0_D16_MARK, LCD0_D17_MARK, LCD0_D18_PORT163_MARK,
 	LCD0_D19_PORT162_MARK, LCD0_D20_PORT161_MARK, LCD0_D21_PORT158_MARK,
 	LCD0_D22_PORT160_MARK, LCD0_D23_PORT159_MARK,
-- 
2.20.1

