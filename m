Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50F4354028
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbhDEJQR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240639AbhDEJQB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFD8E611C1;
        Mon,  5 Apr 2021 09:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614154;
        bh=jcbj1Q8+JgeJdS6AC5orKeVcK28dN+QUa8VeHnO1x6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPF57pegJ4afwXZ6vzSzEAMwI0+5DWRW639iTMljEyazlFAQBSgDvBtf6wkhG8TKC
         vJ7Qoing/pDjZKXXSS0F2n5nduboNbZOCoqFMyzVDUpdNujkD84f2rzxAErQnMj9HP
         mIl/wpsJD//9/3KTlzXXD8u3Er8CFt/j+RJsVf6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 102/152] pinctrl: qcom: sc7280: Fix SDC1_RCLK configurations
Date:   Mon,  5 Apr 2021 10:54:11 +0200
Message-Id: <20210405085037.557270134@linuxfoundation.org>
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

commit d0f9f47c07fe52b34e2ff8590cf09e0a9d8d6f99 upstream.

Fix SDC1_RCLK configurations which are in a different register so fix the
offset from 0xb3000 to 0xb3004.

Fixes: ecb454594c43: ("pinctrl: qcom: Add sc7280 pinctrl driver")
Reported-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1614662511-26519-2-git-send-email-rnayak@codeaurora.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-sc7280.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-sc7280.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc7280.c
@@ -1440,7 +1440,7 @@ static const struct msm_pingroup sc7280_
 	[173] = PINGROUP(173, qdss, _, _, _, _, _, _, _, _),
 	[174] = PINGROUP(174, qdss, _, _, _, _, _, _, _, _),
 	[175] = UFS_RESET(ufs_reset, 0xbe000),
-	[176] = SDC_QDSD_PINGROUP(sdc1_rclk, 0xb3000, 15, 0),
+	[176] = SDC_QDSD_PINGROUP(sdc1_rclk, 0xb3004, 0, 6),
 	[177] = SDC_QDSD_PINGROUP(sdc1_clk, 0xb3000, 13, 6),
 	[178] = SDC_QDSD_PINGROUP(sdc1_cmd, 0xb3000, 11, 3),
 	[179] = SDC_QDSD_PINGROUP(sdc1_data, 0xb3000, 9, 0),


