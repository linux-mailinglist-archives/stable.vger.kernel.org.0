Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04074051B9
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbhIIMiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242833AbhIIMc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF25061288;
        Thu,  9 Sep 2021 11:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188392;
        bh=cj1E/3jxxxjm2EaPG/Ardk8d0+9n+bk7iseNTTE6mq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLNoJnickGB8e3wZEbUbSbrRph58bUnN81l24/6Ylm1CPSMzG+ICPUyJ4dPumCYrU
         L1rg5osY53i1raEXJFL5xM0EGkPH6t8HngnkiC48+Iwpi7ea51DhiwLlOxnsfliU1/
         hu7Z4FQrdt9ja/l8iyHHAq1ccP1eNt6zyjnU++n3IgdZLYztK/Zs+sunO1PCmOen+H
         e42OLxCm6HUAtpUxz2gHwO6FZCJMpsMeePGYrVmWEY+1oAjsbKn74efc6ymSVc4lCJ
         K1scysQ0+d1J+JJn2UKg/2zj+tySzRsZekBjLzM+tqVttRWNVvAiSsRj+5pRrOoSo+
         ZxkGKP3GP7NoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 089/176] arm64: dts: qcom: sm8250: Fix epss_l3 unit address
Date:   Thu,  9 Sep 2021 07:49:51 -0400
Message-Id: <20210909115118.146181-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Djakov <georgi.djakov@linaro.org>

[ Upstream commit 77b53d65dc1e54321ec841912f06bcb558a079c0 ]

The unit address of the epss_l3 node is incorrect and does not match
the address of its "reg" property. Let's fix it.

Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20210211193637.9737-1-georgi.djakov@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index d4547a192748..ec356fe07ac8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2346,7 +2346,7 @@ apps_bcm_voter: bcm_voter {
 			};
 		};
 
-		epss_l3: interconnect@18591000 {
+		epss_l3: interconnect@18590000 {
 			compatible = "qcom,sm8250-epss-l3";
 			reg = <0 0x18590000 0 0x1000>;
 
-- 
2.30.2

