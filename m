Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6938C40942F
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344850AbhIMO2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345687AbhIMO0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 596A061B71;
        Mon, 13 Sep 2021 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540960;
        bh=xmi01OkwJpGzNg2W2S7pUyCWWJVzK30TiRggTu1NR9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJX8i9VebhssbERsDZWEXtR6LBw3bNkmYbE0Rc0NsrIFdR8wd7+1Zzc0+ohAEMbto
         +t6RjmUZs/MjJUx/gPwZ8Ygd6TnFu26d4Mn8LTsYQygb5+/KuJfi5Dts/OZDxwmv3t
         C6J/ql+IpIb5lqcTu/pdibmVRJULHX6I6c+rYwI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 106/334] arm64: dts: qcom: sm8250: fix usb2 qmp phy node
Date:   Mon, 13 Sep 2021 15:12:40 +0200
Message-Id: <20210913131116.960704385@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 63fa4322469648ae1023bb92a8b0d6a2f4bdaf2c ]

Use 'lanes' as SuperSpeed lanes device node instead of just 'lane' to
fix issues with TypeC support.

Fixes: 46a6f297d7dd ("arm64: dts: qcom: sm8250: Add USB and PHY device nodes")
Cc: robh+dt@kernel.org
Cc: devicetree@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20210706230702.299047-2-bryan.odonoghue@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 4798368b02ef..9a6eff1813a6 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2210,7 +2210,7 @@
 				 <&gcc GCC_USB3_PHY_SEC_BCR>;
 			reset-names = "phy", "common";
 
-			usb_2_ssphy: lane@88eb200 {
+			usb_2_ssphy: lanes@88eb200 {
 				reg = <0 0x088eb200 0 0x200>,
 				      <0 0x088eb400 0 0x200>,
 				      <0 0x088eb800 0 0x800>;
-- 
2.30.2



