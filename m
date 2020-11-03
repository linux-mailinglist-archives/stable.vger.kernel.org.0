Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8A62A530D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbgKCU4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730150AbgKCUz7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:55:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49CD2223AC;
        Tue,  3 Nov 2020 20:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436958;
        bh=0dpWdwTyUicWvamudZYYQOxXp8kng+qjE0KDvBDZ+io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KK1i39rzgr1hVhMzR0penkJtDYRjjClTdlu2bsswntdn9GLrPy/0Vwj8SiIY1JsOn
         ASNfmBqxCo6gFNnuWX9I8g5hnCZVytNukhDM4IwIVAiB1oBRqWPjKGw5eL/FNgRQgN
         I+VcTg2nsW4uOsJcOX5EDMI2WayUG3ylyafqDViQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/214] arm64: dts: renesas: ulcb: add full-pwr-cycle-in-suspend into eMMC nodes
Date:   Tue,  3 Nov 2020 21:35:34 +0100
Message-Id: <20201103203258.426685474@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 992d7a8b88c83c05664b649fc54501ce58e19132 ]

Add full-pwr-cycle-in-suspend property to do a graceful shutdown of
the eMMC device in system suspend.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1594989201-24228-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/ulcb.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/ulcb.dtsi b/arch/arm64/boot/dts/renesas/ulcb.dtsi
index 3ef89171538ff..d8fccf3d4987a 100644
--- a/arch/arm64/boot/dts/renesas/ulcb.dtsi
+++ b/arch/arm64/boot/dts/renesas/ulcb.dtsi
@@ -470,6 +470,7 @@
 	mmc-hs200-1_8v;
 	mmc-hs400-1_8v;
 	non-removable;
+	full-pwr-cycle-in-suspend;
 	status = "okay";
 };
 
-- 
2.27.0



