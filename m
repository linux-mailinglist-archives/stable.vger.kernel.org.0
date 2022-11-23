Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DD6635D2C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiKWMlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiKWMlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34439663C1;
        Wed, 23 Nov 2022 04:41:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC269B81F3A;
        Wed, 23 Nov 2022 12:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC52C433B5;
        Wed, 23 Nov 2022 12:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207261;
        bh=bIKzhlWihw6BMocxBKmt5Jc2XRYsG55ra2FWrhx/Q1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpULGM1AvNas+bAZ6dg67x4FGCP0Y7lcSGE79DclQrfTD/5GhikUUGf8Zr/mzLtgi
         gIw38A0XtuNToaGyLw7W+yqK6BriUjiwi57eFwQ9wvffGtSoTaILOQEUxn3RaQ27DX
         gGqaQTD3bf/DpkG7POPS/3VB+PBgU7lFNdmflBb1CSNK48dpaIJpBBQqtdbTdTwtgl
         gC66BDTa7zq0MfjdtLQkByGGOmVBnsdNKYjXgIvt0txbwP2Y5PRm8puwA0uWArgnwM
         ZQlga7lWzBRbrzlr9GVZEBnauK5eJnp6t7d/k0BrG0MADDztKF2rLDC+3dDYrDJSYD
         PvattVxByJFUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sheng-Liang Pan <sheng-liang.pan@quanta.corp-partner.google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Herring <robh@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/44] dt-bindings: input: touchscreen: Add compatible for Goodix GT7986U chip
Date:   Wed, 23 Nov 2022 07:40:11 -0500
Message-Id: <20221123124057.264822-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sheng-Liang Pan <sheng-liang.pan@quanta.corp-partner.google.com>

[ Upstream commit a01aca4b05174b6dee2392ec44406f85e0f8bd46 ]

Add a compatible for Goodix touch screen chip GT7986U which is
is expected to be fully compatible with a driver written for GT7375P.

Signed-off-by: Sheng-Liang Pan <sheng-liang.pan@quanta.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20221006185333.v7.3.I52e4b4b20e2eb0ae20f2a9bb198aa6410f04cf16@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/goodix,gt7375p.yaml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/input/goodix,gt7375p.yaml b/Documentation/devicetree/bindings/input/goodix,gt7375p.yaml
index fe1c5016f7f3..1c191bc5a178 100644
--- a/Documentation/devicetree/bindings/input/goodix,gt7375p.yaml
+++ b/Documentation/devicetree/bindings/input/goodix,gt7375p.yaml
@@ -16,8 +16,11 @@ description:
 
 properties:
   compatible:
-    items:
+    oneOf:
       - const: goodix,gt7375p
+      - items:
+          - const: goodix,gt7986u
+          - const: goodix,gt7375p
 
   reg:
     enum:
-- 
2.35.1

