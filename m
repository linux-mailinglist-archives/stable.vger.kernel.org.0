Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA7449A3D4
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368861AbiAYAAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846536AbiAXXQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:16:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C9C061776;
        Mon, 24 Jan 2022 11:44:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63AADB81188;
        Mon, 24 Jan 2022 19:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A6DC340E5;
        Mon, 24 Jan 2022 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053476;
        bh=QoKvG1rlfkeJTxGZcwcVqHKO30I0UMzibYlNdPulq9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Djphgox4RyKxVMLn3zWItsgd0et0rAZJVQWsJoUXTx+o2P7zzRhyq/Skv1GrJaO/I
         BLwWKw2b6/W9hBxqrEQobLACHUpBXGNy0yL6i+O0XrcW7XuG5eOz8hf8Pzp9ooroXG
         yBYPXwQ/gwwifN+I/n2m7WOWqxpqIOv1pz5XkGzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/563] arm64: dts: amlogic: meson-g12: Fix GPU operating point table node name
Date:   Mon, 24 Jan 2022 19:37:23 +0100
Message-Id: <20220124184027.090788992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 959b299344e54..7342c8a2b322d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -52,7 +52,7 @@
 		secure-monitor = <&sm>;
 	};
 
-	gpu_opp_table: gpu-opp-table {
+	gpu_opp_table: opp-table-gpu {
 		compatible = "operating-points-v2";
 
 		opp-124999998 {
-- 
2.34.1



