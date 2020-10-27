Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E71229B51F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753874AbgJ0PIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793773AbgJ0PIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141D7206E5;
        Tue, 27 Oct 2020 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811294;
        bh=9Z0BV+pcPEXz15ht+CDhxkr4zW1ipdYLTDkJG9TligU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzePP7E37GFRWE1s3NXvk9rps+p6Dl8cWd5aTn2V6NIKyZsk+BK5+I7L2uOc1n80x
         VCjN3Bh1KMKQKr5VJ5UIfH5c7NI8Ekevm9WZM95DPPhaPgNPkTIaVBiOlXJB4UQtPU
         qTUP7OOKcKy52U5canPxxyr4TmAwRvmrYtA9gjOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Dubrova <pashadubrova@gmail.com>,
        Konrad Dybcio <konradybcio@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 441/633] clk: qcom: gcc-sdm660: Fix wrong parent_map
Date:   Tue, 27 Oct 2020 14:53:04 +0100
Message-Id: <20201027135543.407232702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konradybcio@gmail.com>

[ Upstream commit d46e5a39f9be9288f1ce2170c4c7f8098f4e7f68 ]

This was likely overlooked while porting the driver upstream.

Reported-by: Pavel Dubrova <pashadubrova@gmail.com>
Signed-off-by: Konrad Dybcio <konradybcio@gmail.com>
Link: https://lore.kernel.org/r/20200922120909.97203-1-konradybcio@gmail.com
Fixes: f2a76a2955c0 ("clk: qcom: Add Global Clock controller (GCC) driver for SDM660")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdm660.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sdm660.c b/drivers/clk/qcom/gcc-sdm660.c
index c6fb57cd576f5..aa5c0c6ead017 100644
--- a/drivers/clk/qcom/gcc-sdm660.c
+++ b/drivers/clk/qcom/gcc-sdm660.c
@@ -666,7 +666,7 @@ static struct clk_rcg2 hmss_rbcpr_clk_src = {
 	.cmd_rcgr = 0x48044,
 	.mnd_width = 0,
 	.hid_width = 5,
-	.parent_map = gcc_parent_map_xo_gpll0_gpll0_early_div,
+	.parent_map = gcc_parent_map_xo_gpll0,
 	.freq_tbl = ftbl_hmss_rbcpr_clk_src,
 	.clkr.hw.init = &(struct clk_init_data){
 		.name = "hmss_rbcpr_clk_src",
-- 
2.25.1



