Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A562749A367
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365331AbiAXXul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:50:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53744 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573122AbiAXVo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:44:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A81BFB815A2;
        Mon, 24 Jan 2022 21:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC2AC340E4;
        Mon, 24 Jan 2022 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060662;
        bh=Q+kbtrSzN3sW0F+y05oRP18A4WGq9IVLlwKWgshlVIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GbOkb+G5A3W13F6hvzJOQoSf18AaT+/IX74meYhGZGsrQEC+oACTuhJVB5GUwCjQ
         lJCXv3v1Ek8ax/sLmuBux3A+Jzew7SxGRCOxFY2+rTglAvC9Rsc810HMCHb8391PHz
         yH+bSlZ19Nv1KP0H8HoCRUFa+ZqeWSNdF9BLzcsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@mailbox.org>,
        Rob Herring <robh@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.16 1023/1039] dt-bindings: display: meson-vpu: Add missing amlogic,canvas property
Date:   Mon, 24 Jan 2022 19:46:52 +0100
Message-Id: <20220124184159.682617668@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@mailbox.org>

commit 640f35b871d29cd685ce0ea0762636381beeb98a upstream.

This property was already mentioned in the old textual bindings
amlogic,meson-vpu.txt, but got dropped during conversion.
Adding it back similar to amlogic,gx-vdec.yaml.

Fixes: 6b9ebf1e0e67 ("dt-bindings: display: amlogic, meson-vpu: convert to yaml")
Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211219094155.177206-1-alexander.stein@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
+++ b/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
@@ -78,6 +78,10 @@ properties:
   interrupts:
     maxItems: 1
 
+  amlogic,canvas:
+    description: should point to a canvas provider node
+    $ref: /schemas/types.yaml#/definitions/phandle
+
   power-domains:
     maxItems: 1
     description: phandle to the associated power domain
@@ -106,6 +110,7 @@ required:
   - port@1
   - "#address-cells"
   - "#size-cells"
+  - amlogic,canvas
 
 additionalProperties: false
 
@@ -118,6 +123,7 @@ examples:
         interrupts = <3>;
         #address-cells = <1>;
         #size-cells = <0>;
+        amlogic,canvas = <&canvas>;
 
         /* CVBS VDAC output port */
         port@0 {


