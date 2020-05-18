Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED941D81AE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgERRt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730589AbgERRt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:49:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DA5520671;
        Mon, 18 May 2020 17:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824197;
        bh=bpZJJ53Hdlnk4eaAmfNWc7QGpjuXH/AvDsxsd5CCyPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1H+2KPzf5Q3OiccwHLHatADzgMw6x6+FukBr9Fo2v/WAxmqWlRmFD2ZEj6O+CoChP
         6uXDEjPF2k0Qt7O/yr1MRju5ZPWS4KLDLbKd1HDMr3FSJJU0lZVk+/9wzRVv+8g4Uv
         3CKVugnDJtX+ER144lEALGpLety8fpyuRio5riOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.14 109/114] arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards
Date:   Mon, 18 May 2020 19:37:21 +0200
Message-Id: <20200518173520.753471648@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

commit 83b994129fb4c18a8460fd395864a28740e5e7fb upstream.

In some board device tree files, "rk805" was used for the RK805 PMIC's
node name. However the policy for device trees is that generic names
should be used.

Replace the "rk805" node name with the generic "pmic" name.

Fixes: 1e28037ec88e ("arm64: dts: rockchip: add rk805 node for rk3328-evb")
Fixes: 955bebde057e ("arm64: dts: rockchip: add rk3328-rock64 board")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20200327030414.5903-3-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts    |    2 +-
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3328-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-evb.dts
@@ -91,7 +91,7 @@
 &i2c1 {
 	status = "okay";
 
-	rk805: rk805@18 {
+	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
 		interrupt-parent = <&gpio2>;
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
@@ -149,7 +149,7 @@
 &i2c1 {
 	status = "okay";
 
-	rk805: rk805@18 {
+	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
 		interrupt-parent = <&gpio2>;


