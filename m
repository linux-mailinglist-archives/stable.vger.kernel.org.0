Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A7245C2AA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349546AbhKXNbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350934AbhKXN26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE0B61178;
        Wed, 24 Nov 2021 12:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758287;
        bh=t6AzhWTFVPennLsUMaqa2vYkOYQZYqkGok37nqKV0Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq5i8N+H5Gztf+NcZonLHXme5deOYP6sU+/FMT9laId8Do7KTUePCPLE8d3zpdU92
         oOn3K9i4iMF8iDUSWcLDvP5Kmf931D2VCXk2eCzGzGP8KA7fLpNZNociRcfQFUcxt1
         089tMxwcSF1hxK8ifMOyI07nNEHhf6Ia6LiUyRnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/154] arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property
Date:   Wed, 24 Nov 2021 12:56:56 +0100
Message-Id: <20211124115703.023702286@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 3509de752ea14c7e5781b3a56a4a0bf832f5723a ]

Property qcom,controlled-remotely should be boolean.  Fix it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829111628.5543-2-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 3ceb36cac512f..9cb8f7a052df9 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -200,7 +200,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 			qcom,config-pipe-trust-reg = <0>;
 		};
 
-- 
2.33.0



