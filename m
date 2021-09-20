Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B4D412235
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376620AbhITSNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359612AbhITSKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0E36326C;
        Mon, 20 Sep 2021 17:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158388;
        bh=yxYUSrgywU7Lb2n1z5YWmFZNy3ZpxmtpTFWAF0xA7Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKVJP9VC6nGT8kf86BoZlBMKOoKpGJWJAlkUsiKCcoLrJ141QIWp91z+4mQV4ml0w
         eU309JHMkTViuw1ORpWi2pVoPbUXphrY5f4PF0g5QHh7fIH7VgtkgfYdnBC0ZXblJ4
         NKvE8mdbSJdVO5Svh1WoFPkrs5ymkNCerHz+xP5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/260] arm64: tegra: Fix compatible string for Tegra132 CPUs
Date:   Mon, 20 Sep 2021 18:42:32 +0200
Message-Id: <20210920163935.677630122@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit f865d0292ff3c0ca09414436510eb4c815815509 ]

The documented compatible string for the CPUs found on Tegra132 is
"nvidia,tegra132-denver", rather than the previously used compatible
string "nvidia,denver".

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra132.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra132.dtsi b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
index 631a7f77c386..0b3eb8c0b8df 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -1082,13 +1082,13 @@ cpus {
 
 		cpu@0 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <0>;
 		};
 
 		cpu@1 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <1>;
 		};
 	};
-- 
2.30.2



