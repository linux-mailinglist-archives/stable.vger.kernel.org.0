Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3B40E3D7
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbhIPQwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345332AbhIPQuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF8D61529;
        Thu, 16 Sep 2021 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809688;
        bh=CMqxuankr/nLAtF68BcOJcYLaZl/uFUfJwFMddfQBVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9tcr9udIIrTrLyh2IdZJWUTPwf2SwQZCx1Wg/nQZ9MDOvirMWL8bWmcTC/TmB/+G
         XMLJ05kO8W41tHA45Wp8K2ShJTkvCL5i5Aao1/ixQHZssSl84pqgLZ1rJcLvTX2owu
         NxXB7DYHrGzRnV2p7uY6fIhQ9gDzGbD5aK489+8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 214/380] ARM: dts: stm32: Set {bitclock,frame}-master phandles on DHCOM SoM
Date:   Thu, 16 Sep 2021 17:59:31 +0200
Message-Id: <20210916155811.354540084@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit a79e78c391dc074742c855dc0108a88f781d56a3 ]

Fix the following dtbs_check warning:
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: codec@a: port:endpoint@0:frame-master: True is not of type 'array'
arch/arm/boot/dts/stm32mp157c-dhcom-pdk2.dt.yaml: codec@a: port:endpoint@0:bitclock-master: True is not of type 'array'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: kernel@dh-electronics.com
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 6cf1c8b4c6e2..c9577ba2973d 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -172,15 +172,15 @@ sgtl5000_port: port {
 			sgtl5000_tx_endpoint: endpoint@0 {
 				reg = <0>;
 				remote-endpoint = <&sai2a_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&sgtl5000_tx_endpoint>;
+				bitclock-master = <&sgtl5000_tx_endpoint>;
 			};
 
 			sgtl5000_rx_endpoint: endpoint@1 {
 				reg = <1>;
 				remote-endpoint = <&sai2b_endpoint>;
-				frame-master;
-				bitclock-master;
+				frame-master = <&sgtl5000_rx_endpoint>;
+				bitclock-master = <&sgtl5000_rx_endpoint>;
 			};
 		};
 
-- 
2.30.2



