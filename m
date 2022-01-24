Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DF4499080
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353166AbiAXUA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:00:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42064 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352711AbiAXT5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:57:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFBB5B81239;
        Mon, 24 Jan 2022 19:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153BDC340E5;
        Mon, 24 Jan 2022 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054231;
        bh=DEHeXxGMoZ459O6MpLMINR8caHq/plgIdLNric1bdMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkT6cP7bagKRZeOYhMYNZVSu6fDAEABIIrECFkwKxH7ZnBA7ZuymsaPuviBdCZcBC
         SAHS4zDeg+Pg1ZSqtSn+oVDi2AS5uVGdWm5DpDjUsHo98Lo7ICzEw3mLTWdkc5UHEB
         at3AXMlt0pTxm1fgPdZA/k0D0XY4J6LOQ7xrBcOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/563] arm64: tegra: Remove non existent Tegra194 reset
Date:   Mon, 24 Jan 2022 19:40:53 +0100
Message-Id: <20220124184034.409760358@linuxfoundation.org>
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

From: Sameer Pujar <spujar@nvidia.com>

[ Upstream commit 146b3a77af8091cabbd1decc51d67799e69682d2 ]

Tegra194 does not really have "hda2codec_2x" related reset. Hence drop
this entry to reflect actual HW.

Fixes: 4878cc0c9fab ("arm64: tegra: Add HDA controller on Tegra194")
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1640260431-11613-4-git-send-email-spujar@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 815df654e6387..05cf606b85c9f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -786,9 +786,8 @@
 				 <&bpmp TEGRA194_CLK_HDA2CODEC_2X>;
 			clock-names = "hda", "hda2hdmi", "hda2codec_2x";
 			resets = <&bpmp TEGRA194_RESET_HDA>,
-				 <&bpmp TEGRA194_RESET_HDA2HDMICODEC>,
-				 <&bpmp TEGRA194_RESET_HDA2CODEC_2X>;
-			reset-names = "hda", "hda2hdmi", "hda2codec_2x";
+				 <&bpmp TEGRA194_RESET_HDA2HDMICODEC>;
+			reset-names = "hda", "hda2hdmi";
 			power-domains = <&bpmp TEGRA194_POWER_DOMAIN_DISP>;
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_HDAR &emc>,
 					<&mc TEGRA194_MEMORY_CLIENT_HDAW &emc>;
-- 
2.34.1



