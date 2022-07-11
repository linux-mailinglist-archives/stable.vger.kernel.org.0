Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE5856FA63
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiGKJRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiGKJQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:16:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE50B402D3;
        Mon, 11 Jul 2022 02:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B565B611E4;
        Mon, 11 Jul 2022 09:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C19C341C8;
        Mon, 11 Jul 2022 09:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530661;
        bh=NbA28TAuTrYYXJwoVDSHTqYmT/Qw5wS2/4IKKLTHgKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tM0QHUO9JcwG5tph6jByehwLFBPWc+0sn/9sw760NelnSEwjC7jtpYlCEZDSCdznD
         64skqtpIb7al/AZoD2t87T9YUeyhetol1v40OrLdm3idbZDfsDCFBATSR+2MJIwZ6i
         DqelGZnXx9Tfe0r4BwMwY9QhZrjud+qfn5d+BH84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 33/38] dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo
Date:   Mon, 11 Jul 2022 11:07:15 +0200
Message-Id: <20220711090539.702563238@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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
@@ -58,7 +58,7 @@ if:
 then:
   properties:
     clocks:
-      maxItems: 2
+      minItems: 2
 
   required:
     - clock-names


