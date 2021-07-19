Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24233CE5B7
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349051AbhGSPxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347983AbhGSPss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:48:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A24D6145C;
        Mon, 19 Jul 2021 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712095;
        bh=COFsRCR5FAvmzhR4K9/J+3u2Pp14fMhkJTNqHmAebXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJ4JWSKj3BWx+Q9Z91O9JpMJcPV+0201SCLbCfI77z2PzE/uTDy+Sn0lJG89F3Xiy
         KaMQ79FPwZgEHacM9vMmVHh4yhiC7EH+LTEEfdLVOHeXpYQbeIb9bS/bxdO54w8X1R
         8b7eRPEKv3o+S4flHgxtZjDgG3TsDkPIaoPe7CVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Steev Klimaszewski <steev@kali.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 248/292] arm64: dts: qcom: c630: Add no-hpd to DSI bridge node
Date:   Mon, 19 Jul 2021 16:55:10 +0200
Message-Id: <20210719144951.106441203@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit c0dcfe6a784fdf7fcc0fdc74bfbb06e9f77de964 ]

We should indicate that we're not using the HPD pin on this device, per
the binding document. Otherwise if code in the future wants to enable
HPD in the bridge when this property is absent we'll be enabling HPD
when it isn't supposed to be used. Presumably this board isn't using hpd
on the bridge.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Steev Klimaszewski <steev@kali.org>
Fixes: 956e9c85f47b ("arm64: dts: qcom: c630: Define eDP bridge and panel")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210324231424.2890039-1-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 140db2d5ba31..c2a709a384e9 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -376,6 +376,8 @@
 		clocks = <&sn65dsi86_refclk>;
 		clock-names = "refclk";
 
+		no-hpd;
+
 		ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.30.2



