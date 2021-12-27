Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B55480095
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhL0PrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240533AbhL0PpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1569DC08E893;
        Mon, 27 Dec 2021 07:42:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7B70610A3;
        Mon, 27 Dec 2021 15:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B63C36AE7;
        Mon, 27 Dec 2021 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619745;
        bh=7hX3vdCvA9trgVMeUIYrd+Wp2SKmBjxz218V12IW/ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+KU3ZazP8r9L7eGy8zCYQK5Pq9n0LC9R75uxkT2sGClP7yOJlvzoCaBKndPyth1a
         j/KeYL5mjU0Dg2N8rWs75nzy5TUKf70p871CMLSChhdtv4yGVkPhPu8yj4mN3r264i
         YQJwjvQJTsk1Z7dGNmH0W2FxE+RlRsFZx5qnH6yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Haa=C3=9F?= <vvvrrooomm@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/128] ARM: dts: imx6qdl-wandboard: Fix Ethernet support
Date:   Mon, 27 Dec 2021 16:29:57 +0100
Message-Id: <20211227151332.259238403@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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
index b62a0dbb033ff..ec6fba5ee8fde 100644
--- a/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-wandboard.dtsi
@@ -309,6 +309,7 @@
 
 		ethphy: ethernet-phy@1 {
 			reg = <1>;
+			qca,clk-out-frequency = <125000000>;
 		};
 	};
 };
-- 
2.34.1



