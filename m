Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FE14D8214
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbiCNL7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239915AbiCNL5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:57:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5280643EF6;
        Mon, 14 Mar 2022 04:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE19EB80DE4;
        Mon, 14 Mar 2022 11:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4733AC340E9;
        Mon, 14 Mar 2022 11:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647258975;
        bh=zAmBtxxf0vAvm+XiG5ACnQVwKv/vaIfK+Mk7XN5R41c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwmwD2DQJg8pNX8ws+pxby4/2/D3GUezNhQIbMhb05g/vsJHNgLhTtZvMktWCEIbm
         gIHrY62KDySmcj38RJvm0g7a6eA2fsoA55Gat979I1SplfQsrA6kH3mQaMb65Satl4
         hVuKntVBjfN8XWU7u+QSYUbYqqCsfEl2ItW7t7j8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/43] arm64: dts: armada-3720-turris-mox: Add missing ethernet0 alias
Date:   Mon, 14 Mar 2022 12:53:13 +0100
Message-Id: <20220314112734.486167101@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
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
index 16e73597bb78..cf139c399d03 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -18,6 +18,7 @@ / {
 
 	aliases {
 		spi0 = &spi0;
+		ethernet0 = &eth0;
 		ethernet1 = &eth1;
 	};
 
-- 
2.34.1



