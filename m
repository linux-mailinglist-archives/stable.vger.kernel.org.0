Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF4D4DAC31
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 09:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbiCPIEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 04:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354389AbiCPIEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 04:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE9B04
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 01:02:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE3B61268
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14207C340E9;
        Wed, 16 Mar 2022 08:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647417774;
        bh=1y8N20IsrOKUYvZwRlT95uuv1eQlyhhe5yet1hvvYSc=;
        h=Subject:To:From:Date:From;
        b=GI+x+FarWbZfzkX6CdW9CAkpYbR38tpB+v+zabczU9z3QWKKnXiM1sSXJt8qq0wSy
         LB8Mf/mt6fHjMNS7QpJm3cA8o1pjQGRHpxeM0dzfsmvg+oBRobqOehak+MyN+M6cgF
         xOJaqty8M9oyY5o9W0NiY0O9xTtQGITfj8oBk++A=
Subject: patch "dt-bindings: usb: hcd: correct usb-device path" added to usb-next
To:     krzysztof.kozlowski@canonical.com, gregkh@linuxfoundation.org,
        robh@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Mar 2022 09:02:45 +0100
Message-ID: <16474177658384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    dt-bindings: usb: hcd: correct usb-device path

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 801109b1a37ad99784e6370cc7e462596f505ea3 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Date: Mon, 14 Mar 2022 19:18:30 +0100
Subject: dt-bindings: usb: hcd: correct usb-device path

The usb-device.yaml reference is absolute so it should use /schemas part
in path.

Fixes: 23bf6fc7046c ("dt-bindings: usb: convert usb-device.txt to YAML schema")
Cc: <stable@vger.kernel.org>
Reported-by: Rob Herring <robh@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20220314181830.245853-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/usb/usb-hcd.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-hcd.yaml b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
index 56853c17af66..1dc3d5d7b44f 100644
--- a/Documentation/devicetree/bindings/usb/usb-hcd.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
@@ -33,7 +33,7 @@ patternProperties:
   "^.*@[0-9a-f]{1,2}$":
     description: The hard wired USB devices
     type: object
-    $ref: /usb/usb-device.yaml
+    $ref: /schemas/usb/usb-device.yaml
 
 additionalProperties: true
 
-- 
2.35.1


