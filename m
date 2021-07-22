Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D99B3D29CB
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhGVQGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhGVQF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4548F61D30;
        Thu, 22 Jul 2021 16:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972363;
        bh=KCuGNY6fRK6iW8djSix/TvdpJ5X/PAcxyih/mY5iztQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFbKyoh/AHs/3wwPiibUfmL2E/LUDd6uVptM/znDErlo+GFwBeG5HDMwFlP5toCEn
         3xA6ZP0OlcXLe2QDGb4WK7xa5m0GIzOEp2Bs9EVJnR/DeAuBHJzfbZnLfzJDUP7GRa
         VarmYfgYPSdcQZ5vOtqJXVzdG0w992W+kzptSy0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 086/156] arm64: dts: qcom: sm8250: Fix pcie2_lane unit address
Date:   Thu, 22 Jul 2021 18:31:01 +0200
Message-Id: <20210722155631.166164362@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit dc2f86369b157dfe4dccd31497d2e3c541e7239d ]

The previous one was likely a mistaken copy from pcie1_lane.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210613185334.306225-1-konrad.dybcio@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 75f9476109e6..09b552396557 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1470,7 +1470,7 @@
 
 			status = "disabled";
 
-			pcie2_lane: lanes@1c0e200 {
+			pcie2_lane: lanes@1c16200 {
 				reg = <0 0x1c16200 0 0x170>, /* tx0 */
 				      <0 0x1c16400 0 0x200>, /* rx0 */
 				      <0 0x1c16a00 0 0x1f0>, /* pcs */
-- 
2.30.2



