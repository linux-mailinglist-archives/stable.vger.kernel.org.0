Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCC759A134
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350717AbiHSP5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351042AbiHSP4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:56:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E14B108129;
        Fri, 19 Aug 2022 08:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC59B827F8;
        Fri, 19 Aug 2022 15:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D64C433C1;
        Fri, 19 Aug 2022 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924272;
        bh=lwen1EgOL0WIJxndcyGGj6vv0zvik1mBKliZtD3eSSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4DKH9xflKrUrbYdwgcqKUDb5DqNZKh9cRzLbBxy9nTv8U+N8YugJ8K9qLNHP6xyW
         ginMcDDToW1Em09x2k3Kx+gT/1ylimkc24525hxbZ5TJcWcOaVgpQeQCZ8FZJeGeTd
         P1c60xqV/ediVjvfvEWPFVlQgNFxNAWUlv9ry6/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/545] ARM: dts: imx7d-colibri-emmc: add cpu1 supply
Date:   Fri, 19 Aug 2022 17:38:03 +0200
Message-Id: <20220819153834.347483067@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit ba28db60d34271e8a3cf4d7158d71607e8b1e57f ]

Each cpu-core is supposed to list its supply separately, add supply for
cpu1.

Fixes: 2d7401f8632f ("ARM: dts: imx7d: Add cpu1 supply")
Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-colibri-emmc.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi b/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
index af39e5370fa1..045e4413d339 100644
--- a/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
+++ b/arch/arm/boot/dts/imx7d-colibri-emmc.dtsi
@@ -13,6 +13,10 @@ memory@80000000 {
 	};
 };
 
+&cpu1 {
+	cpu-supply = <&reg_DCDC2>;
+};
+
 &gpio6 {
 	gpio-line-names = "",
 			  "",
-- 
2.35.1



