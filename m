Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3679C2E3F8A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506246AbgL1Oll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:41:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502193AbgL1O2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46127221F0;
        Mon, 28 Dec 2020 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165641;
        bh=GZQImip1RSndTPwMcZat01nt7pCGE77F50qHxzTclnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xebkR5mjGQhx3bgmCFEk5UCnuYuNqoNUHXctpiJQ2lLlIPREwHzN4v3I87OiSmKH
         gO84pqomyIIX8x7yQVKnMg6uMIVUNQsZ07bM+lsPy3ZMHfv8zPHaoAttEj6YHc2aFz
         5rd5skBLCocsIYwKyDNiLd6ez3wChROlP6+VCVeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.10 603/717] ARM: dts: pandaboard: fix pinmux for gpio user button of Pandaboard ES
Date:   Mon, 28 Dec 2020 13:50:01 +0100
Message-Id: <20201228125049.796484814@linuxfoundation.org>
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


