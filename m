Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE373354026
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbhDEJQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239886AbhDEJP5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F38560FE4;
        Mon,  5 Apr 2021 09:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614151;
        bh=8S7/RMIhV00j0Z4kk7orpTNP/l8qVcWGcGTof+JeKms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkLdPlch0AuDR9gk7bKQkKOCF+9cYVxyzexzrNEqZXTNrBGP02ZgElSS70ezTLn5v
         15cgERb1+i4h5w1Cg/bZtTeI/4l7jsKLj+792LFNS8cZol1L26jwZfTEeuG6UCIjCT
         qsPB+EXAt4sE5kKCPEkAlEbRdy1cDbgnOaO5jJtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 101/152] pinctrl: qcom: sc7280: Fix SDC_QDSD_PINGROUP and UFS_RESET offsets
Date:   Mon,  5 Apr 2021 10:54:10 +0200
Message-Id: <20210405085037.526057043@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

commit 07abd8db9358751107cc46d1cdbd44a92c76a934 upstream.

The offsets for SDC_QDSD_PINGROUP and UFS_RESET were off by 0x100000
due to an issue in the scripts generating the data.

Fixes: ecb454594c43: ("pinctrl: qcom: Add sc7280 pinctrl driver")
Reported-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1614662511-26519-1-git-send-email-rnayak@codeaurora.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-sc7280.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -1439,14 +1439,14 @@ static const struct msm_pingroup sc7280_
 	[172] = PINGROUP(172, qdss, _, _, _, _, _, _, _, _),
 	[173] = PINGROUP(173, qdss, _, _, _, _, _, _, _, _),
 	[174] = PINGROUP(174, qdss, _, _, _, _, _, _, _, _),
-	[175] = UFS_RESET(ufs_reset, 0x1be000),
-	[176] = SDC_QDSD_PINGROUP(sdc1_rclk, 0x1b3000, 15, 0),
-	[177] = SDC_QDSD_PINGROUP(sdc1_clk, 0x1b3000, 13, 6),
-	[178] = SDC_QDSD_PINGROUP(sdc1_cmd, 0x1b3000, 11, 3),
-	[179] = SDC_QDSD_PINGROUP(sdc1_data, 0x1b3000, 9, 0),
-	[180] = SDC_QDSD_PINGROUP(sdc2_clk, 0x1b4000, 14, 6),
-	[181] = SDC_QDSD_PINGROUP(sdc2_cmd, 0x1b4000, 11, 3),
-	[182] = SDC_QDSD_PINGROUP(sdc2_data, 0x1b4000, 9, 0),
+	[175] = UFS_RESET(ufs_reset, 0xbe000),
+	[176] = SDC_QDSD_PINGROUP(sdc1_rclk, 0xb3000, 15, 0),
+	[177] = SDC_QDSD_PINGROUP(sdc1_clk, 0xb3000, 13, 6),
+	[178] = SDC_QDSD_PINGROUP(sdc1_cmd, 0xb3000, 11, 3),
+	[179] = SDC_QDSD_PINGROUP(sdc1_data, 0xb3000, 9, 0),
+	[180] = SDC_QDSD_PINGROUP(sdc2_clk, 0xb4000, 14, 6),
+	[181] = SDC_QDSD_PINGROUP(sdc2_cmd, 0xb4000, 11, 3),
+	[182] = SDC_QDSD_PINGROUP(sdc2_data, 0xb4000, 9, 0),
 };
 
 static const struct msm_pinctrl_soc_data sc7280_pinctrl = {


