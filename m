Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4429404B67
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbhIILvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240567AbhIILte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FD76128B;
        Thu,  9 Sep 2021 11:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187827;
        bh=cSi5volxMwlirJGa4qGJDFrwL/mhKc0/pLBNmIikRdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwrj9UsksrRmUQ5Zmzkrt+u+9a65j/uIl4AF9ACWKpq1Mwn64jyKaHNTO9eu4tB2U
         5bpIpQzbvZssK3o3zHx1PXLIT33p9tT82nUP99k9vQNDWJTjKQvMC8Ari92FrMHqjv
         7X3HCCDl7DbGfx/rcv0E7AgqA7j9ieBagfiNkPgTcYDGaM0afUU2sfEQk0jfCeZxvq
         ammgPqmVGuV9+t7j50i+ByuD2AS1WTmkJSD2R0GVHJ4eUSQYuFOUGPOjLOD72dXW8e
         oItUcs3vhWHkGdTF4pRq7tmg/BejwUkVRCrSTzCyuSvrNDClNx/TFKsdBS+tMFKNiE
         WdVnkMmGlzu8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 124/252] arm64: dts: qcom: sm8250: Fix epss_l3 unit address
Date:   Thu,  9 Sep 2021 07:38:58 -0400
Message-Id: <20210909114106.141462-124-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 4798368b02ef..ecfe4b538a12 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3955,7 +3955,7 @@ apps_bcm_voter: bcm_voter {
 			};
 		};
 
-		epss_l3: interconnect@18591000 {
+		epss_l3: interconnect@18590000 {
 			compatible = "qcom,sm8250-epss-l3";
 			reg = <0 0x18590000 0 0x1000>;
 
-- 
2.30.2

