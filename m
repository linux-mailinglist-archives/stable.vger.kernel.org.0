Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158BC639B4B
	for <lists+stable@lfdr.de>; Sun, 27 Nov 2022 15:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiK0ONf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 09:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiK0ONb (ORCPT
        <rfc822;Stable@vger.kernel.org>); Sun, 27 Nov 2022 09:13:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3C16362
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 06:13:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5871960DCF
        for <Stable@vger.kernel.org>; Sun, 27 Nov 2022 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470BCC433D6;
        Sun, 27 Nov 2022 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669558409;
        bh=5BB1uokzk9hsgYpI0sGnFctU+Q06Gw+wkDeDqIb2AQs=;
        h=Subject:To:From:Date:From;
        b=jK218dbvUuuuUh/1Gd3X4r0HRMco69VSYwMszWCiJ/PN8IFxinqrbb4CDZmcH8Kin
         MbQZIy/O41j1wqGD8ghW5L4E59Ks+NjOF+0rv0QwCx4UpkUPz3qrnZBZ7v2L1/bO+X
         zXpPCs+bXy8qCHjxbZs2OyILyRKnHQ04ApyTPyTg=
Subject: patch "dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"" added to char-misc-next
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, robh@kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Nov 2022 15:06:11 +0100
Message-ID: <166955797174150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 398e3479874f381cca8726ca5d8a31e1bf35a3cd Mon Sep 17 00:00:00 2001
From: Billy Tsai <billy_tsai@aspeedtech.com>
Date: Mon, 14 Nov 2022 10:50:57 +0800
Subject: dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"

If the property is set on a device without valid trimming data in the OTP
the ADC will not function correctly. Therefore, this patch drops the use
of this property to avoid this scenario.

Fixes: 2bdb2f00a895 ("dt-bindings: iio: adc: Add ast2600-adc bindings")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221114025057.10843-2-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 .../devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml    | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
index b283c8ca2bbf..5c08d8b6e995 100644
--- a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
@@ -62,13 +62,6 @@ properties:
     description:
       Inform the driver that last channel will be used to sensor battery.
 
-  aspeed,trim-data-valid:
-    type: boolean
-    description: |
-      The ADC reference voltage can be calibrated to obtain the trimming
-      data which will be stored in otp. This property informs the driver that
-      the data store in the otp is valid.
-
 required:
   - compatible
   - reg
-- 
2.38.1


