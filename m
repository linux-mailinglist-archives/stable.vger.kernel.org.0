Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A459E349
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbiHWMSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355155AbiHWMPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0796598D12;
        Tue, 23 Aug 2022 02:41:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDF2961460;
        Tue, 23 Aug 2022 09:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ECAC433C1;
        Tue, 23 Aug 2022 09:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247607;
        bh=oyDLGCSu9zgousUVgIFHeW73Sm2SW2iFyiH40jFxiGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nthw3chWYzwpGgYnBOclz8KXuhZ5qI1s9XwFLtmea0dVw6cVJE8Umpkgd5M13Xqln
         EfQ1HkDT3vPCTsdZUHV3Lw3oEEd0PdCzRdar9uf+oNq8Gr1tTiyT/Ps2kgUdY2dopS
         8ENJL0T7ixfdHG4R2BWoEhl13IO2ARz2Prm94yEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Subject: [PATCH 5.10 088/158] regulator: pca9450: Remove restrictions for regulator-name
Date:   Tue, 23 Aug 2022 10:27:00 +0200
Message-Id: <20220823080049.607876277@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit b0de7fa706506bf0591037908376351beda8c5d6 upstream.

The device bindings shouldn't put any constraints on the regulator-name
property specified in the generic bindings. This allows using arbitrary
and descriptive names for the regulators.

Suggested-by: Mark Brown <broonie@kernel.org>
Fixes: 7ae9e3a6bf3f ("dt-bindings: regulator: add pca9450 regulator yaml")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20220802064335.8481-1-frieder@fris.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/regulator/nxp,pca9450-regulator.yaml     | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml b/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
index b539781e39aa..835b53302db8 100644
--- a/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/nxp,pca9450-regulator.yaml
@@ -47,12 +47,6 @@ properties:
         description:
           Properties for single LDO regulator.
 
-        properties:
-          regulator-name:
-            pattern: "^LDO[1-5]$"
-            description:
-              should be "LDO1", ..., "LDO5"
-
         unevaluatedProperties: false
 
       "^BUCK[1-6]$":
@@ -62,11 +56,6 @@ properties:
           Properties for single BUCK regulator.
 
         properties:
-          regulator-name:
-            pattern: "^BUCK[1-6]$"
-            description:
-              should be "BUCK1", ..., "BUCK6"
-
           nxp,dvs-run-voltage:
             $ref: "/schemas/types.yaml#/definitions/uint32"
             minimum: 600000
-- 
2.37.2



