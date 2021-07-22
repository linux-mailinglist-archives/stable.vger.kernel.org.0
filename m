Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280313D29C6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhGVQGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234919AbhGVQFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB756144E;
        Thu, 22 Jul 2021 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972350;
        bh=zwp8EAtBiBXideIlDMng0QphZkMg7ytoPdXUY8PP5jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXRUU+GjNwHxjjFEPU7dnfNSTJOb8nB36OWLXlwXuaQt06BzCZng8C0/6NgLI2l3p
         VO4oxRxQVn/SWfDKEB+0kbHEFDrZPxUeZEsNKFGaubsGy85EaW+BUWVO3Hhg3LPZV7
         lBo5ull6sQ9z6i9+MQm3YCE2TPaM32klUxJSWO8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 073/156] arm64: dts: qcom: sc7180: Add wakeup delay for adau codec
Date:   Thu, 22 Jul 2021 18:30:48 +0200
Message-Id: <20210722155630.754694115@linuxfoundation.org>
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
@@ -23,6 +23,7 @@ ap_h1_spi: &spi0 {};
 	adau7002: audio-codec-1 {
 		compatible = "adi,adau7002";
 		IOVDD-supply = <&pp1800_l15a>;
+		wakeup-delay-ms = <15>;
 		#sound-dai-cells = <0>;
 	};
 };
-- 
2.30.2



