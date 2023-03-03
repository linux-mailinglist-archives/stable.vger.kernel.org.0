Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B786AA1B1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjCCVmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjCCVlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:41:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A26637FA;
        Fri,  3 Mar 2023 13:41:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB08461917;
        Fri,  3 Mar 2023 21:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765D8C4339E;
        Fri,  3 Mar 2023 21:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879688;
        bh=RuZiY6yLzvYHFG0mh9YDrMKd81C9VY6sdaK2qMlPu18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2+4p+ePLORamHdmiAla1a+A+JZpEeAMPdI0Atw/sK6jEX6A3fdYNZpXxQNiiANix
         DEYGrQxaiZ3lq64w/FA7N3ud/0uIhc2XWkm6ajiOMPJUZTqb1kFbTjBFVDDHdZq5AA
         G+TXiMP4VwBbfycBY6xkCwwaHFbhLtSPD1pX+UMYmFLlG3YPTOqxzRRNhwe7vzW0Y5
         78DfjgOh+kq6Z2jb/h5HOdf6BaWNndYN0xtxQL2VW2IIoaACfZ7HZ22VgSGIBRG7G0
         7Wv8hvs6FnJWrJVh/iTJn+DGNy5usgPLZjvd/XfxKAnSoJKU3ozTcR7Z5RGEKNqAkm
         cNEjhwVLit71w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand Moon <linux.amoon@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, uwu@icenowy.me,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 13/64] dt-bindings: usb: Add device id for Genesys Logic hub controller
Date:   Fri,  3 Mar 2023 16:40:15 -0500
Message-Id: <20230303214106.1446460-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit b72654148e34c181f532275d03ef6f37de288f24 ]

Add usb hub device id for Genesys Logic, Inc. GL852G Hub USB 2.0
root hub.

Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230118044418.875-2-linux.amoon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/usb/genesys,gl850g.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml b/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
index a9f831448ccae..cc4cf92b70d18 100644
--- a/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
+++ b/Documentation/devicetree/bindings/usb/genesys,gl850g.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     enum:
       - usb5e3,608
+      - usb5e3,610
 
   reg: true
 
-- 
2.39.2

