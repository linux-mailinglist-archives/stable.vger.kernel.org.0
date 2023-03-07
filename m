Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4506AEF09
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjCGSTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjCGSTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD8D99D6F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D27E2B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCCFC433EF;
        Tue,  7 Mar 2023 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212820;
        bh=3rgg1ydyVCb7or55iwhukbvWvIEmGl1GH875ZvD8e8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UfIo6vu3K4MGhsJbaGE5HXOYx4tGuCIE95rU46loj1E9iX/ZaFifQYx0WWajYGlGw
         sbZQhdnKr24/arcnF1czMfDan9C5dLDEw1SnjAVD6HTNPQwFy77mE3Rb4Cy1E0/OHC
         rs1vbGoZUuxPtDgdGnJyoEzLX8ThFZuXrfd4lJYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adam Skladowski <a39.skl@gmail.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 278/885] pinctrl: qcom: pinctrl-msm8976: Correct function names for wcss pins
Date:   Tue,  7 Mar 2023 17:53:32 +0100
Message-Id: <20230307170014.091626256@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit a7cc0e2685082a0d79baec02df184dfa83cbfac3 ]

Adjust names of function for wcss pins, also fix third gpio in bt group.

Fixes: bcd11493f0ab ("pinctrl: qcom: Add a pinctrl driver for MSM8976 and 8956")
Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20221231164250.74550-1-a39.skl@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm8976.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm8976.c b/drivers/pinctrl/qcom/pinctrl-msm8976.c
index ec43edf9b660a..e11d845847190 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8976.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8976.c
@@ -733,7 +733,7 @@ static const char * const codec_int2_groups[] = {
 	"gpio74",
 };
 static const char * const wcss_bt_groups[] = {
-	"gpio39", "gpio47", "gpio88",
+	"gpio39", "gpio47", "gpio48",
 };
 static const char * const sdc3_groups[] = {
 	"gpio39", "gpio40", "gpio41",
@@ -958,9 +958,9 @@ static const struct msm_pingroup msm8976_groups[] = {
 	PINGROUP(37, NA, NA, NA, qdss_tracedata_b, NA, NA, NA, NA, NA),
 	PINGROUP(38, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b, NA),
 	PINGROUP(39, wcss_bt, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(40, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(41, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(42, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(40, wcss_wlan2, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(41, wcss_wlan1, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(42, wcss_wlan0, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
 	PINGROUP(43, wcss_wlan, sdc3, NA, NA, qdss_tracedata_a, NA, NA, NA, NA),
 	PINGROUP(44, wcss_wlan, sdc3, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(45, wcss_fm, NA, qdss_tracectl_a, NA, NA, NA, NA, NA, NA),
-- 
2.39.2



