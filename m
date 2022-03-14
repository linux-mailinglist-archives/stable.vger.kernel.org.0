Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB53A4D8279
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbiCNMEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240412AbiCNMDh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:03:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D966B49F8D;
        Mon, 14 Mar 2022 05:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C953B80DC2;
        Mon, 14 Mar 2022 12:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9A3C340ED;
        Mon, 14 Mar 2022 12:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259274;
        bh=4dnyVepvitlIwJlr9BRFyX0QDhIjvlzBvc/cJXlsIZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqbGmQWgXYZvNcKLsaN7HC+eDUoVbWVWbSwTzmeOAJWoZ00T5raB1c4SafPe0/roq
         AGbKIlEOZHNNUz8TSuXA8bGV7TiQ/j66u2fnUFjjPNLBD67oy4yyJPox0AEGe8M2/7
         E+jxerwM1UCgh8sCZ1D4iaN6EmDq08SfDgYw6QAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/71] arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias
Date:   Mon, 14 Mar 2022 12:52:57 +0100
Message-Id: <20220314112738.055097540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
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
index 2e437f20da39..ad963b51dcbe 100644
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



