Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E595C0231
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiIUPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiIUPsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6CE9DF95;
        Wed, 21 Sep 2022 08:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5D406312F;
        Wed, 21 Sep 2022 15:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB75CC433C1;
        Wed, 21 Sep 2022 15:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775267;
        bh=spInQ7coVvtdxGMBzr2GLkS2P4ddh6lYh6Po0asyqQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP3mKAjYpbXm3D39Ln6M/o5x9hKzQqXntXdSQf+O5zLtdTPECnSzDZ02Qw5CEXxgQ
         6lrCpR06UAveubQaKv8Ui9EfmjfDkLmGGYnzb8wAz25Ra4LEzM5OhPohJ2g0eC1Ac7
         pMgSCdJfVcQ4p6hI9bx7UfWODzNzsDVZpb8II9TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janne Grunau <j@jannau.net>,
        Marc Zyngier <maz@kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 5.19 35/38] dt-bindings: apple,aic: Fix required item "apple,fiq-index" in affinity description
Date:   Wed, 21 Sep 2022 17:46:19 +0200
Message-Id: <20220921153647.376565933@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
References: <20220921153646.298361220@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit da3b1c294d470b2cf3c7046cc9e0d5c66f0a6c65 upstream.

The required list used "fiq-index" instead of "apple,fiq-index"
described as property and used in the dts. Add the missing "apple,"
prefix.

Fixes: dba07ad11384 ("dt-bindings: apple,aic: Add affinity description for per-cpu pseudo-interrupts")
Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220909135103.98179-2-j@jannau.net
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/interrupt-controller/apple,aic.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/interrupt-controller/apple,aic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/apple,aic.yaml
@@ -96,7 +96,7 @@ properties:
               Documentation/devicetree/bindings/arm/cpus.yaml).
 
         required:
-          - fiq-index
+          - apple,fiq-index
           - cpus
 
 required:


