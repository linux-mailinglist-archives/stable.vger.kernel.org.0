Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FAC404F0C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243214AbhIIMQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350246AbhIIMNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADB8061A3F;
        Thu,  9 Sep 2021 11:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188136;
        bh=cvSvAuL0fcPQPqEG6/sLvUXB7MySQLu0FomkTkI0Xsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVaC7mAl7U8vj0sceNBAwtDYeQR3pIGoYS5Cc2qZPepKj14rHwX+2lgZtIp0z0Smc
         yO1vgBESIeC9xmdpMRxcpXYEZAYcF975F+VZ+TFxbLpHh0+vggVPTRN3CAMVbPGkLD
         UvVMXruQSpYvoOza9jeZG/0iz74dyzrOZ5NotGbzmylIH1UUoww2My7GP5J7TbPYp9
         QGlTLsbS+xMVFemkRLEkKlTkvjB5eGhjIGmrv2KxkUAiY3TpFaT+GksKiwJJjjV8w9
         dCAnCTwuwr1FoDTBnkd8MVV7VH06fU84Ggms7esiRy8ew0azcmvHxcUuZCouerfEE6
         zHwaBRH7BrIeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 109/219] arm64: dts: qcom: sm8250: Fix epss_l3 unit address
Date:   Thu,  9 Sep 2021 07:44:45 -0400
Message-Id: <20210909114635.143983-109-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 09b552396557..169412f42149 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3773,7 +3773,7 @@ apps_bcm_voter: bcm_voter {
 			};
 		};
 
-		epss_l3: interconnect@18591000 {
+		epss_l3: interconnect@18590000 {
 			compatible = "qcom,sm8250-epss-l3";
 			reg = <0 0x18590000 0 0x1000>;
 
-- 
2.30.2

