Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC404DD94C
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiCRL6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbiCRL6o (ORCPT
        <rfc822;Stable@vger.kernel.org>); Fri, 18 Mar 2022 07:58:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F842E1072
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 04:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9C2D6132A
        for <Stable@vger.kernel.org>; Fri, 18 Mar 2022 11:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2675C340F2;
        Fri, 18 Mar 2022 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647604644;
        bh=nGpM2/Tq9piauGDlF/9pfuFK22N6yfFs7fgCbynJ0Yg=;
        h=Subject:To:From:Date:From;
        b=TDzttLNe3CuZ7G2Q4G1ANDLAeEKcFdS9FmgOoeWQ5ej4iffj2cW8t3ijucKwVn1C9
         dzuz3tMNK4qcAROM6W46kbooCjiA0CHqOKenP5gYdY/eWmncDKX/oePrwxI6vSM00O
         kfx+Z3TmDxPYMbW7oUVieucU3ReVQoLM//j/gVVM=
Subject: patch "dt-bindings: iio: adc: zynqmp_ams: Add clock entry" added to char-misc-testing
To:     robert.hancock@calian.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, michal.simek@xilinx.com, robh@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Mar 2022 12:43:49 +0100
Message-ID: <1647603829206154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    dt-bindings: iio: adc: zynqmp_ams: Add clock entry

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 5165102efa41c2aedc77441612f4506a8a8671db Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Thu, 27 Jan 2022 11:34:47 -0600
Subject: dt-bindings: iio: adc: zynqmp_ams: Add clock entry

The AMS driver DT binding was missing the clock entry, which is actually
mandatory according to the driver implementation. Add this in.

Fixes: 39dd2d1e251d ("dt-bindings: iio: adc: Add Xilinx AMS binding documentation")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/20220127173450.3684318-2-robert.hancock@calian.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 .../devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml      | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml b/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml
index 87992db389b2..3698b4b0900f 100644
--- a/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/xlnx,zynqmp-ams.yaml
@@ -92,6 +92,10 @@ properties:
     description: AMS Controller register space
     maxItems: 1
 
+  clocks:
+    items:
+      - description: AMS reference clock
+
   ranges:
     description:
       Maps the child address space for PS and/or PL.
@@ -181,12 +185,15 @@ properties:
 required:
   - compatible
   - reg
+  - clocks
   - ranges
 
 additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/xlnx-zynqmp-clk.h>
+
     bus {
         #address-cells = <2>;
         #size-cells = <2>;
@@ -196,6 +203,7 @@ examples:
             interrupt-parent = <&gic>;
             interrupts = <0 56 4>;
             reg = <0x0 0xffa50000 0x0 0x800>;
+            clocks = <&zynqmp_clk AMS_REF>;
             #address-cells = <1>;
             #size-cells = <1>;
             #io-channel-cells = <1>;
-- 
2.35.1


