Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4216329BDAA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811932AbgJ0QoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801635AbgJ0PnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D063921D42;
        Tue, 27 Oct 2020 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813381;
        bh=5u0QsSsO8HLNYk9d368lhSjZux1qI0F77q5jPC/bNcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zm1FuVbIFf7dBpjs9WLUyjnVu9Er6QYF7DmWnWTk82RyJSlFIF2TZs2rxS6CA6gUb
         ve6wBc3IsFmgKWHVT0ao8ZoV5guWmfiTUPl0t5/HDNT56UxFDIxpIojYyEUHAFA0o9
         ETWkhfsk+nTF8rD1EvvDBj4wKFFRafsDsZXazG2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Dubrova <pashadubrova@gmail.com>,
        Konrad Dybcio <konradybcio@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 532/757] clk: qcom: gcc-sdm660: Fix wrong parent_map
Date:   Tue, 27 Oct 2020 14:53:02 +0100
Message-Id: <20201027135515.449286840@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index f0b47b7d50ca6..31258795e7b86 100644
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



