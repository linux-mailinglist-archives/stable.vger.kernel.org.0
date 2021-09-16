Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E3740E7D9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242276AbhIPRgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353443AbhIPRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57E3563222;
        Thu, 16 Sep 2021 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810889;
        bh=4xQAWOcw0mdWd6yHl43XN11NB78uRLLHJ6W0loy0z4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjIRinwTPKYpvY4dSSDQlhsxFoa1Q8O7zpWMsdTg6cLU12YOuoCKn5/M1J48/NyI5
         u+GU/yAFtbxri4RJUOjBrQb2LiRG/DiBz6oyrbFuOj5tEDzbbe5SBASCp+U94OhDYM
         zhR8SusnFNoLVTcM+azJt9GVpYD+ZUaG1wRpKLog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 274/432] arm64: dts: qcom: sm8250: Fix epss_l3 unit address
Date:   Thu, 16 Sep 2021 18:00:23 +0200
Message-Id: <20210916155820.100139913@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9a6eff1813a6..7f7c8f467bfc 100644
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



