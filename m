Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B514E4F3025
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241223AbiDEK2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbiDEJce (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB98DC30;
        Tue,  5 Apr 2022 02:19:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C29EB81B14;
        Tue,  5 Apr 2022 09:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4039C385A0;
        Tue,  5 Apr 2022 09:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150362;
        bh=uLyYd0uHzhSFJRh2HuZqwzNik1WL39MUA9/Bf0wUzQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4zRMyccBnAnrFa0bEWDZ/6bvzfNicltMkQnr1e8506QNbRgKZmJ+zrCj0gfB65hz
         p5q2SDmsOYjVvObGc+WUjEJYEfPAFaDmpGvTAXwNp+myZb7FW5ZaPjkfGvcbciBjWf
         2BtRJuaKxsfkNgAFIsD8NfMl7gi95uVXnWoq3b4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 5.15 003/913] dt-bindings: usb: hcd: correct usb-device path
Date:   Tue,  5 Apr 2022 09:17:45 +0200
Message-Id: <20220405070339.912669044@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 801109b1a37ad99784e6370cc7e462596f505ea3 upstream.

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
 Documentation/devicetree/bindings/usb/usb-hcd.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/usb/usb-hcd.yaml
+++ b/Documentation/devicetree/bindings/usb/usb-hcd.yaml
@@ -33,7 +33,7 @@ patternProperties:
   "^.*@[0-9a-f]{1,2}$":
     description: The hard wired USB devices
     type: object
-    $ref: /usb/usb-device.yaml
+    $ref: /schemas/usb/usb-device.yaml
 
 additionalProperties: true
 


