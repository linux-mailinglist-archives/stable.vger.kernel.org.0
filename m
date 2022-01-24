Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B00499E48
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381934AbiAXWbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584592AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD58C0424E5;
        Mon, 24 Jan 2022 12:51:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B0E60B21;
        Mon, 24 Jan 2022 20:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE9AC340E5;
        Mon, 24 Jan 2022 20:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057516;
        bh=Q+kbtrSzN3sW0F+y05oRP18A4WGq9IVLlwKWgshlVIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OC5Ph9KqbvZXiXJNLoEYuP2OVy20E9wYr1qyWP6YNAVBb4KHb5QGqVriWNiIK0KUc
         wIYFNhnVrLzktdm2PgMLijp7CJXfFsphI0gpj3FFaaR7DLu/90L0PAeoU3qTiCc4fq
         tiQBB12GqWw9SejtIhQqin28R57q7wkA3nbS+mCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Stein <alexander.stein@mailbox.org>,
        Rob Herring <robh@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.15 839/846] dt-bindings: display: meson-vpu: Add missing amlogic,canvas property
Date:   Mon, 24 Jan 2022 19:45:56 +0100
Message-Id: <20220124184129.847445968@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


