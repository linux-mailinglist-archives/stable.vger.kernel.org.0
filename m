Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB345BC4F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244708AbhKXM1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:27:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244035AbhKXMZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:25:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CB6161107;
        Wed, 24 Nov 2021 12:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756152;
        bh=u/I56GRwtTcKSHg3nKUPUeSkPN08FMTItD1vbc3pHDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yP2/eW1/vg3/BV2fUpBXG5aROPpkTIToxp8ht+dFerw2GslhetMfWui/+Q0v3VngU
         o6xAvUwKcrZ1ibqhx3RT1EDind6XX+4Of3MeY4TImmqkH2qs5JUaHU2RUzxCrvzHUo
         n8hXpU0Yf4Cw/zyCxTf393Hw/7KYo17+yO93P57Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 164/207] arm64: dts: qcom: msm8916: Add unit name for /soc node
Date:   Wed, 24 Nov 2021 12:57:15 +0100
Message-Id: <20211124115709.311166164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 7a62bfebc8c94bdb6eb8f54f49889dc6b5b79601 ]

This fixes the following warning when building with W=1:
Warning (unit_address_vs_reg): /soc: node has a reg or ranges property,
but no unit name

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210921152120.6710-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index c2557cf43b3dc..eb806e73d598b 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -243,7 +243,7 @@
 		};
 	};
 
-	soc: soc {
+	soc: soc@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
-- 
2.33.0



