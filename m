Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85C1D83EF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgERSIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387419AbgERSHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6110820826;
        Mon, 18 May 2020 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825254;
        bh=RwtWXpxjsYCHwzvvSeug+dz9JtaWMYFqL9TctgSNbfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxaYoAE5nJJMxKqZNGLry+vEG+AcPsRg7a7xlI6wq7xTQP3LPyYUaX4tlYOJeWMvy
         6DMmD3s2VmMCfMp3yOIVxyEXAAjyUAtpFO0SGA5A40H7iBnqDQfkaoi7WP4KxDsrkr
         /trVT1XkuLq+XI9oSiEs7wuF54Sh4kthsg//MVrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.6 164/194] arm64: dts: meson-g12b-ugoos-am6: fix usb vbus-supply
Date:   Mon, 18 May 2020 19:37:34 +0200
Message-Id: <20200518173544.876058311@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

commit 4e025fd91ba32a16ed8131158aa63cd37d141cbb upstream.

The USB supply used the wrong property, fixing:
meson-g12b-ugoos-am6.dt.yaml: usb@ffe09000: 'vbus-regulator' does not match any of the regexes: '^usb@[0-9a-f]+$', 'pinctrl-[0-9]+'

Fixes: 2cd2310fca4c ("arm64: dts: meson-g12b-ugoos-am6: add initial device-tree")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20200326160857.11929-2-narmstrong@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dts
@@ -545,7 +545,7 @@
 &usb {
 	status = "okay";
 	dr_mode = "host";
-	vbus-regulator = <&usb_pwr_en>;
+	vbus-supply = <&usb_pwr_en>;
 };
 
 &usb2_phy0 {


