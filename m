Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A0756FAE9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiGKJXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiGKJXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD47A476;
        Mon, 11 Jul 2022 02:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A498FB80956;
        Mon, 11 Jul 2022 09:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CCEC34115;
        Mon, 11 Jul 2022 09:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530820;
        bh=4HuBC4Aelr4BrBgOj2FNmFO2kAE/C4SeM865M3gGYNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0fRBkfy6tjCYzo+BCgN6p3J4hpgPMZi6rCZHJohSGGjOwtFn8S00EbSQOOYiQf59
         O+cOvsYmUZo625gIHL1bG5dhUpvTCT8kHjoCyYTWE+aWud/dreCypyQeiEu2n909gL
         WrDnzVial3D6teIiUXq1wphdGK7b4nF3F/a1hdoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 50/55] dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo
Date:   Mon, 11 Jul 2022 11:07:38 +0200
Message-Id: <20220711090543.229756210@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit 607a48c78e6b427b0b684d24e61c19e846ad65d6 upstream.

The conditional block for variants with a second clock should have set
minItems, not maxItems, which was already 2. Since clock-names requires
two items, this typo should not have caused any problems.

Fixes: edd14218bd66 ("dt-bindings: dmaengine: Convert Allwinner A31 and A64 DMA to a schema")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220702031903.21703-1-samuel@sholland.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml
+++ b/Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml
@@ -61,7 +61,7 @@ if:
 then:
   properties:
     clocks:
-      maxItems: 2
+      minItems: 2
 
   required:
     - clock-names


