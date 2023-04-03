Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5016D492E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbjDCOfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbjDCOf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710F8729C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18B7CB81C9B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AFAC433EF;
        Mon,  3 Apr 2023 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532525;
        bh=Eul+jJM0hZafSRZ8PPFq0JYcvfFF/gb8t13UzgFH/Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1SPX/GuuLYUMtNJt8o1ZAJ1iYTXmruqjWwEJCH/+Eh40kJnh8LdW8No2H25rdte4
         /Km7CzkhQfRKDaeJNmZH8AyKFSboUYPf23qrc6chq8yyHcmwhOuG0HM05pqN5kBaO7
         iNSHBrKJOA45PcaQ8Zyp4+QDA9HoLeIAfd0/wm24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eddie James <eajames@linux.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/181] ARM: dts: aspeed: p10bmc: Update battery node name
Date:   Mon,  3 Apr 2023 16:07:32 +0200
Message-Id: <20230403140415.678694731@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a8cef541dd5ef9445130660008c029205c4c5aa5 ]

The ADC sensor for the battery needs to be named "iio-hwmon" for
compatibility with user space applications.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20230202152759.67069-1-eajames@linux.ibm.com
Fixes: bf1914e2cfed ("ARM: dts: aspeed: p10bmc: Fix ADC iio-hwmon battery node name")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20230221003352.1218797-1-joel@jms.id.au
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts | 2 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
index fcc890e3ad735..f11feb98fde33 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-everest.dts
@@ -244,7 +244,7 @@
 		};
 	};
 
-	iio-hwmon-battery {
+	iio-hwmon {
 		compatible = "iio-hwmon";
 		io-channels = <&adc1 7>;
 	};
diff --git a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
index 4879da4cdbd25..77a3a27b04e26 100644
--- a/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts
@@ -220,7 +220,7 @@
 		};
 	};
 
-	iio-hwmon-battery {
+	iio-hwmon {
 		compatible = "iio-hwmon";
 		io-channels = <&adc1 7>;
 	};
-- 
2.39.2



