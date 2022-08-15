Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446BE5937DD
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbiHOSdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242509AbiHOSdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:33:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AD9357C8;
        Mon, 15 Aug 2022 11:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE21460EBB;
        Mon, 15 Aug 2022 18:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC313C433C1;
        Mon, 15 Aug 2022 18:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587688;
        bh=qPM3hivwiyH/84iQwMJ7ypF9tf8CVifjS41QNQiOQD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1NEGbYZP2Wnx0e4OQY7IqIN8vKkxBUtV7WaYp9rLo293Z569zgI5b+3ZBX7znYlee
         dVGN91X+2BBALQpLyUnyMbvsZwsczMcFJm785+lioivsLHkUGiyrNCaXUW6V/Qw2yy
         N3hVz0G2XK+N9xdlfgRIf9mJU2WvC1VT9bAZl5hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Puranjay Mohan <puranjay12@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/779] dt-bindings: iio: accel: Add DT binding doc for ADXL355
Date:   Mon, 15 Aug 2022 19:56:48 +0200
Message-Id: <20220815180344.333074112@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Puranjay Mohan <puranjay12@gmail.com>

[ Upstream commit bf43a71a0a7f396434f6460b46e33eb00752f78d ]

Add devicetree binding document for ADXL355, a 3-Axis MEMS Accelerometer.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20210811073027.124619-2-puranjay12@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/iio/accel/adi,adxl355.yaml       | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/accel/adi,adxl355.yaml

diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl355.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl355.yaml
new file mode 100644
index 000000000000..ba54d6998f2e
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl355.yaml
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/iio/accel/adi,adxl355.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Analog Devices ADXL355 3-Axis, Low noise MEMS Accelerometer
+
+maintainers:
+  - Puranjay Mohan <puranjay12@gmail.com>
+
+description: |
+  Analog Devices ADXL355 3-Axis, Low noise MEMS Accelerometer that supports
+  both I2C & SPI interfaces
+    https://www.analog.com/en/products/adxl355.html
+
+properties:
+  compatible:
+    enum:
+      - adi,adxl355
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 1
+    maxItems: 3
+    description: |
+      Type for DRDY should be IRQ_TYPE_EDGE_RISING.
+      Three configurable interrupt lines exist.
+
+  interrupt-names:
+    description: Specify which interrupt line is in use.
+    items:
+      enum:
+        - INT1
+        - INT2
+        - DRDY
+    minItems: 1
+    maxItems: 3
+
+  vdd-supply:
+    description: Regulator that provides power to the sensor
+
+  vddio-supply:
+    description: Regulator that provides power to the bus
+
+  spi-max-frequency: true
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+        #include <dt-bindings/gpio/gpio.h>
+        #include <dt-bindings/interrupt-controller/irq.h>
+        i2c {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                /* Example for a I2C device node */
+                accelerometer@1d {
+                        compatible = "adi,adxl355";
+                        reg = <0x1d>;
+                        interrupt-parent = <&gpio>;
+                        interrupts = <25 IRQ_TYPE_EDGE_RISING>;
+                        interrupt-names = "DRDY";
+                };
+        };
+  - |
+        #include <dt-bindings/gpio/gpio.h>
+        #include <dt-bindings/interrupt-controller/irq.h>
+        spi {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                accelerometer@0 {
+                        compatible = "adi,adxl355";
+                        reg = <0>;
+                        spi-max-frequency = <1000000>;
+                        interrupt-parent = <&gpio>;
+                        interrupts = <25 IRQ_TYPE_EDGE_RISING>;
+                        interrupt-names = "DRDY";
+                };
+        };
-- 
2.35.1



