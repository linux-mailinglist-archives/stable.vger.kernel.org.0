Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB124EF31B
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349244AbiDAO4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350271AbiDAOrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F94258FC5;
        Fri,  1 Apr 2022 07:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D87DB82523;
        Fri,  1 Apr 2022 14:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB50BC36AE7;
        Fri,  1 Apr 2022 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823841;
        bh=ssHw4guXgvrYR0ACr/I+6ESfC4KwLjLyGS7qiomSBgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8M02aAN21XWxrRf9TEt5rtlAJDW0mc5E0vBHCZtD6yyPv3iH9R1AThlFCUVEjrBK
         sas4VHuV+KGFVJKArHoqon9Id452W3Jfj3UXnaK5Vl6x/L7dZBvJHK6G5WRNHxLBC6
         Kw+HZzxSgZkM3/b7l8TQvDHj+57Sa+BbprEdcqtM9Mi2InKNdHQGBdN/tugmfjwzXH
         0Rh05kKCTmYTfRIs49VqPonGPo8UFWEGoCgG36COXAYQ0GFe22aEnBQocwOXVj/KgH
         O0WOQi8u4vMEXCdyQ22h1CkYo4OFXjudvi5dopl6e4GBxPBn8hLw+HJY1G8JhtjVn5
         lVnd6E+Zt2OAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzk+dt@kernel.org, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 101/109] MIPS: ingenic: correct unit node address
Date:   Fri,  1 Apr 2022 10:32:48 -0400
Message-Id: <20220401143256.1950537-101-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 8931ddd8d6a55fcefb20f44a38ba42bb746f0b62 ]

Unit node addresses should not have leading 0x:

  Warning (unit_address_format): /nemc@13410000/efuse@d0/eth-mac-addr@0x22: unit name should not have leading "0x"

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/ingenic/jz4780.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index b0a4e2e019c3..af6cd32c706c 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -470,7 +470,7 @@ efuse: efuse@d0 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			eth0_addr: eth-mac-addr@0x22 {
+			eth0_addr: eth-mac-addr@22 {
 				reg = <0x22 0x6>;
 			};
 		};
-- 
2.34.1

