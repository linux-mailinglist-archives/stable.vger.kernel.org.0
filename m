Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C855505182
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbiDRMfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbiDRMdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32971B781;
        Mon, 18 Apr 2022 05:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5F5CB80ED6;
        Mon, 18 Apr 2022 12:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B733C385A1;
        Mon, 18 Apr 2022 12:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284738;
        bh=Dw8ApTS/5aAFeYoRxwG0Dkawb7rlxYyR4Csuh9f3TbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf7c+IUJ8dcrWEereXd/qBWT7dlM4F7WrYd4Jb1eBbVE+o+laymccCpB8OMQDIeoD
         tXOM0SfnlG8SLIanjsoPOnkQXfHfbCtkQir97S1fLZ820CTZlco93DwLnmLW0llto4
         grkkyOTiNo2tDbkkP9NYPjwT2SguriqqI1FGAeys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.17 211/219] dt-bindings: memory: snps,ddrc-3.80a compatible also need interrupts
Date:   Mon, 18 Apr 2022 14:13:00 +0200
Message-Id: <20220418121212.773799708@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

commit 4f9f45d0eb0e7d449bc9294459df79b9c66edfac upstream.

For the snps,ddrc-3.80a compatible, the interrupts property is also
required, also order the compatibles by name (s goes before x).

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Fixes: a9e6b3819b36 ("dt-bindings: memory: Add entry for version 3.80a")
Link: https://lore.kernel.org/r/20220321075131.17811-2-sherry.sun@nxp.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/memory-controllers/synopsys,ddrc-ecc.yaml |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/memory-controllers/synopsys,ddrc-ecc.yaml
+++ b/Documentation/devicetree/bindings/memory-controllers/synopsys,ddrc-ecc.yaml
@@ -24,9 +24,9 @@ description: |
 properties:
   compatible:
     enum:
+      - snps,ddrc-3.80a
       - xlnx,zynq-ddrc-a05
       - xlnx,zynqmp-ddrc-2.40a
-      - snps,ddrc-3.80a
 
   interrupts:
     maxItems: 1
@@ -43,7 +43,9 @@ allOf:
       properties:
         compatible:
           contains:
-            const: xlnx,zynqmp-ddrc-2.40a
+            enum:
+              - snps,ddrc-3.80a
+              - xlnx,zynqmp-ddrc-2.40a
     then:
       required:
         - interrupts


