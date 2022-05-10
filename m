Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E3F521AC6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiEJOD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244806AbiEJOBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:01:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3342DE5A3;
        Tue, 10 May 2022 06:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76C7B81D24;
        Tue, 10 May 2022 13:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AE1C36AEA;
        Tue, 10 May 2022 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190005;
        bh=XgOyfwY09cKOKNRpN4Ehrh0m6E4OuJybLh6K6uDvmp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFcQMLo5mC31tmslDvswKo2hAHdR887qesWIz0MTGwYlJot5LvZlv0zcwkPGYnfhC
         kNENpWbCLDuClVxWVKrXGcrmz3cpxcVYmFPFirQfHTFpT+ApxITVLCmeO4xjHYTQei
         vTpSGW62TdJbLYCyy+b5IifMFubEqQGgSPbpF/QI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 5.17 099/140] dt-bindings: pci: apple,pcie: Drop max-link-speed from example
Date:   Tue, 10 May 2022 15:08:09 +0200
Message-Id: <20220510130744.437692269@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 5dc4630426511f641b7ac44fc550b8e21eafb237 upstream.

We no longer use these since 111659c2a570 (and they never worked
anyway); drop them from the example to avoid confusion.

Fixes: 111659c2a570 ("arm64: dts: apple: t8103: Remove PCIe max-link-speed properties")
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220502091308.28233-1-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pci/apple,pcie.yaml | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/apple,pcie.yaml b/Documentation/devicetree/bindings/pci/apple,pcie.yaml
index 7f01e15fc81c..daf602ac0d0f 100644
--- a/Documentation/devicetree/bindings/pci/apple,pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/apple,pcie.yaml
@@ -142,7 +142,6 @@ examples:
           device_type = "pci";
           reg = <0x0 0x0 0x0 0x0 0x0>;
           reset-gpios = <&pinctrl_ap 152 0>;
-          max-link-speed = <2>;
 
           #address-cells = <3>;
           #size-cells = <2>;
@@ -153,7 +152,6 @@ examples:
           device_type = "pci";
           reg = <0x800 0x0 0x0 0x0 0x0>;
           reset-gpios = <&pinctrl_ap 153 0>;
-          max-link-speed = <2>;
 
           #address-cells = <3>;
           #size-cells = <2>;
@@ -164,7 +162,6 @@ examples:
           device_type = "pci";
           reg = <0x1000 0x0 0x0 0x0 0x0>;
           reset-gpios = <&pinctrl_ap 33 0>;
-          max-link-speed = <1>;
 
           #address-cells = <3>;
           #size-cells = <2>;
-- 
2.36.1



