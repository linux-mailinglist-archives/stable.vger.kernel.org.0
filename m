Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597BA3287CD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhCAR2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238167AbhCARXg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:23:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C3FF64DE7;
        Mon,  1 Mar 2021 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617367;
        bh=mFsVZl/eaB00tjnCacHEicJ+TWNUhcpxob1k9bl4794=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2MtSkGmptZXWpBtzc0Vgw0Empg/33/sunYGR90ilWmtlE0V8IFzGBtLqWvI68sg9
         /N/D5J+NROulilFz6jqEIbn18dfhtxG+3VZdAgXoblx9my2vgEV6cL6Tq6DaCujcvI
         3dXzwa6sACC8Vu4JaEuc2UpOcexUjzDuvsaeR0R8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Knecht <vincent.knecht@mailoo.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/340] arm64: dts: msm8916: Fix reserved and rfsa nodes unit address
Date:   Mon,  1 Mar 2021 17:09:53 +0100
Message-Id: <20210301161050.736067318@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Knecht <vincent.knecht@mailoo.org>

[ Upstream commit d5ae2528b0b56cf054b27d48b0cb85330900082f ]

Fix `reserved` and `rfsa` unit address according to their reg address

Fixes: 7258e10e6a0b ("ARM: dts: msm8916: Update reserved-memory")

Signed-off-by: Vincent Knecht <vincent.knecht@mailoo.org>
Link: https://lore.kernel.org/r/20210123104417.518105-1-vincent.knecht@mailoo.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index d95273af9f1e4..449843f2184d8 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -53,7 +53,7 @@
 			no-map;
 		};
 
-		reserved@8668000 {
+		reserved@86680000 {
 			reg = <0x0 0x86680000 0x0 0x80000>;
 			no-map;
 		};
@@ -66,7 +66,7 @@
 			qcom,client-id = <1>;
 		};
 
-		rfsa@867e00000 {
+		rfsa@867e0000 {
 			reg = <0x0 0x867e0000 0x0 0x20000>;
 			no-map;
 		};
-- 
2.27.0



