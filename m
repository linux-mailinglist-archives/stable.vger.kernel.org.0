Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A00140E063
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhIPQVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239263AbhIPQQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE03F6124B;
        Thu, 16 Sep 2021 16:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808716;
        bh=cj1E/3jxxxjm2EaPG/Ardk8d0+9n+bk7iseNTTE6mq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9r59OJHEJG2TB1JXGPcMXKeL9KEkEWf5YuVx6BhOZJadF7cUEHyhxx48oJ1YCjei
         DS+1yiph/UNmM3M4/2UlncO2vDTDQf0Rd2O0MtuOMEthAgDoyxyq4M7Be+Dhakz9FI
         MKNTMSFytrPimiZElFBkhs6T2zBWBDPiwo/oBAJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/306] arm64: dts: qcom: sm8250: Fix epss_l3 unit address
Date:   Thu, 16 Sep 2021 17:59:00 +0200
Message-Id: <20210916155800.715683017@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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



