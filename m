Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22250F65E3
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfKJCoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:44:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbfKJCoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B6D21D7E;
        Sun, 10 Nov 2019 02:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353851;
        bh=m+Inve5hgRyZpw7gj6KahVQEpcPLzayG8F7xJuq27rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFre0IZe3Rd3jzKJ/9jVotB3E+D15l3i8QqYJnfjOIOs9wJbV2rCDyum1QFL32w8D
         qpfGQLFl4zc83IA2d+m186FlyDUTbONYP5MKGh1eqTjm9aOkruZnAxvJkxX2hsrCzn
         A6eax5FvZNXMDiVooUQ4joqzRyPH6lBd0sZ0FZXs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 137/191] ARM: dts: tegra30: fix xcvr-setup-use-fuses
Date:   Sat,  9 Nov 2019 21:39:19 -0500
Message-Id: <20191110024013.29782-137-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 564706f65cda3de52b09e51feb423a43940fe661 ]

There was a dot instead of a comma. Fix this.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra30.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index a6781f6533105..5a04ddefb71f6 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -896,7 +896,7 @@
 		nvidia,elastic-limit = <16>;
 		nvidia,term-range-adj = <6>;
 		nvidia,xcvr-setup = <51>;
-		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <1>;
 		nvidia,xcvr-lsrslew = <1>;
 		nvidia,xcvr-hsslew = <32>;
@@ -933,7 +933,7 @@
 		nvidia,elastic-limit = <16>;
 		nvidia,term-range-adj = <6>;
 		nvidia,xcvr-setup = <51>;
-		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
 		nvidia,xcvr-hsslew = <32>;
@@ -969,7 +969,7 @@
 		nvidia,elastic-limit = <16>;
 		nvidia,term-range-adj = <6>;
 		nvidia,xcvr-setup = <51>;
-		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
 		nvidia,xcvr-hsslew = <32>;
-- 
2.20.1

