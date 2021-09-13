Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DC4091B9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhIMOED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343771AbhIMOBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:01:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 039E3613C8;
        Mon, 13 Sep 2021 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540286;
        bh=4vAAoX2C0toXlaw9ZCjZZwdTIj0zKqMABZc01c2o0oc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PS17iL8OiIoqVTaEwHNZgGGCK9uFIHYgD/jaTZFKRP7kFu+BgGOKrF3pe4SIa7L12
         poNb2HLH9idzedpL5y4ET3psOtwClmAisEE3UplgG1hk9tkJKqG4UuJ2YLP8CuRmwd
         y8T+E4on9VoSHdCvR5G1iont/TWgI8GLtgiqBclo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Judy Hsiao <judyhsiao@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 098/300] arm64: dts: qcom: sc7180: Set adau wakeup delay to 80 ms
Date:   Mon, 13 Sep 2021 15:12:39 +0200
Message-Id: <20210913131112.695632410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
index 3eb8550da1fc..3fa1ad1d0f02 100644
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
 };
-- 
2.30.2



