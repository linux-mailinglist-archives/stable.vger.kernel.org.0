Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FEB37C7F9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbhELQDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234061AbhELP54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8743E61CBB;
        Wed, 12 May 2021 15:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833506;
        bh=H+x2mPZ1MIPuSnfvLkwg5ZznV/mqhbJpotrBGz8d5b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytlqj0lp6CrBBHMiz/cAn9ODpTqqdMqcUDjVC463UYKaG/N7Qa4dRFbQR8bmcBzGG
         TQk0DiwnMcfJQBZkBdMSiPFrWK8sMwd1SyZ4lEB0UrweioGuEffG4pKZdIXhFYdTzM
         oef6sU6/aEJkcGz9c7mU6AHpbZ5NMH7Ht/PKrmts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 175/601] arm64: dts: qcom: sc7180: trogdor: Fix trip point config of charger thermal zone
Date:   Wed, 12 May 2021 16:44:12 +0200
Message-Id: <20210512144833.608293865@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit 38f3267def6511171aef0f056ad172686903603f ]

The trip point configuration of the charger thermal zone for trogdor
is missing a node for the critical trip point. Add the missing node.

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Fixes: bb06eb3607e9 ("arm64: qcom: sc7180: trogdor: Add ADC nodes and thermal zone for charger thermistor")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20210225103330.v2.3.Ife7768b6b4765026c9d233ad4982da0e365ddbca@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 8ed7dd39f6e3..5c650b902c10 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -22,9 +22,11 @@
 			thermal-sensors = <&pm6150_adc_tm 1>;
 
 			trips {
-				temperature = <125000>;
-				hysteresis = <1000>;
-				type = "critical";
+				charger-crit {
+					temperature = <125000>;
+					hysteresis = <1000>;
+					type = "critical";
+				};
 			};
 		};
 	};
-- 
2.30.2



