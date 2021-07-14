Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8566F3C8E9C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbhGNTsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhGNTri (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38D3B613D1;
        Wed, 14 Jul 2021 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291801;
        bh=NNkoQgcDeENd/sYEIuPZDWRvcjWqqdl5BBNZc4ymEd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhTgkQFdlz8HyRdVr2XVRMaQ+rX+0xsBivIISTan3LpyRUktlQ5G8Umr7zRBd22wL
         7oMrcosQpB85nIJnu1pGNLjXrYsEoMK6qm5cwX5dRQZ+frk+5H3uvF8tsPu641Nk4s
         jStX7ZRS/N3rqDD0Ye1XeffNphV8BLC0R865ljRWw5Adr+w/SYYGLbU2sEqhbEQpx6
         050ISA6jvz6hcvsqMcO0JjFqVAtO5CWZ6GzG4MeWbMPWGOc2U5a2vq++CdQCNWhTnR
         AVjo8Z2kwPjHbXSFgsYWT83SzhE6nvyQausF/0J4Cbi4YtP3YaBVki76EEh3BvI5xQ
         TqPy/kFR/fhWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elaine Zhang <zhangqing@rock-chips.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/88] ARM: dts: rockchip: Fix power-controller node names for rk3288
Date:   Wed, 14 Jul 2021 15:41:45 -0400
Message-Id: <20210714194303.54028-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elaine Zhang <zhangqing@rock-chips.com>

[ Upstream commit 970cdc53cb1afa73602028c103dbfb6a230080be ]

Use more generic names (as recommended in the device tree specification
or the binding documentation)

Signed-off-by: Elaine Zhang <zhangqing@rock-chips.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-4-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 49b196546cdf..0d89ad274268 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -788,7 +788,7 @@ power: power-controller {
 			 *	*_HDMI		HDMI
 			 *	*_MIPI_*	MIPI
 			 */
-			pd_vio@RK3288_PD_VIO {
+			power-domain@RK3288_PD_VIO {
 				reg = <RK3288_PD_VIO>;
 				clocks = <&cru ACLK_IEP>,
 					 <&cru ACLK_ISP>,
@@ -830,7 +830,7 @@ pd_vio@RK3288_PD_VIO {
 			 * Note: The following 3 are HEVC(H.265) clocks,
 			 * and on the ACLK_HEVC_NIU (NOC).
 			 */
-			pd_hevc@RK3288_PD_HEVC {
+			power-domain@RK3288_PD_HEVC {
 				reg = <RK3288_PD_HEVC>;
 				clocks = <&cru ACLK_HEVC>,
 					 <&cru SCLK_HEVC_CABAC>,
@@ -844,7 +844,7 @@ pd_hevc@RK3288_PD_HEVC {
 			 * (video endecoder & decoder) clocks that on the
 			 * ACLK_VCODEC_NIU and HCLK_VCODEC_NIU (NOC).
 			 */
-			pd_video@RK3288_PD_VIDEO {
+			power-domain@RK3288_PD_VIDEO {
 				reg = <RK3288_PD_VIDEO>;
 				clocks = <&cru ACLK_VCODEC>,
 					 <&cru HCLK_VCODEC>;
@@ -855,7 +855,7 @@ pd_video@RK3288_PD_VIDEO {
 			 * Note: ACLK_GPU is the GPU clock,
 			 * and on the ACLK_GPU_NIU (NOC).
 			 */
-			pd_gpu@RK3288_PD_GPU {
+			power-domain@RK3288_PD_GPU {
 				reg = <RK3288_PD_GPU>;
 				clocks = <&cru ACLK_GPU>;
 				pm_qos = <&qos_gpu_r>,
-- 
2.30.2

