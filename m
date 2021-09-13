Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF7F408CB4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhIMNVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240387AbhIMNUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84A8F610CB;
        Mon, 13 Sep 2021 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539134;
        bh=tcuWKxDwjkaNl60qxwdmhgc9Vf4OTbu0O/Jo7aL/3qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bXqVpDw+pjSu0LF1xEn3DVNmedF103s4IJI169/gVusODpk4Vd9wzxGXfn45OW7VC
         2Ez9q6xxoWejgUcsN2lr6z6R06KqXuGRqNdIl/c4POIpJXLuQQRQAgTvSNFLlsSStm
         Y+m7dL5wH/CpuI6QBba7bceQlK0KhRk4qXJEYR8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dylan Hung <dylan_hung@aspeedtech.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/144] ARM: dts: aspeed-g6: Fix HVI3C function-group in pinctrl dtsi
Date:   Mon, 13 Sep 2021 15:13:53 +0200
Message-Id: <20210913131049.683933821@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Hung <dylan_hung@aspeedtech.com>

[ Upstream commit 8c295b7f3d01359ff4336fcb6e406e6ed37957d6 ]

The HVI3C shall be a group of I3C function, not an independent function.
Correct the function name from "HVI3C" to "I3C".

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Fixes: f510f04c8c83 ("ARM: dts: aspeed: Add AST2600 pinmux nodes")
Link: https://lore.kernel.org/r/20201029062723.20798-1-dylan_hung@aspeedtech.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
index 5b8bf58e89cb..996e006e06c2 100644
--- a/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
+++ b/arch/arm/boot/dts/aspeed-g6-pinctrl.dtsi
@@ -208,12 +208,12 @@
 	};
 
 	pinctrl_hvi3c3_default: hvi3c3_default {
-		function = "HVI3C3";
+		function = "I3C3";
 		groups = "HVI3C3";
 	};
 
 	pinctrl_hvi3c4_default: hvi3c4_default {
-		function = "HVI3C4";
+		function = "I3C4";
 		groups = "HVI3C4";
 	};
 
-- 
2.30.2



