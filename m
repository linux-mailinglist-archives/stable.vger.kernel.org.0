Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F643C46C1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhGLG2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234955AbhGLG10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:27:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FB9661152;
        Mon, 12 Jul 2021 06:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071034;
        bh=i8CzK8ObrvpyI+ItGzz9pJXh8KLm3bynwTtVNiJGijw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dhcjoai1gBiG82M4Qf74qnahxqIMzZGCtWmrqCvJZsu52uNynILf2LIK11vP+c5JQ
         4D011roxsC1gFJGLrzTnEo3c0bzBVx9XapKfJN6l8DDd8g4V3JXYN1OFxP/xL/teq9
         ROI2MFcS38UezCBXfhKVA6k+8Vhe2ICE168DOIzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 245/348] clk: actions: Fix SD clocks factor table on Owl S500 SoC
Date:   Mon, 12 Jul 2021 08:10:29 +0200
Message-Id: <20210712060735.151998618@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[ Upstream commit fe1f71e338d77814da3ef44e9f64d32981a6ccdf ]

Drop the unsupported entries in the factor table used for the SD[0-2]
clocks definitions on the Actions Semi Owl S500 SoC.

Fixes: ed6b4795ece4 ("clk: actions: Add clock driver for S500 SoC")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/196c948d708a22b8198c95f064a0f6b6820f9980.1623354574.git.cristian.ciocaltea@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/actions/owl-s500.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/actions/owl-s500.c b/drivers/clk/actions/owl-s500.c
index 6eeb7e290f40..d2396b2396ff 100644
--- a/drivers/clk/actions/owl-s500.c
+++ b/drivers/clk/actions/owl-s500.c
@@ -125,8 +125,7 @@ static struct clk_factor_table sd_factor_table[] = {
 	{ 12, 1, 13 }, { 13, 1, 14 }, { 14, 1, 15 }, { 15, 1, 16 },
 	{ 16, 1, 17 }, { 17, 1, 18 }, { 18, 1, 19 }, { 19, 1, 20 },
 	{ 20, 1, 21 }, { 21, 1, 22 }, { 22, 1, 23 }, { 23, 1, 24 },
-	{ 24, 1, 25 }, { 25, 1, 26 }, { 26, 1, 27 }, { 27, 1, 28 },
-	{ 28, 1, 29 }, { 29, 1, 30 }, { 30, 1, 31 }, { 31, 1, 32 },
+	{ 24, 1, 25 },
 
 	/* bit8: /128 */
 	{ 256, 1, 1 * 128 }, { 257, 1, 2 * 128 }, { 258, 1, 3 * 128 }, { 259, 1, 4 * 128 },
@@ -135,8 +134,7 @@ static struct clk_factor_table sd_factor_table[] = {
 	{ 268, 1, 13 * 128 }, { 269, 1, 14 * 128 }, { 270, 1, 15 * 128 }, { 271, 1, 16 * 128 },
 	{ 272, 1, 17 * 128 }, { 273, 1, 18 * 128 }, { 274, 1, 19 * 128 }, { 275, 1, 20 * 128 },
 	{ 276, 1, 21 * 128 }, { 277, 1, 22 * 128 }, { 278, 1, 23 * 128 }, { 279, 1, 24 * 128 },
-	{ 280, 1, 25 * 128 }, { 281, 1, 26 * 128 }, { 282, 1, 27 * 128 }, { 283, 1, 28 * 128 },
-	{ 284, 1, 29 * 128 }, { 285, 1, 30 * 128 }, { 286, 1, 31 * 128 }, { 287, 1, 32 * 128 },
+	{ 280, 1, 25 * 128 },
 	{ 0, 0, 0 },
 };
 
-- 
2.30.2



