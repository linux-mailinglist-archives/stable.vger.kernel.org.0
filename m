Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C57D3C6722
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 01:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhGLXvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 19:51:01 -0400
Received: from spindle.queued.net ([45.33.49.30]:54844 "EHLO
        spindle.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbhGLXvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 19:51:01 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 19:51:01 EDT
Received: from e7470.queued.net (cpe-104-162-173-121.nyc.res.rr.com [104.162.173.121])
        by spindle.queued.net (Postfix) with ESMTPSA id E53CD101E5F;
        Mon, 12 Jul 2021 16:48:11 -0700 (PDT)
Date:   Mon, 12 Jul 2021 19:48:10 -0400
From:   Andres Salomon <dilinger@queued.net>
To:     stable@vger.kernel.org
Cc:     Cameron Nemo <cnemo@tutanota.com>, dilinger@queued.net
Subject: [PATCH stable 5.10 2/2] arm64: dts: rockchip: Enable USB3 for
 rk3328 Rock64
Message-ID: <20210712194810.074c7c09@e7470.queued.net>
In-Reply-To: <20210712194251.7af563ed@e7470.queued.net>
References: <20210712194251.7af563ed@e7470.queued.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Nemo <cnemo@tutanota.com>

commit bbac8bd65f5402281cb7b0452c1c5f367387b459 upstream

Enable USB3 nodes for the rk3328-based PINE Rock64 board.

The separate power regulator is not added as it is controlled by the
same GPIO line as the existing VBUS regulators, so it is already
enabled. Also there is no port representation to tie the regulator to.

[wens@csie.org: Rebased onto v5.12]

Signed-off-by: Cameron Nemo <cnemo@tutanota.com>
[wens@csie.org: Rewrote commit message]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20210504083616.9654-2-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
index 86cfb5c50a94..95ab6928cfd4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
@@ -384,6 +384,11 @@ &usb20_otg {
 	status = "okay";
 };
 
+&usbdrd3 {
+	dr_mode = "host";
+	status = "okay";
+};
+
 &usb_host0_ehci {
 	status = "okay";
 };
-- 
2.30.2
