Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B938F2E426A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436653AbgL1PWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:22:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408196AbgL1OB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 429E8207A9;
        Mon, 28 Dec 2020 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164070;
        bh=oIU7PlTYB7Ozwx+0YOvB968wcTowWf/f2sSjhiCt/8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whZaTyQ1FD6anKGdQOgjD1tRqtwEZnozjz6X6dd3DMX32ndLnuJOrKa2oaWlHByCb
         iyNPZtUyrgx6WNeHRYtK8VQSPkyeeYMFlR0oj31z4kE55WRZkLxP6AqU0EYB8fbXVM
         qSdB5Mubd1IhEYHWhLhQrxbMo5Ijqs/lCRd2BaXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/717] arm64: dts: renesas: cat875: Remove rxc-skew-ps from ethernet-phy node
Date:   Mon, 28 Dec 2020 13:40:06 +0100
Message-Id: <20201228125021.385627404@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 53e573dc39fba1834f3e4fa002cb754b61a30701 ]

The CAT875 sub board from Silicon Linux uses Realtek phy and the driver
does not support rxc-skew-ps property.

Fixes: 6b170cd3ed02949f ("arm64: dts: renesas: cat875: Add ethernet support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20201015132350.8360-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/cat875.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi b/arch/arm64/boot/dts/renesas/cat875.dtsi
index 33daa95706840..801ea54b027c4 100644
--- a/arch/arm64/boot/dts/renesas/cat875.dtsi
+++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
@@ -21,7 +21,6 @@
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <21 IRQ_TYPE_LEVEL_LOW>;
-- 
2.27.0



