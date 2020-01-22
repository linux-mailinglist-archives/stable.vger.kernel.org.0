Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D310F145651
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgAVN0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgAVN0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:01 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47EF82467F;
        Wed, 22 Jan 2020 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699561;
        bh=vnCbnJn57A55BNTw5QnrBbMb+AOMDapj65Mc6U1LwdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKXqE3wG1u1Z/ZrVpEW7+LRkNo4i6yRWZJX2hTNuZP87laPePl/Ee5r8H/HndNYjN
         j+TCl6LO66pidRAG0tFHV7+D/2SriDd39nZEgfQCOvZ/B7RFj7iaTppt2Hh10GXiFF
         nRsVeGB1s+xSFRufQOg/h6dN6zBL7A0OPO13jKpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 5.4 179/222] arm64: dts: renesas: r8a77970: Fix PWM3
Date:   Wed, 22 Jan 2020 10:29:25 +0100
Message-Id: <20200122092846.509666279@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

commit 28a1b34c00dad4be91108369ca25ef8dc8bf850d upstream.

The pwm3 was incorrectly added with a compatible reference to the
renesas,pwm-r8a7790 (H2) due to a single characther ommision.

Fix the compatible string.

Fixes: de625477c632 ("arm64: dts: renesas: r8a779{7|8}0: add PWM support")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Link: https://lore.kernel.org/r/20190912103143.985-1-kieran.bingham+renesas@ideasonboard.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/renesas/r8a77970.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -652,7 +652,7 @@
 		};
 
 		pwm3: pwm@e6e33000 {
-			compatible = "renesas,pwm-r8a7790", "renesas,pwm-rcar";
+			compatible = "renesas,pwm-r8a77970", "renesas,pwm-rcar";
 			reg = <0 0xe6e33000 0 8>;
 			#pwm-cells = <2>;
 			clocks = <&cpg CPG_MOD 523>;


