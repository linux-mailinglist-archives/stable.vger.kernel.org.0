Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466F0404B11
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbhIILuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:50:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237353AbhIILqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6A061260;
        Thu,  9 Sep 2021 11:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187785;
        bh=/Xxj20sRBcLNdFFwDKnISn2whS1d6LP/xeNOEoV1zBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Skwb5MWyjSaVraq8tTyOWV8/L1JIVB1ePv2v9NJGJWnDf/Zi5dFdS5musXLsVlpRT
         gzbhIElXNsnZI9D1+KJN+Gm6HqjFUiVe7waWWnZJveS6IGhpvBeMRHHP+KRXoGb+t6
         ZlEf0EO/bwWI5yBP20cWNbGtHJEqdLEfl3akK/sxCkY0wQ9jpx4xtRAZNqMdlgc0pF
         ug/QiCp47/POoYu76E2tMpVYlb32xXm/OKRkqZgvdH4UPloVryaNFC1XCSLDHg2btK
         0J6GS9x+vZzwr3B9yTp17QicuQ0Ci3lDkNiwnIZAv8/Wouh4b9t6TKhouhw1YvcsS4
         Xi458XHBBnl/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 093/252] ARM: dts: stm32: Set {bitclock,frame}-master phandles on ST DKx
Date:   Thu,  9 Sep 2021 07:38:27 -0400
Message-Id: <20210909114106.141462-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8aec45d7884f16cc21d668693c5b88bff8df0f02 ]

Fix the following dtbs_check warning:
cs42l51@4a: port:endpoint@0:frame-master: True is not of type 'array'
cs42l51@4a: port:endpoint@0:bitclock-master: True is not of type 'array'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
index 59f18846cf5d..586aac8a998c 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
@@ -220,15 +220,15 @@ cs42l51_port: port {
 			cs42l51_tx_endpoint: endpoint@0 {
 				reg = <0>;
 				remote-endpoint = <&sai2a_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&cs42l51_tx_endpoint>;
+				bitclock-master = <&cs42l51_tx_endpoint>;
 			};
 
 			cs42l51_rx_endpoint: endpoint@1 {
 				reg = <1>;
 				remote-endpoint = <&sai2b_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&cs42l51_rx_endpoint>;
+				bitclock-master = <&cs42l51_rx_endpoint>;
 			};
 		};
 	};
-- 
2.30.2

