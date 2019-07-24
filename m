Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD18573CAB
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbfGXT6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404463AbfGXT6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4366D205C9;
        Wed, 24 Jul 2019 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998286;
        bh=umptgDMJtNhneGaoTDOXdRurRf8fDTFuJGUd/2Z2I84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdFeRLZMOm5DrX5avEXCu5jpk/fqjV1woMVAU3wHfnv2i3hTWWLj7NYtFDvNH3+pa
         +eT2U7mwdbqegLUFvJvNloZtQmI3NCvsiawYWZpnqKTvSrxRkJB0E4lM/t/xFlo8F7
         sPmWkoOcYIL/n6EQYl/XtSmBLa9hPwZB7Wb1hv+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.1 313/371] ARM: dts: gemini: Set DIR-685 SPI CS as active low
Date:   Wed, 24 Jul 2019 21:21:05 +0200
Message-Id: <20190724191747.621408188@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit f90b8fda3a9d72a9422ea80ae95843697f94ea4a upstream.

The SPI to the display on the DIR-685 is active low, we were
just saved by the SPI library enforcing active low on everything
before, so set it as active low to avoid ambiguity.

Link: https://lore.kernel.org/r/20190715202101.16060-1-linus.walleij@linaro.org
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/gemini-dlink-dir-685.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/gemini-dlink-dir-685.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dir-685.dts
@@ -64,7 +64,7 @@
 		gpio-sck = <&gpio1 5 GPIO_ACTIVE_HIGH>;
 		gpio-miso = <&gpio1 8 GPIO_ACTIVE_HIGH>;
 		gpio-mosi = <&gpio1 7 GPIO_ACTIVE_HIGH>;
-		cs-gpios = <&gpio0 20 GPIO_ACTIVE_HIGH>;
+		cs-gpios = <&gpio0 20 GPIO_ACTIVE_LOW>;
 		num-chipselects = <1>;
 
 		panel: display@0 {


