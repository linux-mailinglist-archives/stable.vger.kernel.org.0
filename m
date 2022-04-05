Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ACE4F2C20
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiDEIoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241255AbiDEIc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE6662EE;
        Tue,  5 Apr 2022 01:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC46609D0;
        Tue,  5 Apr 2022 08:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0964C385A1;
        Tue,  5 Apr 2022 08:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147451;
        bh=wYBk6rN2/OlxhSRKIP2CH/M6OSQISZIo3MuzDWbA440=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIC6x32EelyOLg1XtDruIvPiutXJohgBAvRwUXi+egKQT4KY0WZbHGJnbueqjH3kU
         8kdjWN07Bz5o87zJHE132AV4pOvJPmTdAMsL/H7HJorEJcIGBtgoWYFxI97y/dI6gW
         q+EXdtCPk0gzQILmLSUBumrCnwHAkMAbSk4z6264=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.17 1090/1126] dt-bindings: mtd: nand-controller: Fix a comment in the examples
Date:   Tue,  5 Apr 2022 09:30:37 +0200
Message-Id: <20220405070439.442224776@linuxfoundation.org>
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
@@ -184,7 +184,7 @@ examples:
         nand-use-soft-ecc-engine;
         nand-ecc-algo = "bch";
 
-        /* controller specific properties */
+        /* NAND chip specific properties */
       };
 
       nand@1 {


