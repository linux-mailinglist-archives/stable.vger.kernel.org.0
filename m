Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E37B657A49
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiL1PKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiL1PJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA7413E12
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F8BB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D7FC433D2;
        Wed, 28 Dec 2022 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240165;
        bh=NN9m79Welr6hxIjwb+eJiSzwV39wkXV8AXDCAunkbqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeBkuhTIn/KqiC0o77MttTMxcLtvdC3HUVCgvrx0PTSnwBrqpSitEtN0Q6T3kmUiA
         H5elaglfW06Pu0XbWFd9CgD+V7XLSYTDTOj09ersjKQUSsauqp6LvNzkqoPy4EnWnw
         NOzlQzqw0WG2iVHWDVoO58pCFE3apahZ3WJTiurk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0088/1146] ARM: dts: turris-omnia: Add switch port 6 node
Date:   Wed, 28 Dec 2022 15:27:07 +0100
Message-Id: <20221228144332.534780176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit f87db2005f73876602211af0ee156817019b6bda ]

Switch port 6 is connected to eth0, so add appropriate device tree node for it.

Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index f2aaaed69ae9..0c1f238e4c30 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -489,7 +489,17 @@ fixed-link {
 				};
 			};
 
-			/* port 6 is connected to eth0 */
+			ports@6 {
+				reg = <6>;
+				label = "cpu";
+				ethernet = <&eth0>;
+				phy-mode = "rgmii-id";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 		};
 	};
 };
-- 
2.35.1



