Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C647FF88
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbhL0PiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:38:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37064 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbhL0Pgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:36:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DD436104C;
        Mon, 27 Dec 2021 15:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33809C36AE7;
        Mon, 27 Dec 2021 15:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619412;
        bh=jyzJ8CsAl2h1Zlax+4jLzyHJ8Zea266G9/0UYQKcRks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9VJw/8S+2jaebK3QGn3tcVPfipvlKXPHTu16a3CxZZfIq3dXbtDrBLxutsflP1c+
         qqixuNxzVd8/QfhHzeQWZrwISfwKroyRPfjat4AZCPiQkmR7Xo3Db4mrW7DxdxY2xG
         t1q+SruSZLy14n8RXC0s/TK20mAldlTaWJ5VhAjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Haa=C3=9F?= <vvvrrooomm@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/76] ARM: dts: imx6qdl-wandboard: Fix Ethernet support
Date:   Mon, 27 Dec 2021 16:30:30 +0100
Message-Id: <20211227151325.222123954@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Haaß <vvvrrooomm@gmail.com>

[ Upstream commit 39e660687ac0c57499134765abbecf71cfd11eae ]

Currently, the imx6q-wandboard Ethernet does not transmit any
data.

This issue has been exposed by commit f5d9aa79dfdf ("ARM: imx6q:
remove clk-out fixup for the Atheros AR8031 and AR8035 PHYs").

Fix it by describing the qca,clk-out-frequency property as suggested
by the commit above.

Fixes: 77591e42458d ("ARM: dts: imx6qdl-wandboard: add ethernet PHY description")
Signed-off-by: Martin Haaß <vvvrrooomm@gmail.com>
Tested-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-wandboard.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
index c070893c509ee..5bad982bc5a05 100644
--- a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
@@ -289,6 +289,7 @@
 
 		ethphy: ethernet-phy@1 {
 			reg = <1>;
+			qca,clk-out-frequency = <125000000>;
 		};
 	};
 };
-- 
2.34.1



