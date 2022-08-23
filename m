Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560A259D5AF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243239AbiHWI1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243698AbiHWIZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0043D71BE0;
        Tue, 23 Aug 2022 01:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B7561228;
        Tue, 23 Aug 2022 08:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE34EC433D6;
        Tue, 23 Aug 2022 08:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242404;
        bh=/9L/V64GOfJegWqVypiLB77vzs67y2ykCnPES2HTip8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRwExk4jQikcDcuO87VCUQGe9ZFek3LZem2uisc4DRWiuERW89WY7cBPyEFY/VzzM
         hrLlMNek5vGbmoULm7CeXFfHIv8m9dwgBd11y+I6qLHfGr0j0noaIBAAG+uNJJYi/D
         S7LUDJgw+M0JjzNz8WvYI+Tcq6WTEWkRMcoYciCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 110/365] dt-bindings: input: iqs7222: Remove support for RF filter
Date:   Tue, 23 Aug 2022 10:00:11 +0200
Message-Id: <20220823080122.807189406@linuxfoundation.org>
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

From: Jeff LaBundy <jeff@labundy.com>

commit f5d2c1ed72c26152e6883ed67dc3004a39165098 upstream.

The vendor has marked the RF filter enable control as reserved in
the datasheet; remove it from the binding.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-8-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index a3a1e5a65306..6180f7ee2284 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -37,10 +37,6 @@ properties:
       device is temporarily held in hardware reset prior to initialization if
       this property is present.
 
-  azoteq,rf-filt-enable:
-    type: boolean
-    description: Enables the device's internal RF filter.
-
   azoteq,max-counts:
     $ref: /schemas/types.yaml#/definitions/uint32
     enum: [0, 1, 2, 3]
-- 
2.37.2



