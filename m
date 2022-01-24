Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983654998DF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453616AbiAXVad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43222 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450448AbiAXVUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:20:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17297614B4;
        Mon, 24 Jan 2022 21:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F97DC340E4;
        Mon, 24 Jan 2022 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059233;
        bh=LsVwnJIEvisLM9UBPEff0RzYO/iKyX2BTRuQHjWcbMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6zrh275JShnzzN+imn/4jk1mkOnKbaJ2UEHF8BT0/OldA8d3jdLDF+uqetRv9dNH
         WsaVXR1BqgeT06Qqg7oee3enknDcqco5pWYfb87EC31vFFPKp9olYvDizunkoLHqYk
         8J7ufPFbcamrpw+A1vT8QZLyqPSVduSvj7zV3euc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0514/1039] arm64: tegra: Remove non existent Tegra194 reset
Date:   Mon, 24 Jan 2022 19:38:23 +0100
Message-Id: <20220124184142.566214059@linuxfoundation.org>
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
index 851e049b3519c..dcc0e55d6bdbb 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -976,9 +976,8 @@
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



