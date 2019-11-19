Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3DD1017B7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfKSFkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbfKSFkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:40:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CF6E21823;
        Tue, 19 Nov 2019 05:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142039;
        bh=m+Inve5hgRyZpw7gj6KahVQEpcPLzayG8F7xJuq27rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGBoJkApkapNZR3Kqh3chV9DHWkN5inaPmfRulA9AIG83jNiCyv3Yr9BOCkvQzJDd
         5acmYqgYgty+zSbAOPikoPSc20HwVe2tKsyopQtySQLJQ21PwtE4rN9oB0y2YowE2L
         Suhg9Pd9y14DgBgHlqMW1mUtavc/E6tYUB2qJA7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 368/422] ARM: dts: tegra30: fix xcvr-setup-use-fuses
Date:   Tue, 19 Nov 2019 06:19:25 +0100
Message-Id: <20191119051422.860062893@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



