Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB63C4ED8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242006AbhGLHVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245497AbhGLHTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE53460FF1;
        Mon, 12 Jul 2021 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074205;
        bh=L54z9NXgGmai7tFpkSCXAK7zUvuUubwE7cZUUL2mOB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SpVs5KIP9NUKFuBMKBW9r34kbuVOCnVajG8Ah5EGFQhTkEquGKi43/WN+hslhuqL
         biyTWCyccq4hpCxF8KQ0d6h5uXrxocD1enoj0yFcMQdrbwRfH9v8kVi/FfSzZ8g1A4
         HFiaxZFn/wMDp0koCA9o/0QQrd6pgNpma6eV80Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taniya Das <tdas@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 501/700] clk: qcom: gcc: Add support for a new frequency for SC7280
Date:   Mon, 12 Jul 2021 08:09:44 +0200
Message-Id: <20210712061029.790496863@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit ca1c667f4be935825fffb232a106c9d3f1c09b0b ]

There is a requirement to support 52MHz for qup clocks for bluetooth
usecase, thus update the frequency table to support the frequency.

Fixes: a3cc092196ef ("clk: qcom: Add Global Clock controller (GCC) driver for SC7280")
Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lore.kernel.org/r/1624449471-9984-1-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/qcom/gcc-sc7280.c b/drivers/clk/qcom/gcc-sc7280.c
index 22736c16ed16..2db1b07c7044 100644
--- a/drivers/clk/qcom/gcc-sc7280.c
+++ b/drivers/clk/qcom/gcc-sc7280.c
@@ -716,6 +716,7 @@ static const struct freq_tbl ftbl_gcc_qupv3_wrap0_s2_clk_src[] = {
 	F(29491200, P_GCC_GPLL0_OUT_EVEN, 1, 1536, 15625),
 	F(32000000, P_GCC_GPLL0_OUT_EVEN, 1, 8, 75),
 	F(48000000, P_GCC_GPLL0_OUT_EVEN, 1, 4, 25),
+	F(52174000, P_GCC_GPLL0_OUT_MAIN, 1, 2, 23),
 	F(64000000, P_GCC_GPLL0_OUT_EVEN, 1, 16, 75),
 	F(75000000, P_GCC_GPLL0_OUT_EVEN, 4, 0, 0),
 	F(80000000, P_GCC_GPLL0_OUT_EVEN, 1, 4, 15),
-- 
2.30.2



