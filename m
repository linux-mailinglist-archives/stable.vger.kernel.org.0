Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E66422EA51
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 12:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgG0KrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 06:47:18 -0400
Received: from mailout07.rmx.de ([94.199.90.95]:38535 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgG0KrS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 06:47:18 -0400
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2020 06:47:16 EDT
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4BFbMD11YnzBwPs;
        Mon, 27 Jul 2020 12:16:56 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BFbLR2TMWz2xFJ;
        Mon, 27 Jul 2020 12:16:15 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.121) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 27 Jul
 2020 12:16:15 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Rob Herring <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald-Stadler" <pmeerw@pmeerw.net>,
        Jiri Kosina <trivial@kernel.org>,
        Christian Eggers <ceggers@arri.de>, <stable@vger.kernel.org>
Subject: [PATCH] dt-bindings: iio: io-channel-mux: Fix compatible string in example code
Date:   Mon, 27 Jul 2020 12:16:05 +0200
Message-ID: <20200727101605.24384-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.121]
X-RMX-ID: 20200727-121615-4BFbLR2TMWz2xFJ-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The correct compatible string is "gpio-mux" (see
bindings/mux/gpio-mux.txt).

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 .../devicetree/bindings/iio/multiplexer/io-channel-mux.txt      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt b/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt
index c82794002595..89647d714387 100644
--- a/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt
+++ b/Documentation/devicetree/bindings/iio/multiplexer/io-channel-mux.txt
@@ -21,7 +21,7 @@ controller state. The mux controller state is described in
 
 Example:
 	mux: mux-controller {
-		compatible = "mux-gpio";
+		compatible = "gpio-mux";
 		#mux-control-cells = <0>;
 
 		mux-gpios = <&pioA 0 GPIO_ACTIVE_HIGH>,
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

