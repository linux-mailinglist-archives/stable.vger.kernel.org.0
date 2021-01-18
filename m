Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC702FA914
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393604AbhARSmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390696AbhARLlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D41CD22CAD;
        Mon, 18 Jan 2021 11:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970049;
        bh=HKAnUPbhdRPB6nFPP2qwTCwloIBG8C2TQAgGybwtZvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZaXkuKkP0hqjyXVuyvOJwd1tWPPU6ttjFGsXLyTAD4lwqQsMh0co1v6vSVxyNCTe9
         7ctRNFDpzrCYGvZIsQZVhwuKnd6ZJx3TR6NARTtHV1287xOuVDn4i8AKMh198O3Wxw
         rv60+uXPhJUyXwLugwzWXUk9FI3NkgPVFIbz5qbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Gagniuc <mr.nuke.me@gmail.com>,
        Rob Herring <robh@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.10 016/152] dt-bindings: display: sii902x: Add supply bindings
Date:   Mon, 18 Jan 2021 12:33:11 +0100
Message-Id: <20210118113353.550704692@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

commit 4c1e054322da99cbfd293a5fddf283f2fdb3e2d0 upstream.

The sii902x chip family requires IO and core voltages to reach the
correct voltage before chip initialization. Add binding for describing
the two supplies.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201020221501.260025-3-mr.nuke.me@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/display/bridge/sii902x.txt |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/devicetree/bindings/display/bridge/sii902x.txt
+++ b/Documentation/devicetree/bindings/display/bridge/sii902x.txt
@@ -8,6 +8,8 @@ Optional properties:
 	- interrupts: describe the interrupt line used to inform the host
 	  about hotplug events.
 	- reset-gpios: OF device-tree gpio specification for RST_N pin.
+	- iovcc-supply: I/O Supply Voltage (1.8V or 3.3V)
+	- cvcc12-supply: Digital Core Supply Voltage (1.2V)
 
 	HDMI audio properties:
 	- #sound-dai-cells: <0> or <1>. <0> if only i2s or spdif pin
@@ -54,6 +56,8 @@ Example:
 		compatible = "sil,sii9022";
 		reg = <0x39>;
 		reset-gpios = <&pioA 1 0>;
+		iovcc-supply = <&v3v3_hdmi>;
+		cvcc12-supply = <&v1v2_hdmi>;
 
 		#sound-dai-cells = <0>;
 		sil,i2s-data-lanes = < 0 1 2 >;


