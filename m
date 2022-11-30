Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D0C63DFEC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiK3Svu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiK3Svl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046C663D41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5669161D59
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D64C433D6;
        Wed, 30 Nov 2022 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834299;
        bh=PxbBhqLifgPHq9HvqD2LzN/LhOH9jtfw8IIdMOVcfa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4vguGLMNAaNeEqVJczTClRN3IfpK1FyhKHK/K0gauJjV2aqvryZXo1sFzE1fKXqX
         GvSSHUaWzyjZSI6iUgcmN5fG3oPVUZTjI8+NdHLfMml91mcV+qL22zxKsJIidI9fYb
         GPMd0neVH94Q8JehObBIXBfb1F4/6o2RiaA7Ws6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Billy Tsai <billy_tsai@aspeedtech.com>,
        Rob Herring <robh@kernel.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.0 175/289] dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"
Date:   Wed, 30 Nov 2022 19:22:40 +0100
Message-Id: <20221130180548.096921200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 398e3479874f381cca8726ca5d8a31e1bf35a3cd upstream.

If the property is set on a device without valid trimming data in the OTP
the ADC will not function correctly. Therefore, this patch drops the use
of this property to avoid this scenario.

Fixes: 2bdb2f00a895 ("dt-bindings: iio: adc: Add ast2600-adc bindings")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221114025057.10843-2-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml |    7 -------
 1 file changed, 7 deletions(-)

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


