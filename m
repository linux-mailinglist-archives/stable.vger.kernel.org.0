Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32314F66
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfEFOe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEFOe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C0C2204EC;
        Mon,  6 May 2019 14:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153295;
        bh=ePS8osDNz7U7/25e/JhiEYUQFdUlZbEFXwT29LA7/l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgY2nowrO0XRgUk4BFBLnpy2CbYvNitUdbjFiXDB/01VXrAY7v6TuK7Akdto27MpZ
         LcqCgKxtNCN+yqxqyn1u4hFxuUNPISbI1OipgMfdH6XcBLgPezH+GFknRoS+xch/Ue
         ihxLAK3qcd+k1g0t0GBDtVziMAW7vuQBpLdPtUOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 036/122] ARM: dts: rockchip: Fix gpu opp node names for rk3288
Date:   Mon,  6 May 2019 16:31:34 +0200
Message-Id: <20190506143058.116696685@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d040e4e8deeaa8257d6aa260e29ad69832b5d630 ]

The device tree compiler yells like this:
  Warning (unit_address_vs_reg):
  /gpu-opp-table/opp@100000000:
  node has a unit name, but no reg property

Let's match the cpu opp node names and use a dash.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 09868dcee34b..df0c5456c94f 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1282,27 +1282,27 @@
 	gpu_opp_table: gpu-opp-table {
 		compatible = "operating-points-v2";
 
-		opp@100000000 {
+		opp-100000000 {
 			opp-hz = /bits/ 64 <100000000>;
 			opp-microvolt = <950000>;
 		};
-		opp@200000000 {
+		opp-200000000 {
 			opp-hz = /bits/ 64 <200000000>;
 			opp-microvolt = <950000>;
 		};
-		opp@300000000 {
+		opp-300000000 {
 			opp-hz = /bits/ 64 <300000000>;
 			opp-microvolt = <1000000>;
 		};
-		opp@400000000 {
+		opp-400000000 {
 			opp-hz = /bits/ 64 <400000000>;
 			opp-microvolt = <1100000>;
 		};
-		opp@500000000 {
+		opp-500000000 {
 			opp-hz = /bits/ 64 <500000000>;
 			opp-microvolt = <1200000>;
 		};
-		opp@600000000 {
+		opp-600000000 {
 			opp-hz = /bits/ 64 <600000000>;
 			opp-microvolt = <1250000>;
 		};
-- 
2.20.1



