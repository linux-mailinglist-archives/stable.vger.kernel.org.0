Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A32E3C8CF6
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbhGNTnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhGNTmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F17613D0;
        Wed, 14 Jul 2021 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291597;
        bh=+7X0WhMUWxiad1+GTvGCFLGSc7A0FiFOGf1V/j3u2gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH8vWwumHdRCpT8WoTjb3eGvj2Kva5Nctf/dp3yZF4EU+pR/ncw195Ty+k9oSmE/8
         ajj8gs1xhN9S5YdoTDhu6FaKGGVgjmDZbzG4Sx+GKbNS2PcXmWnU5P4yfPUYe3WJUE
         uptUMcgAWmSMBTwLctq9FU4XNWh97oIYYhm8nz/+Nofyd2MzhX0FtEaAtSd40qCXQ/
         lcgGZBYaTYeeDnc0NM4R5k5BV9u0WY/uyoERD7UzKZQQY8LFBVEAGoLSfhGXtytO/b
         YMCu02flDXZAfEj1h25xKPIIg8NxcJKW4FTmuS7XfhFTeNsiNQPrQyQIOFdtPRK8lx
         oQkLYEgHuZkEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 080/108] arm64: dts: qcom: sc7180: Add wakeup delay for adau codec
Date:   Wed, 14 Jul 2021 15:37:32 -0400
Message-Id: <20210714193800.52097-80-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

[ Upstream commit ba5f9b5d7ff3452e69275080c3d59265bc1db8ea ]

Add wakeup delay for fixing PoP noise during capture begin.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Judy Hsiao <judyhsiao@chromium.org>
Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/20210513122429.25295-1-srivasam@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 4c6e433c8226..3eb8550da1fc 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -23,6 +23,7 @@ / {
 	adau7002: audio-codec-1 {
 		compatible = "adi,adau7002";
 		IOVDD-supply = <&pp1800_l15a>;
+		wakeup-delay-ms = <15>;
 		#sound-dai-cells = <0>;
 	};
 };
-- 
2.30.2

