Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD561D8210
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgERRxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbgERRxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:53:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15A420872;
        Mon, 18 May 2020 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824391;
        bh=Cj7cUSqlMtLQsypc14N1oxxazOXuz+5fCic5poKP/xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fpm511ISuVjGHGpovJeOUrA2nAlo7Osj7lxOeq2AishMI9sNRxZ8RA6SK+W2HHXYm
         0v9ip855+3VIcSLd4bKWduN2XaCHNeM5kekoPZ3hzR3BEOnXQT1PDvBFp4RqTGGUAO
         WE6Ge0NzpTkNZgjutspdH+PZ2Md6Uu8+Lex6EDtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 4.19 74/80] arm64: dts: rockchip: Replace RK805 PMIC node name with "pmic" on rk3328 boards
Date:   Mon, 18 May 2020 19:37:32 +0200
Message-Id: <20200518173505.437385670@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
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
@@ -92,7 +92,7 @@
 &i2c1 {
 	status = "okay";
 
-	rk805: rk805@18 {
+	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
 		interrupt-parent = <&gpio2>;
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
@@ -112,7 +112,7 @@
 &i2c1 {
 	status = "okay";
 
-	rk805: rk805@18 {
+	rk805: pmic@18 {
 		compatible = "rockchip,rk805";
 		reg = <0x18>;
 		interrupt-parent = <&gpio2>;


