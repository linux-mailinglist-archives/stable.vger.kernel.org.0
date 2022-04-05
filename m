Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6234F3A05
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379033AbiDELkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354207AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE98254BDA;
        Tue,  5 Apr 2022 02:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 148A0B81B93;
        Tue,  5 Apr 2022 09:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6918FC385A2;
        Tue,  5 Apr 2022 09:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152724;
        bh=+1uthk7lYAmO9wnvrPL07V5fVwTvslmy0jK66nFRxSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zi4FH7fXcoTX5wxbjzuUTt+QEx/l1YRE9rz7rsnfM7nb0MyzKUv+0eP5iqjm4khF6
         IzakVZrh15FgHJO4p+LCedKhNSuH3WRfANdbF4Lr0x8x5Cpdx5nQyqJ7UGWyaN4vYv
         KGaNFGBPZUzAx5QclgZ74ZkwmrWuCpttZ6ySdbiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 881/913] dt-bindings: mtd: nand-controller: Fix the reg property description
Date:   Tue,  5 Apr 2022 09:32:23 +0200
Message-Id: <20220405070406.230911932@linuxfoundation.org>
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

commit 93f2ec9e401276fb4ea9903194a5bfcf175f9a2c upstream.

The reg property of a NAND device always references the chip-selects.
The ready/busy lines are described in the nand-rb property. I believe
this was a harmless copy/paste error during the conversion to yaml.

Fixes: 212e49693592 ("dt-bindings: mtd: Add YAML schemas for the generic NAND options")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20211216111654.238086-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mtd/nand-controller.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
@@ -55,7 +55,7 @@ patternProperties:
     properties:
       reg:
         description:
-          Contains the native Ready/Busy IDs.
+          Contains the chip-select IDs.
 
       nand-ecc-engine:
         allOf:


