Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6753D451F15
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355518AbhKPAi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344463AbhKOTYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88B4B611F0;
        Mon, 15 Nov 2021 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002689;
        bh=k1TZ0vBhW2/9dvCUvvImLWkTiG7U9/ZS5sY97Bz28Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWgL1QY8lF01xJd+aFScJD3NU0VcluTUC2NEuuS3W9JVM7G66U0V02/4o3TSyR31O
         4ks9+GDCuejvX1oNZEgZyYmpQGMQDKpTbki0OxGqUEaYjGNy+Y9vHBNomcu5O1wgmU
         bJVMGURbXDBruMEw6Mk2phq7n3MMjio2kDQIdD4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 660/917] arm64: dts: qcom: pmi8994: Fix "eternal"->"external" typo in WLED node
Date:   Mon, 15 Nov 2021 18:02:35 +0100
Message-Id: <20211115165451.265197986@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



