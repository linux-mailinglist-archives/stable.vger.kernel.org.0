Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FB84D82E0
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240849AbiCNMLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbiCNMJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:09:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB40F21E28;
        Mon, 14 Mar 2022 05:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 050C8B80DF2;
        Mon, 14 Mar 2022 12:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18651C340EC;
        Mon, 14 Mar 2022 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259575;
        bh=gGTai23t9U7lsssfYkhc6pfjBUzlubnpioPn2KQ35D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NmstQpoM8U7iEskX+Ss7umRqVo8GR7Vl6UoLPG+F30ILd9nTdO8PrXD/8uGaFF7Sj
         qZCrT3P1hH+GpvWjq1we0KcM4SNcw5bXHaUBlMKfRa2zHVC1Pikd0OAZXB6sk4710D
         tv0P6nX1jXLsN59czrLAz3Ej562pq5nYohVE6MlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/110] arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias
Date:   Mon, 14 Mar 2022 12:53:11 +0100
Message-Id: <20220314112743.293082993@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a0e897d1b36793fe0ab899f2fe93dff25c82f418 ]

U-Boot uses ethernet* aliases for setting MAC addresses. Therefore define
also alias for ethernet0.

Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index 04da07ae4420..1eddf31d8bd8 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -18,6 +18,7 @@ / {
 
 	aliases {
 		spi0 = &spi0;
+		ethernet0 = &eth0;
 		ethernet1 = &eth1;
 		mmc0 = &sdhci0;
 		mmc1 = &sdhci1;
-- 
2.34.1



