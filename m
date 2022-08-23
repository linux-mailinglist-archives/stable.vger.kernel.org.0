Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB59F59D5BD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbiHWIm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347040AbiHWIkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6818778235;
        Tue, 23 Aug 2022 01:19:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26051B81C3D;
        Tue, 23 Aug 2022 08:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658F3C433D7;
        Tue, 23 Aug 2022 08:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242685;
        bh=/carbxVV3VvTz4u1LFowtEwvPwCtkus8sQIzpgS3zJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doDimdvGBft8EOv7hceLZuzNlDEPajNzr2uEwvc9O2xm5mAre/gAmOFBPNnfNWpoX
         fsRGHT5Fx8L5s5FblfOq+iCOIGvtpjHSNqjgUx73zhstyBY7NahIaYBiO0mCI6D4Yy
         fJ0BZDIUjTgKaPq84Jh6qSTtiRJ8R6BB67VgILn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Michal Simek <michal.simek@amd.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.19 133/365] spi: dt-bindings: cadence: add missing required
Date:   Tue, 23 Aug 2022 10:00:34 +0200
Message-Id: <20220823080123.753330405@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 6eee27c598fde65988723b785a9c9192d5ffb93a upstream.

During the conversion the bindings lost list of required properties.

Fixes: aa7968682a2b ("spi: convert Cadence SPI bindings to YAML")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20220704130618.199231-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/spi-cadence.yaml |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/devicetree/bindings/spi/spi-cadence.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-cadence.yaml
@@ -49,6 +49,13 @@ properties:
     enum: [ 0, 1 ]
     default: 0
 
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clock-names
+  - clocks
+
 unevaluatedProperties: false
 
 examples:


