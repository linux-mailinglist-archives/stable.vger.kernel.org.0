Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0A4594D95
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244608AbiHPAcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352830AbiHPAbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B361859BC;
        Mon, 15 Aug 2022 13:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D331B80EAD;
        Mon, 15 Aug 2022 20:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E100FC433D6;
        Mon, 15 Aug 2022 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595756;
        bh=gYJQV0CYwkY4S0gra6WnEjPpMfpNO/F+S1Ngd2WqFcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AEnoHgmVEu5zWR5lC9m5PWu9K8Cw0Gf0aGVaiJkhRoRb6dmfC07JoHL/zBIPMu5rC
         wG8d1VOvgPHkb+DseUF4VLpOVYUs/M3a6twC/QFkquWao2mnoMhbaPN39E8YULJroR
         INe8ulV9ip8+0H7hziOd8MeUQ8Ovs7TsnVjcblSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0832/1157] clk: qcom: gcc-msm8939: Fix weird field spacing in ftbl_gcc_camss_cci_clk
Date:   Mon, 15 Aug 2022 20:03:08 +0200
Message-Id: <20220815180512.766635149@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 2bc308ebc453ba22f3f120f777b9ac48f973ee80 ]

Adding a new item to this frequency table I see the existing indentation is
incorrect.

Fixes: 1664014e4679 ("clk: qcom: gcc-msm8939: Add MSM8939 Generic Clock Controller")
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220712125922.3461675-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-msm8939.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-msm8939.c b/drivers/clk/qcom/gcc-msm8939.c
index c7377ec0f423..de0022e5450d 100644
--- a/drivers/clk/qcom/gcc-msm8939.c
+++ b/drivers/clk/qcom/gcc-msm8939.c
@@ -1014,7 +1014,7 @@ static struct clk_rcg2 blsp1_uart2_apps_clk_src = {
 };
 
 static const struct freq_tbl ftbl_gcc_camss_cci_clk[] = {
-	F(19200000,	P_XO, 1, 0,	0),
+	F(19200000, P_XO, 1, 0, 0),
 	{ }
 };
 
-- 
2.35.1



