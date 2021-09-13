Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26F5409466
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344714AbhIMObH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346827AbhIMO3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9FFF61B65;
        Mon, 13 Sep 2021 13:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541034;
        bh=iV1IrwF9bBVu1a55ckb6Dx8CMb9V/aM05Kr0IEjzFlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCjtF9RRqlf88xR1CHQjp1ZkOi8sBy7WnpMgEbey+XMpWEy6SI1W3KXgrgS+HBndb
         mwon3txA6A10vLArihixu8/wpv2ACshLdZxsQ8e7w2CNYazbodz5qCBBbUFA+m39ct
         KJttGy65I0+xgmlZSzb/2XZrRli1ehcMzu9FlGvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Judy Hsiao <judyhsiao@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 102/334] arm64: dts: qcom: sc7180: Set adau wakeup delay to 80 ms
Date:   Mon, 13 Sep 2021 15:12:36 +0200
Message-Id: <20210913131116.816151432@linuxfoundation.org>
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

From: Judy Hsiao <judyhsiao@chromium.org>

[ Upstream commit a8c7f3100e708d5f55692f0607ca80c5dcd21ce8 ]

Set audu wakeup delay to 80 ms for fixing pop noise during capture begin.

Fixes: ba5f9b5d7ff3 ("arm64: dts: qcom: sc7180: Add wakeup delay for adau codec")
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210708090810.174767-1-judyhsiao@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 6f9c07147551..a758e4d22612 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -23,7 +23,7 @@ ap_h1_spi: &spi0 {};
 	adau7002: audio-codec-1 {
 		compatible = "adi,adau7002";
 		IOVDD-supply = <&pp1800_l15a>;
-		wakeup-delay-ms = <15>;
+		wakeup-delay-ms = <80>;
 		#sound-dai-cells = <0>;
 	};
 
-- 
2.30.2



