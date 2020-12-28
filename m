Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7994A2E6525
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393235AbgL1P5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390196AbgL1NeY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10AE521D94;
        Mon, 28 Dec 2020 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162423;
        bh=RR43aPk48dbG4yENq2dC3AtIW2qeyAkKaAk+MLeDzC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1uUKVWVYea0pXPV/pN/ZQy2bZjILm78b7yumpPzts68sogsZMZjQGAKVzR6U5tJo
         pi8waHJXmpUx0JxQk4tTpzNcCx6nS+f/rbjs6DLT0iXmoS9VpDJ41m4awq4dzgFrkN
         FD7YW0GRnO+o5GN18jemmS5zie5gJWTLd7QFq7OQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 300/346] ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES
Date:   Mon, 28 Dec 2020 13:50:19 +0100
Message-Id: <20201228124934.287904655@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

commit df9dbaf2c415cd94ad520067a1eccfee62f00a33 upstream.

The pinmux control register offset passed to OMAP4_IOPAD is odd.

Fixes: ab9a13665e7c ("ARM: dts: pandaboard: add gpio user button")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/omap4-panda-es.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -49,7 +49,7 @@
 
 	button_pins: pinmux_button_pins {
 		pinctrl-single,pins = <
-			OMAP4_IOPAD(0x11b, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
+			OMAP4_IOPAD(0x0fc, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
 		>;
 	};
 };


