Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D904F3BBA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243323AbiDEMBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357795AbiDEK1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7293BA45;
        Tue,  5 Apr 2022 03:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EBE9B81C88;
        Tue,  5 Apr 2022 10:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B36C385A1;
        Tue,  5 Apr 2022 10:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153444;
        bh=DGfFICk0ZyhZyp7gehgdnGZsI2rdjdBF6ht5fhvYKxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlode+MLTbTKog4DX8NcPPjrzUdwINwHKj+2iffgYldxSYnje1pkWKZ/bPB5+uue/
         xbfyZVg1zjJdAY6pSqzX7oonKczXrDPufQrcDJAIKtbkvGSoINNzBIPRwdRdxKffO6
         sfhWIENZ92NTub7DGcyeKdqvd5N4kEhFDfwXg+8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuldeep Singh <singh.kuldeep87k@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/599] arm64: dts: ns2: Fix spi-cpol and spi-cpha property
Date:   Tue,  5 Apr 2022 09:28:39 +0200
Message-Id: <20220405070305.537796972@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Kuldeep Singh <singh.kuldeep87k@gmail.com>

[ Upstream commit c953c764e505428f59ffe6afb1c73b89b5b1ac35 ]

Broadcom ns2 platform has spi-cpol and spi-cpho properties set
incorrectly. As per spi-slave-peripheral-prop.yaml, these properties are
of flag or boolean type and not integer type. Fix the values.

Fixes: d69dbd9f41a7c (arm64: dts: Add ARM PL022 SPI DT nodes for NS2)
Signed-off-by: Kuldeep Singh <singh.kuldeep87k@gmail.com>
CC: Ray Jui <rjui@broadcom.com>
CC: Scott Branden <sbranden@broadcom.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
index ec19fbf928a1..12a4b1c03390 100644
--- a/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
+++ b/arch/arm64/boot/dts/broadcom/northstar2/ns2-svk.dts
@@ -111,8 +111,8 @@
 		compatible = "silabs,si3226x";
 		reg = <0>;
 		spi-max-frequency = <5000000>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
@@ -135,8 +135,8 @@
 		at25,byte-len = <0x8000>;
 		at25,addr-mode = <2>;
 		at25,page-size = <64>;
-		spi-cpha = <1>;
-		spi-cpol = <1>;
+		spi-cpha;
+		spi-cpol;
 		pl022,hierarchy = <0>;
 		pl022,interface = <0>;
 		pl022,slave-tx-disable = <0>;
-- 
2.34.1



