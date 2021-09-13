Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5D0408CB2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhIMNVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240127AbhIMNUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A6A8610CE;
        Mon, 13 Sep 2021 13:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539136;
        bh=POkwoucgkpqE5rhaUMUi8H+00gWE2sT70FBzr8K5p9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiQ3fTSbLF8kT2TumBJg96647IAehWK61HeHsRYByoJS2NUyKdxYIxbISo2aRQEKm
         dr3ze3tJPsugvOt4u+rMHIfB/BOrNajXBaAkZEBH1fLl/ofN09+IP2HkWXhP9dhNBY
         otNjbdavOVwgaQs0VuNuR+7zOadRlDk7jPAM6U8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/144] arm64: dts: renesas: r8a77995: draak: Remove bogus adv7511w properties
Date:   Mon, 13 Sep 2021 15:13:54 +0200
Message-Id: <20210913131049.715022857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 67634cb01d6b..cbdd46ed3ca6 100644
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



