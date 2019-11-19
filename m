Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA11016BA
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732000AbfKSFxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731996AbfKSFxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:53:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0A3721783;
        Tue, 19 Nov 2019 05:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142797;
        bh=SJgM5lnoSsKMqTXorMM97fCNVXFdbc3dHn/7MZUJn+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luLnF87yQ65e0h+OhShSPO8ti9WMWB0cgBRzU43RzoTGJ9wPfZfd9NFMJu6rUwGsW
         hHX6SZxFhZuA3lVd3lXov4A0ItAkp/Nzbyy711fn3zSvqZ58BkQjz7E7ZCm0R+LhKC
         Z2NZp2CHXEe+JduE/yEYeVgC/Ud2AK/Px2JbkyzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 202/239] ARM: dts: tegra30: fix xcvr-setup-use-fuses
Date:   Tue, 19 Nov 2019 06:20:02 +0100
Message-Id: <20191119051336.583017289@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
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
index c3e9f1e847db8..cb5b76e958131 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -840,7 +840,7 @@
 		nvidia,elastic-limit = <16>;
 		nvidia,term-range-adj = <6>;
 		nvidia,xcvr-setup = <51>;
-		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <1>;
 		nvidia,xcvr-lsrslew = <1>;
 		nvidia,xcvr-hsslew = <32>;
@@ -877,7 +877,7 @@
 		nvidia,elastic-limit = <16>;
 		nvidia,term-range-adj = <6>;
 		nvidia,xcvr-setup = <51>;
-		nvidia.xcvr-setup-use-fuses;
+		nvidia,xcvr-setup-use-fuses;
 		nvidia,xcvr-lsfslew = <2>;
 		nvidia,xcvr-lsrslew = <2>;
 		nvidia,xcvr-hsslew = <32>;
@@ -913,7 +913,7 @@
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



