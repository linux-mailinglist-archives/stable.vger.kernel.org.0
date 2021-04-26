Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ABA36AD21
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhDZHck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232448AbhDZHcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA4661152;
        Mon, 26 Apr 2021 07:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422315;
        bh=eOqBakePeHBgDEfJtDLIlXXoiy70OjSR9X2KY4BoFnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b1x/f41E60Qo/4jzYvx8HDqbrfz236LijlEzMr2UJ3uFENcD/MDp66EHrHvTNGDI+
         6xLighFMcUgdJ/VugiBhn+0UbJ33ihjQYxspiFdXpNRFu22Ynvfo1MdMFt4FOjcmkq
         NTHDN8+lkOJ6wLp73sR0UkBBx8/8Tl3URGJBWISU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 24/32] ARM: dts: Fix swapped mmc order for omap3
Date:   Mon, 26 Apr 2021 09:29:22 +0200
Message-Id: <20210426072817.388695663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a1ebdb3741993f853865d1bd8f77881916ad53a7 ]

Also some omap3 devices like n900 seem to have eMMC and micro-sd swapped
around with commit 21b2cec61c04 ("mmc: Set PROBE_PREFER_ASYNCHRONOUS for
drivers that existed in v4.4").

Let's fix the issue with aliases as discussed on the mailing lists. While
the mmc aliases should be board specific, let's first fix the issue with
minimal changes.

Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 8a2b25332b8c..a2e41d79e829 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -22,6 +22,9 @@
 		i2c0 = &i2c1;
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
2.30.2



