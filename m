Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D3B40E08A
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhIPQVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241747AbhIPQUE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:20:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29C5613A3;
        Thu, 16 Sep 2021 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808858;
        bh=whpcVyJRZN+NsnXXC9/NR7/jIQ+/1/X+427Ww8E2Fns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/7nSseaSnJlytKVisDufN4l4ZLPmIlhvSHuQI9NUyuRPxO+/uk6M4JYLZQ1JdxFr
         xJ7KWG5bTtQ8+1DbalVDMDGgpaAD4sdNHsHhs2fQ3464+WnSYwUUaixlNLERlyvoXU
         G74XJ5Pkm7bD+ZzHy1eFXGJ+Fi/hUzMzwBglD78o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/306] arm64: tegra: Fix compatible string for Tegra132 CPUs
Date:   Thu, 16 Sep 2021 17:59:21 +0200
Message-Id: <20210916155801.414395987@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index e40281510c0c..b14e9f3bfdbd 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -1215,13 +1215,13 @@ cpus {
 
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



