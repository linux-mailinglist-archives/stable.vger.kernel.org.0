Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA4DD15DA
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732451AbfJIRYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732424AbfJIRYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:42 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4556121D7F;
        Wed,  9 Oct 2019 17:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641882;
        bh=ssAzw6BWhGL2G6UWNKMpXMhinAanx/MjgAnixJgzSCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hV+d0DfHh3Muuu1HHGD5TkXs7//J4+O8MrVKBxuQU6dhaE4NIoi2afyNOZsVRwIrg
         U6EWR/DbUhLtd++VTD+jxdHhEjUAz9uQ8mrF1zrG7oHnoNZKh3S+iW+KtpLpkSNdp4
         GnQqbFA1I8l6fY0nWfHRl0AEDyOrgq/LIfRn/oUU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/13] ARM: dts: am4372: Set memory bandwidth limit for DISPC
Date:   Wed,  9 Oct 2019 13:06:24 -0400
Message-Id: <20191009170635.536-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170635.536-1-sashal@kernel.org>
References: <20191009170635.536-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit f90ec6cdf674248dcad85bf9af6e064bf472b841 ]

Set memory bandwidth limit to filter out resolutions above 720p@60Hz to
avoid underflow errors due to the bandwidth needs of higher resolutions.

am43xx can not provide enough bandwidth to DISPC to correctly handle
'high' resolutions.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am4372.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index c9c9a47446e8e..56224aa5e83ee 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -1117,6 +1117,8 @@
 				ti,hwmods = "dss_dispc";
 				clocks = <&disp_clk>;
 				clock-names = "fck";
+
+				max-memory-bandwidth = <230000000>;
 			};
 
 			rfbi: rfbi@4832a800 {
-- 
2.20.1

