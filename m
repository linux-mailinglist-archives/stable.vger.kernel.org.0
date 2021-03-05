Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E3932E8E7
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhCEM3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:29:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhCEM3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:29:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDFCD65013;
        Fri,  5 Mar 2021 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947349;
        bh=ESZl0lMR52hfd5iJ4WVSFU7pMyLHt+qt4WgMIyOF3t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWMrRiPgdDrUFhxDC2QsSYlEW+7bem1fEoHwdtRe/PZ/vcilzhSBwp2FQeI9T/TpY
         /nLI+bjeJbwLskXfxCR9Z8Ky3WrIuNph4PYbHmFQPzNZudTajoEB0jsauOXRpwpRhx
         Z+KX/tfAsaC+LfQxIUuOI9+MafEnxUPfNav9Yfek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.10 033/102] dt-bindings: net: btusb: DT fix s/interrupt-name/interrupt-names/
Date:   Fri,  5 Mar 2021 13:20:52 +0100
Message-Id: <20210305120904.912906945@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit f288988930e93857e0375bdf88bb670c312b82eb upstream.

The standard DT property name is "interrupt-names".

Fixes: fd913ef7ce619467 ("Bluetooth: btusb: Add out-of-band wakeup support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Acked-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/btusb.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/net/btusb.txt
+++ b/Documentation/devicetree/bindings/net/btusb.txt
@@ -38,7 +38,7 @@ Following example uses irq pin number 3
 	compatible = "usb1286,204e";
 	reg = <1>;
 	interrupt-parent = <&gpio0>;
-	interrupt-name = "wakeup";
+	interrupt-names = "wakeup";
 	interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
     };
 };


