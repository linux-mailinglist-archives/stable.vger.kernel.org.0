Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3D54511C8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbhKOTPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244247AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BF70634A9;
        Mon, 15 Nov 2021 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000368;
        bh=k1TZ0vBhW2/9dvCUvvImLWkTiG7U9/ZS5sY97Bz28Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNxjrVW+7gF8h8AUBitA2/Gl4RYnipXOm/BVbLOIQb/z1TntoXCvg32mQHQtSk+/g
         /U6AMtVfxE0sbrqKD9nHyC4IU2gNlNP78ZGGKK7Zi0AA71nPR7NNsnv/+cxS48mI+3
         lDhU2VtQpfmXqVd4xWaMADQm13+Tlp70ku1CoXHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 634/849] arm64: dts: qcom: pmi8994: Fix "eternal"->"external" typo in WLED node
Date:   Mon, 15 Nov 2021 18:01:57 +0100
Message-Id: <20211115165441.720187829@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit b110dfa5ad42be93ebf73540d16430878dfb26bb ]

The property is named "qcom,external-pfet", as found by
dt_binding_check:

    'qcom,eternal-pfet' does not match any of the regexes

Fixes: 37aa540cbd30 ("arm64: dts: qcom: pmi8994: Add WLED node")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-By: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211007213400.258371-11-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index b4ac900ab115f..a06ea9adae810 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -42,7 +42,7 @@
 			/* Yes, all four strings *have to* be defined or things won't work. */
 			qcom,enabled-strings = <0 1 2 3>;
 			qcom,cabc;
-			qcom,eternal-pfet;
+			qcom,external-pfet;
 			status = "disabled";
 		};
 	};
-- 
2.33.0



