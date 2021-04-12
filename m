Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EEE35CCF2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243396AbhDLQcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245220AbhDLQ37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CABD613B2;
        Mon, 12 Apr 2021 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244757;
        bh=drmCyLVMM3g40KL9Mo3sCVCoaJ7r/hp8MaFhlb8Z6Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/23i2vj438wPiG9uEFB3DtQaj06s1Quy8EG+kT5xXSMCQ7b1fB38/hrbmGC7shkU
         lmgbyB89LOKjoAXQqxc7XYFOlqRf2N5CjvRyeFRa+sSTrxBj1oIk4XY8+LkR8nCwOj
         O+m7LAx6c0HvzWQfCP49cua7VOSmt1qkdaHGGDYocVTXbNIwJG3q8n8SgTf/YFi6Vb
         xE69I4GQ0xFzw4gxP7to9J+2blkzXu057W8ixDNlgjrwM1p18Up+3yiw1cLAxfT+PN
         D0XbMHnYqpIjy8RybWeiFyWdjBb/EIfj4Sofcz6aIl7IyyJw/a5RUfRh6wFfPkmwbF
         T7JBf4vCuTlaw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/28] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 12 Apr 2021 12:25:28 -0400
Message-Id: <20210412162553.315227-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 77335a040178a0456d4eabc8bf17a7ca3ee4a327 ]

Fix moving mmc devices with dts aliases as discussed on the lists.
Without this we now have internal eMMC mmc1 show up as mmc2 compared
to the earlier order of devices.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4.dtsi | 5 +++++
 arch/arm/boot/dts/omap5.dtsi | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 8f907c235b02..046e77024567 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -25,6 +25,11 @@ aliases {
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
 		i2c3 = &i2c4;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
+		mmc3 = &mmc4;
+		mmc4 = &mmc5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 3c0bafe0fb05..cf66c374de4f 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -26,6 +26,11 @@ aliases {
 		i2c2 = &i2c3;
 		i2c3 = &i2c4;
 		i2c4 = &i2c5;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
+		mmc3 = &mmc4;
+		mmc4 = &mmc5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
2.30.2

