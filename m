Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B5359D761
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbiHWJ5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbiHWJyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:54:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D5F6E8AF;
        Tue, 23 Aug 2022 01:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9CB3B81C28;
        Tue, 23 Aug 2022 08:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA33BC433D6;
        Tue, 23 Aug 2022 08:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244392;
        bh=Lk/EXHs1Brib0yccLyg9YlZB8T5oBa6kIQL19U+DNds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwSoppF7NTUZKo1wZpUuOEB0riZTqAekgHIRrLUOvrutZklkwXX6VjtDa9nlW2Ysr
         2Dl4JZeWK7xFcgI4dGXozwH854cvGkl6grb+BZzjgwabok13xZlUYHdEwldT1haMMU
         Yv0k7xNWhFKv/N/vCJe2PCw8hYTEXiz4A9E5CV50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Michal Simek <michal.simek@amd.com>
Subject: [PATCH 5.15 082/244] dt-bindings: gpio: zynq: Add missing compatible strings
Date:   Tue, 23 Aug 2022 10:24:01 +0200
Message-Id: <20220823080101.784043325@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Michal Simek <michal.simek@xilinx.com>

commit 7668048e5c697a9493ffc0e6001c322b2efe90ae upstream.

"xlnx,zynqmp-gpio-1.0", "xlnx,versal-gpio-1.0" and "xlnx,pmc-gpio-1.0"
compatible strings were not moved to yaml format. But they were in origin
text file.

Fixes: 45ca16072b70 ("dt-bindings: gpio: zynq: convert bindings to YAML")
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/72c973da5670b5ae81d050c582948894ee4174f8.1634206453.git.michal.simek@xilinx.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/gpio/gpio-zynq.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml b/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
index 378da2649e66..980f92ad9eba 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
+++ b/Documentation/devicetree/bindings/gpio/gpio-zynq.yaml
@@ -11,7 +11,11 @@ maintainers:
 
 properties:
   compatible:
-    const: xlnx,zynq-gpio-1.0
+    enum:
+      - xlnx,zynq-gpio-1.0
+      - xlnx,zynqmp-gpio-1.0
+      - xlnx,versal-gpio-1.0
+      - xlnx,pmc-gpio-1.0
 
   reg:
     maxItems: 1
-- 
2.37.2



