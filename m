Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E392E3BFD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406552AbgL1N5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406549AbgL1N5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58FC321D94;
        Mon, 28 Dec 2020 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163789;
        bh=GZQImip1RSndTPwMcZat01nt7pCGE77F50qHxzTclnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mK1CsH26D2csboNcoxGv+noBoWcVTSiX/pqMQnEeb7LlUhlu0k8Rv3S5E20OVyPN/
         BsR3bCSrJKKsr23lUHTiu0BxH97EsdV0/uvTv8dGDMPbR6Ilk7F03UBFGxn1NHqBkz
         lNmPXXjSkwxy/xQada/adw1C9KA1CBTD6Wm8rVPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.4 377/453] ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES
Date:   Mon, 28 Dec 2020 13:50:13 +0100
Message-Id: <20201228124955.343903877@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -46,7 +46,7 @@
 
 	button_pins: pinmux_button_pins {
 		pinctrl-single,pins = <
-			OMAP4_IOPAD(0x11b, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
+			OMAP4_IOPAD(0x0fc, PIN_INPUT_PULLUP | MUX_MODE3) /* gpio_113 */
 		>;
 	};
 };


