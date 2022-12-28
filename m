Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD54657A44
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbiL1PJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiL1PJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D04113E3E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D412DB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49656C433EF;
        Wed, 28 Dec 2022 15:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240157;
        bh=bed5LXd0C8VyUB9EQJk35b/ZjbPrSuop5Ddkv/BqsPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKSeh7kJnifHT9lZgRaJL4PcEB6w4ZACD2iA9bejFx0OvcetHpipezxMnDcWSB2d2
         Wyk5+FhEBBHHeciK9n439a0N+24xAK3Sir13ZL4H4vkh5ttF1rHp5wKgrP0SEJ+GDF
         F2cke9k6o1JiDV/DKSbifDTCJGIkmMTpFXuoMBic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0087/1146] ARM: dts: turris-omnia: Add ethernet aliases
Date:   Wed, 28 Dec 2022 15:27:06 +0100
Message-Id: <20221228144332.508176152@linuxfoundation.org>
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

[ Upstream commit f1f3e530c59a7e8c5f06172f4c28b945a6b4bfb8 ]

This allows bootloader to correctly pass MAC addresses used by bootloader
to individual interfaces into kernel device tree.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 72ac807cae25..f2aaaed69ae9 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -23,6 +23,12 @@ chosen {
 		stdout-path = &uart0;
 	};
 
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+		ethernet2 = &eth2;
+	};
+
 	memory {
 		device_type = "memory";
 		reg = <0x00000000 0x40000000>; /* 1024 MB */
-- 
2.35.1



