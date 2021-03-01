Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A1E328A43
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhCASOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:14:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239386AbhCASIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2BC364FF4;
        Mon,  1 Mar 2021 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618406;
        bh=DkiNPqxdXbZK9E312HyeTGGheoE6PzFf3KsqqltEgaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgxM25l5rDnr7HTz/vPgeG0lvnCQZ6CT8OC3pAF/HCdzdHuvJQvHVAEx2L/cxwEeT
         p2dNiqDB+oC5sLP8ilfifaqA89z0VeQ+MNTfK1BQehiemPDYgAOQvB6BZHWx4u28ys
         FRKcfzLaIGrp6x8PSz4YvHiAVIw5nvXLr4JE/bQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Knecht <vincent.knecht@mailoo.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/663] arm64: dts: msm8916: Fix reserved and rfsa nodes unit address
Date:   Mon,  1 Mar 2021 17:05:24 +0100
Message-Id: <20210301161145.495379556@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index aaa21899f1a63..0e34ed48b9fae 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -55,7 +55,7 @@
 			no-map;
 		};
 
-		reserved@8668000 {
+		reserved@86680000 {
 			reg = <0x0 0x86680000 0x0 0x80000>;
 			no-map;
 		};
@@ -68,7 +68,7 @@
 			qcom,client-id = <1>;
 		};
 
-		rfsa@867e00000 {
+		rfsa@867e0000 {
 			reg = <0x0 0x867e0000 0x0 0x20000>;
 			no-map;
 		};
-- 
2.27.0



