Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CCE5015E6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbiDNOPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346456AbiDNN5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6E45FF0B;
        Thu, 14 Apr 2022 06:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C395B82985;
        Thu, 14 Apr 2022 13:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3495C385A5;
        Thu, 14 Apr 2022 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943998;
        bh=+r+nESv/qzOm6IdEf29mDmUPKKrFEOEg5L6QpN7iQjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wxejdwaRORRR0TsWDqP58k3TZmjVvoR2mqAnC0mNdQoB/V9w4lfvtJU4P7ICVlzC
         3AQdS2jqL/20F0r0T5Z1yFvwnBW+wWCYpGrrgMexxsqXmvycV6vipmj7Z14t84tser
         crP5+bYAT9HttWRmYzWekHuPMYH1qb5cEVl21GXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 358/475] dt-bindings: mtd: nand-controller: Fix a comment in the examples
Date:   Thu, 14 Apr 2022 15:12:23 +0200
Message-Id: <20220414110905.101640914@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

commit 0e7f1b557974ce297e5e4c9d4245720fbb489886 upstream.

The controller properties should be in the controller 'parent' node,
while properties in the children nodes are specific to the NAND
*chip*. This error was already present during the yaml conversion.

Fixes: 2d472aba15ff ("mtd: nand: document the NAND controller/NAND chip DT representation")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/linux-mtd/20211216111654.238086-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mtd/nand-controller.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mtd/nand-controller.yaml
+++ b/Documentation/devicetree/bindings/mtd/nand-controller.yaml
@@ -139,6 +139,6 @@ examples:
         nand-ecc-mode = "soft";
         nand-ecc-algo = "bch";
 
-        /* controller specific properties */
+        /* NAND chip specific properties */
       };
     };


