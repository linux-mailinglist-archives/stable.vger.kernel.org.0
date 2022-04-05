Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D6B4F2569
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiDEHtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiDEHr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7D892867;
        Tue,  5 Apr 2022 00:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BD5F616C4;
        Tue,  5 Apr 2022 07:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C15C340EE;
        Tue,  5 Apr 2022 07:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144724;
        bh=8EEY95TxpF936PDJ+mCL90Eb807SR//DOOEt2RlxtWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buiXvy2BFx1/jGFQWzLv0DgdbTKAPAHo5oA/h+v6tHuQ9DGZgxLa1JlbZ4E5ogfeC
         hwM1TCtSlhSRzQBWFeMatZYJRIhMDN7P8rDuXJC+RAinG0l/4WJk5fIjN9uKoV+DyP
         kNMfAaIblFr9CHePEfeD58+PbQSC+MrUVigfkd4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 5.17 0149/1126] ARM: dts: at91: sama7g5: Remove unused properties in i2c nodes
Date:   Tue,  5 Apr 2022 09:14:56 +0200
Message-Id: <20220405070411.957745687@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -382,8 +382,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(7)>,
 					<&dma0 AT91_XDMAC_DT_PERID(8)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -558,8 +556,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(21)>,
 					<&dma0 AT91_XDMAC_DT_PERID(22)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -584,8 +580,6 @@
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(23)>,
 					<&dma0 AT91_XDMAC_DT_PERID(24)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};


