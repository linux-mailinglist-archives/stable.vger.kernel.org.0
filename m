Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B473D284F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhGVP4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232828AbhGVP40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 185CD60FDA;
        Thu, 22 Jul 2021 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971820;
        bh=NM/4S0tclPAg8L5MJJl3DeEGPSah6WTS4jnTBw9zfzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEgPekImVt8oRxf5Rd87h20o/IIOmm9ph6bPqzkofGZ79gz0cDl0fzIhsTYwSsnl7
         9oMtNmXRO5Yg3TSrlzIZBxt0yOjcD5XozrHIgdnMY290AuIpvBaspo6D4ARxq/XHe2
         BruQJNTRUtZNpZpEl5G3npVYsq7Q8L/CYzjUMU+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/125] arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
Date:   Thu, 22 Jul 2021 18:29:56 +0200
Message-Id: <20210722155624.865112081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit a7ecfad495f8af63a5cb332c91f60ab2018897f5 ]

A test with the command below aimed at powerpc generates
notifications in the Rockchip arm64 tree.

Fix pinctrl "sleep" nodename by renaming it to "suspend"
for rk3399.dtsi

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/powerpc/sleep.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210126110221.10815-2-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 7e69603fb41c..ee6287b872db 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2342,7 +2342,7 @@
 			};
 		};
 
-		sleep {
+		suspend {
 			ap_pwroff: ap-pwroff {
 				rockchip,pins = <1 RK_PA5 1 &pcfg_pull_none>;
 			};
-- 
2.30.2



