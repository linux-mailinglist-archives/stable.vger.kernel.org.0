Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0F69860B
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBOUrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjBOUq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD3543444;
        Wed, 15 Feb 2023 12:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97891B823B4;
        Wed, 15 Feb 2023 20:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5040C4339E;
        Wed, 15 Feb 2023 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493978;
        bh=OtF8ZiBBwfOgsqCNX3FwBB8ECvvndlNZDuoqjQndGxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLiPYoHTRW27MGTglej+WLNHLJu/3mGsgCdlgiO+arzN1ppv7q6hiVN+SCGLBMFaD
         U+sDsYFh17BxYZGg3wVQ5bIlycfWqxtp5XT8fo7KCbTXwWj7Jn3PkaHZkx1tb1eaQn
         meBUhWeoiT+pYZTRlMA6iIaVta0nR5H0A8hTr25/q+o7MZz9eByUffur4JRfVYQKY8
         oId6qb3RTxbc3WAQMWJrUKYf4JgVr7zXCIgHVfI14t5Zw1hIOyxnXbiPLBNkOniSxr
         R4HDoEdWtY6HJWUW37bxt1gVdah/ktHlWEQz15HDlqXkJfqHsSwpYmh2i+csuLykjn
         uHPtNW7edk3LQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 17/24] ARM: dts: stihxxx-b2120: fix polarity of reset line of tsin0 port
Date:   Wed, 15 Feb 2023 15:45:40 -0500
Message-Id: <20230215204547.2760761-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 4722dd4029c63f10414ffd8d3ffdd6c748391cd7 ]

According to c8sectpfe driver code we first drive reset line low and
then high to reset the port, therefore the reset line is supposed to
be annotated as "active low". This will be important when we convert
the driver to gpiod API.

Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 2aa94605d3d47..d52a7aaa10743 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -178,7 +178,7 @@ tsin0: port {
 				tsin-num = <0>;
 				serial-not-parallel;
 				i2c-bus = <&ssc2>;
-				reset-gpios = <&pio15 4 GPIO_ACTIVE_HIGH>;
+				reset-gpios = <&pio15 4 GPIO_ACTIVE_LOW>;
 				dvb-card = <STV0367_TDA18212_NIMA_1>;
 			};
 		};
-- 
2.39.0

