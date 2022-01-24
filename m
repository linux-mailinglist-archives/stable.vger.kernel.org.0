Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F1249967E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351667AbiAXVE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443811AbiAXU7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:59:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50C8C61330;
        Mon, 24 Jan 2022 20:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DC2C340E5;
        Mon, 24 Jan 2022 20:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057950;
        bh=8rZU2mkEPnLSkCNjqQB28l5RSQofZ+GqJfjHJOjlecg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyVEkbPMUmMvoaV69PbFmObY+5MSjtRkA8pVPrNyTX8a1QmKrdOs0FzCm5/gHrjIf
         FKiV0QzRYPCMbsS8JtBl2gDK8pc46oCYVbQq0Vmd9Kzz8jUFBYOPX/xMx5jCBcerD3
         52avpGQy4bh4xA0IFOZ9weeJ0srYRT2ArLUwRzIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0133/1039] arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name
Date:   Mon, 24 Jan 2022 19:32:02 +0100
Message-Id: <20220124184129.630000661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@mailbox.org>

[ Upstream commit bb98a6fd0b0e227cefb2ba91cea2b55455f203b7 ]

Starting with commit 94274f20f6bf ("dt-bindings: opp: Convert to DT
schema") the opp node name has a mandatory pattern. This change
fixes the dtbs_check warning:
gpu-opp-table: $nodename:0: 'gpu-opp-table' does not match
'^opp-table(-[a-z0-9]+)?$'
Put the 'gpu' part at the end to match the pattern.

Fixes: 916a0edc43f0 ("arm64: dts: amlogic: meson-g12: add the Mali OPP table and use DVFS")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211026182813.900775-2-alexander.stein@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 00c6f53290d43..428449d98c0ae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -58,7 +58,7 @@
 		secure-monitor = <&sm>;
 	};
 
-	gpu_opp_table: gpu-opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-124999998 {
-- 
2.34.1



