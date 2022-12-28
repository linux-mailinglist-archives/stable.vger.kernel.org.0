Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006A065842A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiL1QzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiL1Qyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5311C13E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD6D60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28533C433D2;
        Wed, 28 Dec 2022 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246174;
        bh=Wsda+XD+JwQsJLyyqlUbDKjCumuiyPp1cAJKGf+TYRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYr1VkzlONUz6wP61PxR1AQGrSj5VRY0qw+6iTVQWBW5PUmuq+SH78DDyDToxtnla
         9XAnX+9dSSMfGnD44Y97DV4erznjnWfSv0XXkc6mf9W4HdSbhDb+EAlEXvs0msyx6S
         yxDurv64xvqtPrQQ1Incn32Zt+XCK73NZakGnNkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Rob Herring <robh@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1024/1073] dt-bindings: input: iqs7222: Correct minimum slider size
Date:   Wed, 28 Dec 2022 15:43:32 +0100
Message-Id: <20221228144356.004830383@linuxfoundation.org>
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

[ Upstream commit 99d03b54ef8506771c15deb714396665592f6adf ]

The minimum slider size enforced by the driver is 1 or 16 for the
IQS7222C or IQS7222A, respectively.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Y1SRU37t74wRvZv3@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index b4eb650dbcb8..913fd2da9862 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -498,7 +498,7 @@ patternProperties:
 
       azoteq,slider-size:
         $ref: /schemas/types.yaml#/definitions/uint32
-        minimum: 0
+        minimum: 1
         maximum: 65535
         description:
           Specifies the slider's one-dimensional resolution, equal to the
@@ -687,6 +687,7 @@ allOf:
           properties:
             azoteq,slider-size:
               multipleOf: 16
+              minimum: 16
               maximum: 4080
 
             azoteq,top-speed:
-- 
2.35.1



