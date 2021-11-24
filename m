Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DEF45C3FD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348575AbhKXNpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353666AbhKXNnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D2EA60C3F;
        Wed, 24 Nov 2021 12:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758748;
        bh=BbpHWivRzZID6ht/Rvo7OXU0ZAbqUhl0w4ryIymsZ2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL3L3CnUJj7hmZIX7dl8ntHlmra7b5x4dBVwz7/nVGumMe/jnjqV2cs7NEqKNy7uW
         axDNeirjuUqstV+QwEpsFpbPNvMoumSEHJckq1iI0+tyVQkOIf6ZAJJ6dNn4AIoGrw
         cLmevIZsPu117nc1Tn7d+wVBp82AXYEZqKWdpc4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/279] arm64: dts: allwinner: h5: Fix GPU thermal zone node name
Date:   Wed, 24 Nov 2021 12:54:52 +0100
Message-Id: <20211124115718.958203393@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 94a0f2b0e4e0953d8adf319c44244ef7a57de32c ]

The GPU thermal zone is named gpu_thermal. However, the underscore is
an invalid character for a node name and the thermal zone binding
explicitly requires that zones are called *-thermal. Let's fix it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20210901091852.479202-48-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index 578a63dedf466..9988e87ea7b3d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -217,7 +217,7 @@
 			};
 		};
 
-		gpu_thermal {
+		gpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 1>;
-- 
2.33.0



