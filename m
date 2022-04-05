Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6514F4F3A06
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379041AbiDELkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354209AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC0155493;
        Tue,  5 Apr 2022 02:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6852B817D3;
        Tue,  5 Apr 2022 09:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1559DC385A2;
        Tue,  5 Apr 2022 09:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152730;
        bh=sJSheh81ofmzuFi2QYxChCQ6v4L0lE96fuuZkjzo0JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXTgWPJMU1KvMnF8pO5cQ1hQRu1EeFLs94mEF5dIxQbfEvvhd+YC92mL+P1yzT1NV
         EuUcMH8RMSw6nbHjX02zEjRslQjWSGZxX3g1Pnu2NCEgSJXibYXm5snsHdxAKVrcLc
         KwLA7qGDNAiPrLRwO8IQ5Nz4PrRWkr9HS0feV9Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 883/913] dt-bindings: spi: mxic: The interrupt property is not mandatory
Date:   Tue,  5 Apr 2022 09:32:25 +0200
Message-Id: <20220405070406.290170525@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 90c204d3195a795f77f5bce767e311dd1c59ca17 upstream.

The interrupt property is not mandatory at all, this property should not
be part of the required properties list, so move it into the optional
properties list.

Fixes: 326e5c8d4a87 ("dt-binding: spi: Document Macronix controller bindings")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20211216111654.238086-8-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/spi-mxic.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/spi/spi-mxic.txt
+++ b/Documentation/devicetree/bindings/spi/spi-mxic.txt
@@ -8,11 +8,13 @@ Required properties:
 - reg: should contain 2 entries, one for the registers and one for the direct
        mapping area
 - reg-names: should contain "regs" and "dirmap"
-- interrupts: interrupt line connected to the SPI controller
 - clock-names: should contain "ps_clk", "send_clk" and "send_dly_clk"
 - clocks: should contain 3 entries for the "ps_clk", "send_clk" and
 	  "send_dly_clk" clocks
 
+Optional properties:
+- interrupts: interrupt line connected to the SPI controller
+
 Example:
 
 	spi@43c30000 {


