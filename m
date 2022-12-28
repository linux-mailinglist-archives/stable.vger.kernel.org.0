Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6401865842E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiL1QzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbiL1Qyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60C1EAD9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FAAB8188C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6304C433EF;
        Wed, 28 Dec 2022 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246180;
        bh=RcWnq7GP/UzPFJHuOTgz5KeYcbscuCrl+RsL6vKS3p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Npf+C7GH/CyYGqBU1j+vs/Qa8jMfgUzugXhcgP8ufd+uNprUkAsGoY6kfb5xVr24C
         1FQy9ERfN+OIzY97DslpTBH8DgHShtwcV3CaxVX5sbF3gCnL0/327Oe6z1PUFcXPb0
         ylxaA6p/ZHs6+SRBTTHAW4/eUSXrllkVazdzQAaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Rob Herring <robh@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1025/1073] dt-bindings: input: iqs7222: Add support for IQS7222A v1.13+
Date:   Wed, 28 Dec 2022 15:43:33 +0100
Message-Id: <20221228144356.032045338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 97384a65c5e304ccab0477751546f5519d9371c3 ]

IQS7222A revisions 1.13 and later widen the gesture multiplier from
x4 ms to x16 ms; update the binding accordingly.

As part of this change, refresh the corresponding properties in the
example as well.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Y1SRaVGwj30z/g6r@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/input/azoteq,iqs7222.yaml           | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index 913fd2da9862..9ddba7f2e7aa 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -572,9 +572,9 @@ patternProperties:
           linux,code: true
 
           azoteq,gesture-max-ms:
-            multipleOf: 4
+            multipleOf: 16
             minimum: 0
-            maximum: 1020
+            maximum: 4080
             description:
               Specifies the length of time (in ms) within which a tap, swipe
               or flick gesture must be completed in order to be acknowledged
@@ -582,9 +582,9 @@ patternProperties:
               gesture applies to all remaining swipe or flick gestures.
 
           azoteq,gesture-min-ms:
-            multipleOf: 4
+            multipleOf: 16
             minimum: 0
-            maximum: 124
+            maximum: 496
             description:
               Specifies the length of time (in ms) for which a tap gesture must
               be held in order to be acknowledged by the device.
@@ -930,14 +930,14 @@ examples:
 
                             event-tap {
                                     linux,code = <KEY_PLAYPAUSE>;
-                                    azoteq,gesture-max-ms = <600>;
-                                    azoteq,gesture-min-ms = <24>;
+                                    azoteq,gesture-max-ms = <400>;
+                                    azoteq,gesture-min-ms = <32>;
                             };
 
                             event-flick-pos {
                                     linux,code = <KEY_NEXTSONG>;
-                                    azoteq,gesture-max-ms = <600>;
-                                    azoteq,gesture-dist = <816>;
+                                    azoteq,gesture-max-ms = <800>;
+                                    azoteq,gesture-dist = <800>;
                             };
 
                             event-flick-neg {
-- 
2.35.1



