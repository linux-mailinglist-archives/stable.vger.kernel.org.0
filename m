Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706574EF4B2
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349770AbiDAO5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352593AbiDAOu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:50:59 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347632B3D7F;
        Fri,  1 Apr 2022 07:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E19AECE258D;
        Fri,  1 Apr 2022 14:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565EBC34111;
        Fri,  1 Apr 2022 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824106;
        bh=6QlKQl+0OseeNyRTe5krfh3/2JlBiteEUET6YMPdbJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StMAKz2fDO+LlACn6nMJE9YrydiOn0JxztEUXu01YkfMCC57/06splwUK7DqHxNSi
         E6Qxabec072YVhxQ33KEjaWi0fDf2CoXRwnJHI3N3NwKP9aotdaT/9lakIprVBdOGm
         1BLC6EqLIXFfB0YwzArCSt7uiW697EZ3LMmZz44RrqUFYpU90miSCKrhLEqtT/fmSf
         s9oVbW3M7NnyJ/DpAb40OYj1cyeX9mfBvu0OMbp4A17wsOuTKM2biuoEOSw2XRPtn0
         StGE3c/Lw50LhmbfUSzB6N0+aMDG8gGyh2vceFAvbqBUEq8LJfs617i4TyIYj0mY92
         TZdRzEtfwEFGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzk+dt@kernel.org, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 90/98] MIPS: ingenic: correct unit node address
Date:   Fri,  1 Apr 2022 10:37:34 -0400
Message-Id: <20220401143742.1952163-90-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index 9e34f433b9b5..efbbddaf0fde 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -450,7 +450,7 @@ efuse: efuse@d0 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			eth0_addr: eth-mac-addr@0x22 {
+			eth0_addr: eth-mac-addr@22 {
 				reg = <0x22 0x6>;
 			};
 		};
-- 
2.34.1

