Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C58409463
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344586AbhIMObE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345798AbhIMO3F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13179615A6;
        Mon, 13 Sep 2021 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541029;
        bh=IwfoSMhYYqULgo1yTTS7xIM6dxUj5lnP/bFGbafcOT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECbg0ryItdlQr9KyBqIZVnr4DRe8YtnjfIy5SC8J73VbmKRNX2YX0Iey/WuJ2znEj
         ABAq79Kla/QsqS6twH5kn2Yp20BvFCtzfWuCT4tB0foNgYS9QPzvCAvs/vOV84KHhg
         qjoSu5cM8kuLuBxmaN5PSdrZ58Y+bBOyUOX54xZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 100/334] arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties
Date:   Mon, 13 Sep 2021 15:12:34 +0200
Message-Id: <20210913131116.751876378@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 4ec82a7bb3db8c6005e715c63224c32d458917a2 ]

The "max-clock" and "min-vrefresh" properties fail to validate with
commit cfe34bb7a770c5d8 ("dt-bindings: drm: bridge: adi,adv7511.txt:
convert to yaml").  Drop them, as they are parts of an out-of-tree
workaround that is not needed upstream.

Fixes: bcf3003438ea4645 ("arm64: dts: renesas: r8a77995: draak: Enable HDMI display output")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Link: https://lore.kernel.org/r/975b6686bc423421b147d367fe7fb9a0db99c5af.1625134398.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
index 6783c3ad0856..57784341f39d 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
@@ -277,10 +277,6 @@
 		interrupt-parent = <&gpio1>;
 		interrupts = <28 IRQ_TYPE_LEVEL_LOW>;
 
-		/* Depends on LVDS */
-		max-clock = <135000000>;
-		min-vrefresh = <50>;
-
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
 		adi,input-clock = "1x";
-- 
2.30.2



