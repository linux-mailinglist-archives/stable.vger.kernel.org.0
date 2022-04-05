Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60FF4F3225
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245471AbiDEI4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbiDEIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5633217073;
        Tue,  5 Apr 2022 01:29:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E95F1B81B18;
        Tue,  5 Apr 2022 08:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D64C385A5;
        Tue,  5 Apr 2022 08:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147351;
        bh=b9u20PZhQs/jTWosZgSYdjk7kUpAxmrC0Cj9hgZHClU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOTrOTY1G+5KrCk/M4sLqxl7T6C1YdOF9cW/Pl/5KBJb5nkBbqdW2In/Cf53xVLL1
         JQJAhTPjQXxjiWyQT6KgPGmz7t5X7S4a7pUXcJQsvOFxPvkEzCv/Lan1L/bDQlGCa3
         5raWlItIB7mujAjxEggklQDuzJM82xGXivv7lBMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.17 1094/1126] dt-bindings: memory: mtk-smi: Rename clock to clocks
Date:   Tue,  5 Apr 2022 09:30:41 +0200
Message-Id: <20220405070439.556591526@linuxfoundation.org>
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

From: Yong Wu <yong.wu@mediatek.com>

commit 5bf7fa48374eafe29dbb30448a0b0c083853583f upstream.

The property "clock" should be rename to "clocks", and delete the "items",
the minItems/maxItems should not be put under "items".

Fixes: 27bb0e42855a ("dt-bindings: memory: mediatek: Convert SMI to DT schema")
Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20220113111057.29918-2-yong.wu@mediatek.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml |   28 ++++------
 Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml   |   14 ++---
 2 files changed, 18 insertions(+), 24 deletions(-)

--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.yaml
@@ -88,10 +88,9 @@ allOf:
               - mediatek,mt2701-smi-common
     then:
       properties:
-        clock:
-          items:
-            minItems: 3
-            maxItems: 3
+        clocks:
+          minItems: 3
+          maxItems: 3
         clock-names:
           items:
             - const: apb
@@ -108,10 +107,9 @@ allOf:
       required:
         - mediatek,smi
       properties:
-        clock:
-          items:
-            minItems: 3
-            maxItems: 3
+        clocks:
+          minItems: 3
+          maxItems: 3
         clock-names:
           items:
             - const: apb
@@ -133,10 +131,9 @@ allOf:
 
     then:
       properties:
-        clock:
-          items:
-            minItems: 4
-            maxItems: 4
+        clocks:
+          minItems: 4
+          maxItems: 4
         clock-names:
           items:
             - const: apb
@@ -146,10 +143,9 @@ allOf:
 
     else:  # for gen2 HW that don't have gals
       properties:
-        clock:
-          items:
-            minItems: 2
-            maxItems: 2
+        clocks:
+          minItems: 2
+          maxItems: 2
         clock-names:
           items:
             - const: apb
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.yaml
@@ -79,10 +79,9 @@ allOf:
 
     then:
       properties:
-        clock:
-          items:
-            minItems: 3
-            maxItems: 3
+        clocks:
+          minItems: 3
+          maxItems: 3
         clock-names:
           items:
             - const: apb
@@ -91,10 +90,9 @@ allOf:
 
     else:
       properties:
-        clock:
-          items:
-            minItems: 2
-            maxItems: 2
+        clocks:
+          minItems: 2
+          maxItems: 2
         clock-names:
           items:
             - const: apb


