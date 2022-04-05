Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC574F2C52
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355694AbiDEKVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347543AbiDEJ11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:27:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D661DE916;
        Tue,  5 Apr 2022 02:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E61F8B81C6A;
        Tue,  5 Apr 2022 09:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5207AC385A2;
        Tue,  5 Apr 2022 09:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150113;
        bh=MOk/RdGK+fojtYaaJuzFPNg01OhU29vMlA4QzjbvP3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDVPdhfzMeGdr2oVw4liHn4zGV9dseEakbh+2Sdc5Y4L07wN7xlCzqA7arfCcRc1X
         gTGJQJt6BYs1DbfXZFdj7dtAmw/BDXBPByTRNB2a3mYEtHwBsEDEilCkIrRJnu5fcR
         nE3SqVm52SGyY6z6nLMITKJOUWZDH2wYKIK1ew/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.16 0957/1017] spi: Fix Tegra QSPI example
Date:   Tue,  5 Apr 2022 09:31:10 +0200
Message-Id: <20220405070422.615815858@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Jon Hunter <jonathanh@nvidia.com>

commit 320689a1b543ca1396b3ed43bb18045e4a7ffd79 upstream.

When running dt_binding_check on the nvidia,tegra210-quad.yaml binding
document the following error is reported ...

 nvidia,tegra210-quad.example.dt.yaml:0:0: /example-0/spi@70410000/flash@0:
 	failed to match any schema with compatible: ['spi-nor']

Update the example in the binding document to fix the above error.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Fixes: 9684752e5fe3 ("dt-bindings: spi: Add Tegra Quad SPI device tree  binding")
Link: https://lore.kernel.org/r/20220307113529.315685-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml
+++ b/Documentation/devicetree/bindings/spi/nvidia,tegra210-quad.yaml
@@ -106,7 +106,7 @@ examples:
             dma-names = "rx", "tx";
 
             flash@0 {
-                    compatible = "spi-nor";
+                    compatible = "jedec,spi-nor";
                     reg = <0>;
                     spi-max-frequency = <104000000>;
                     spi-tx-bus-width = <2>;


