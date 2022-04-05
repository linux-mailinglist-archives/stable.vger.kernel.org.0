Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2340C4F31AF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbiDEIoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241258AbiDEIc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4887F0E;
        Tue,  5 Apr 2022 01:30:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4195C60FF5;
        Tue,  5 Apr 2022 08:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D0FC385A2;
        Tue,  5 Apr 2022 08:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147456;
        bh=wHYZx+aC3TOMhk8Yv90DSLdpEeTUOTnRrQR0mwZOoRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mogbORoHNTgHxS9eLyuC01oI/UGy9jyGBW8/dAufpsMhxZ4/FweAZpDoxEdxMXRUQ
         nmgUkRXZqs6Otn+EeznieWVV5HznbPkHYzNmWU4+Mub0ZC3Q54sTHtowsdbOhPv96D
         Yot2txJTtQkbAvUQfnvZhc64zy+dIgYDNMo4/SVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 1092/1126] media: dt-binding: media: hynix,hi846: use $defs/port-base port description
Date:   Tue,  5 Apr 2022 09:30:39 +0200
Message-Id: <20220405070439.498943456@linuxfoundation.org>
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

From: Martin Kepplinger <martin.kepplinger@puri.sm>

commit 6492eba4fafb5a9715ecf78b7155e88f8f88909a upstream.

This fixes "make dt_binding_check":

    Documentation/devicetree/bindings/media/i2c/hynix,hi846.example.dt.yaml:
camera@20: port:endpoint: Unevaluated properties are not allowed
('link-frequencies', 'data-lanes' were unexpected)
    From schema: Documentation/devicetree/bindings/media/i2c/hynix,hi846.yaml

[Sakari Ailus: Reword commit message]

Fixes: f3ce7200ca18 ("media: dt-bindings: media: document SK Hynix Hi-846 MIPI CSI-2 8M pixel sensor")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/i2c/hynix,hi846.yaml |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/media/i2c/hynix,hi846.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/hynix,hi846.yaml
@@ -49,7 +49,8 @@ properties:
     description: Definition of the regulator used for the VDDD power supply.
 
   port:
-    $ref: /schemas/graph.yaml#/properties/port
+    $ref: /schemas/graph.yaml#/$defs/port-base
+    unevaluatedProperties: false
 
     properties:
       endpoint:


