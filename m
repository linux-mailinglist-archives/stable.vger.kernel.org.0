Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98E8658429
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbiL1QzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbiL1Qyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:54:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4AF1C131
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66308B81889
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5685C433D2;
        Wed, 28 Dec 2022 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246169;
        bh=Q78Q/N8a6EdC1mmS50c7z2Q4OJhKO6FyuPTE8rhZRsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0rNGpkc54zfLMOKzyM35/HPBf1PR5ngDVGhafvVHCnKmVnIonH891cczrAsBxeZA
         Y9w2GiO783gRejct/JpOA6W56sTrdiCoVmHnW3L0RmICCEiZbKn6MxQm48TY5sv/jq
         F9B9moJMayZMAmHH/LnqZb+WDL6Hjd1U3VigLTM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeff LaBundy <jeff@labundy.com>,
        Rob Herring <robh@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1023/1073] dt-bindings: input: iqs7222: Reduce linux,code to optional
Date:   Wed, 28 Dec 2022 15:43:31 +0100
Message-Id: <20221228144355.978023653@linuxfoundation.org>
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

[ Upstream commit ccad486525c49df2fe2e7090990522547dfd2785 ]

Following a recent refactor of the driver to properly drop unused
device nodes, the 'linux,code' property is now optional. This can
be useful for applications that define GPIO-mapped events that do
not correspond to any keycode.

Fixes: 44dc42d254bf ("dt-bindings: input: Add bindings for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Y1SROIrrC1LwX0Sd@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
index 02e605fac408..b4eb650dbcb8 100644
--- a/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
+++ b/Documentation/devicetree/bindings/input/azoteq,iqs7222.yaml
@@ -473,9 +473,6 @@ patternProperties:
               Specifies whether the event is to be interpreted as a key (1)
               or a switch (5).
 
-        required:
-          - linux,code
-
         additionalProperties: false
 
     dependencies:
@@ -620,9 +617,6 @@ patternProperties:
               GPIO, they must all be of the same type (proximity, touch or
               slider gesture).
 
-        required:
-          - linux,code
-
         additionalProperties: false
 
     required:
-- 
2.35.1



