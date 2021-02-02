Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53C530CC7D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbhBBT5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhBBNtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:49:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A335864FA5;
        Tue,  2 Feb 2021 13:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273349;
        bh=T9Hf7ivZqahFKEJ/A72jXDc5IHq0kcMzevtOZgoUtxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoEXU+/zvPvxVtfVyBJVyO/dFKca+KLDFiotdsJHHnIsPbaDptHpOjb1/HbozDdVA
         hHcgIeg/1/09AMwcgA5nThQvYor7V1VfK6MH2S4EEbGtSf+/bppG9/y9a5VN2jqSPM
         8xohJvJj6nEBEhbrthIgkJoTom41e5kDL5e6GK1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 072/142] clk: qcom: gcc-sm250: Use floor ops for sdcc clks
Date:   Tue,  2 Feb 2021 14:37:15 +0100
Message-Id: <20210202133000.695917202@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit fd2383093593b23f8814a879093b746e502fe3cf upstream.

Followup to the commits 5e4b7e82d497 ("clk: qcom: gcc-sdm845: Use floor
ops for sdcc clks") and 6d37a8d19283 ("clk: qcom: gcc-sc7180: Use floor ops
for sdcc clks"). Use floor ops for sdcc clocks on sm8250.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 3e5770921a88 ("clk: qcom: gcc: Add global clock controller driver for SM8250")
Link: https://lore.kernel.org/r/20210109013314.3443134-1-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/clk/qcom/gcc-sm8250.c b/drivers/clk/qcom/gcc-sm8250.c
index 6cb6617b8d88..ab594a0f0c40 100644
--- a/drivers/clk/qcom/gcc-sm8250.c
+++ b/drivers/clk/qcom/gcc-sm8250.c
@@ -722,7 +722,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_4,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
@@ -745,7 +745,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.name = "gcc_sdcc4_apps_clk_src",
 		.parent_data = gcc_parent_data_0,
 		.num_parents = 3,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 


