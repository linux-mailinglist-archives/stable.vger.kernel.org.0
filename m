Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4096D4F29F9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbiDEKkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243692AbiDEJkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD96B0A72;
        Tue,  5 Apr 2022 02:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EF8614F9;
        Tue,  5 Apr 2022 09:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA0EC385A0;
        Tue,  5 Apr 2022 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150692;
        bh=xrHz9wZKNUYJ0hOqUhbpLhkKn96N95JVuiFTxojv6kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PK+VHNagBo7HHqGD0ijO3uqaxsu19gjHJDh+KKw91gfbu0RHuKmejVeFoopuySMT5
         cWXP41Vpl1Rgh7GKZfIE8TTQ9YcNt6FjIvEKSW0DTFPDRfjLZr1xO5bsr1s4kcbSfa
         EF235o3HjwjUNqMYXoxGr8JQzCUMsEf+ipjePdns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.15 146/913] ARM: dts: at91: sama7g5: Remove unused properties in i2c nodes
Date:   Tue,  5 Apr 2022 09:20:08 +0200
Message-Id: <20220405070344.211954659@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit cbb92a7717d2e1c512b7e81c6b22c7298b58a881 upstream.

The "atmel,use-dma-rx", "atmel,use-dma-rx" dt properties are not used by
the i2c-at91 driver, nor they are defined in the bindings file, thus remove
them.

Cc: stable@vger.kernel.org
Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220302161854.32177-1-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama7g5.dtsi |    6 ------
 1 file changed, 6 deletions(-)

--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -319,8 +319,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(7)>,
 					<&dma0 AT91_XDMAC_DT_PERID(8)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -485,8 +483,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(21)>,
 					<&dma0 AT91_XDMAC_DT_PERID(22)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -511,8 +507,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(23)>,
 					<&dma0 AT91_XDMAC_DT_PERID(24)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};


