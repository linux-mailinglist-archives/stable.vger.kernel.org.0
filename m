Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5853232863D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhCARHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236034AbhCAQ7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:59:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BFEE64FE9;
        Mon,  1 Mar 2021 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616666;
        bh=kNr/yPFnkQikVDj2D3T9d8ZVm7uhwAOBpN8KR5wp9kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vwkeJd2V4vUEDu9HUec1wCVd/m6fLpqIIOkcmzC+UWzjm8IkENakJDBmzubqMFlQm
         68zsb/4rp7RCOVQGiP5ognaMlTf5km2YPF6xH5BXNHvqm+xCKRA+9TZfGsp6F59X83
         vDJ7p4I0sR/JMBPPoe7LrWGr2oGUfka9vO5QS5nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Knecht <vincent.knecht@mailoo.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/247] arm64: dts: msm8916: Fix reserved and rfsa nodes unit address
Date:   Mon,  1 Mar 2021 17:11:13 +0100
Message-Id: <20210301161034.270515245@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 2c5193ae20277..ba42c62399226 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -64,7 +64,7 @@
 			no-map;
 		};
 
-		reserved@8668000 {
+		reserved@86680000 {
 			reg = <0x0 0x86680000 0x0 0x80000>;
 			no-map;
 		};
@@ -77,7 +77,7 @@
 			qcom,client-id = <1>;
 		};
 
-		rfsa@867e00000 {
+		rfsa@867e0000 {
 			reg = <0x0 0x867e0000 0x0 0x20000>;
 			no-map;
 		};
-- 
2.27.0



