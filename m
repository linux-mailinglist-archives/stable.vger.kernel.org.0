Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A18F37CC62
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhELQon (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242279AbhELQeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353CA61CB4;
        Wed, 12 May 2021 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835144;
        bh=I76W/T/4a6lipabIiBdJrg0ivC050alQW5X4B9zeOzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vV5C5zAx1y6Z8tcYyVHrmxjF93bDN3JmSgItFQFTsl/kMdqw2ZiHsmxL+y9Ue7hnP
         CTZ5dld+LutQbrlz7AMWz1k+ML85DwOL47ja2RGXvpFu/9CxMSeGFOrWeRcnTh9Kbj
         XbNm/b5QMGFiGpF94EQYeeV8JTHp4F9krwxEbfYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 191/677] arm64: dts: qcom: sc7180: trogdor: Fix trip point config of charger thermal zone
Date:   Wed, 12 May 2021 16:43:57 +0200
Message-Id: <20210512144843.591868159@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 07c8b2c926c0..753fd320dfbc 100644
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



