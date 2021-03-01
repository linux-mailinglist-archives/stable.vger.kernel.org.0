Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774A9328D31
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241000AbhCATHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240833AbhCATBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A69DF652F7;
        Mon,  1 Mar 2021 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620450;
        bh=lLyEmUG6GZLYZLA0lwKcNFsI2qW4i159cvnHbEdp9M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLd+ezDJnU72QztJ0e2JlhOV1T3sN3NaBY2PF6CGqfShm1KS6CTYi9GUQqaXeg8iI
         V0nLgDhEW/2kTmru1FAtXEtDvxBr2sOt3ou7GPNfsSasl3VycWNQPsGjzFVuo+iXsK
         LRT0luGJHDbCHwkFGaLLGWbIAxgygnEAl4WcE1ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, CK Hu <ck.hu@mediatek.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 157/775] arm64: dts: mt8183: Fix GCE include path
Date:   Mon,  1 Mar 2021 17:05:25 +0100
Message-Id: <20210301161209.403869456@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

[ Upstream commit 18d6e3f6744d6105ab61de790170cb60534eeebc ]

The header file of GCE should be for MT8183 SoC instead of MT8173.

Fixes: 91f9c963ce79 ("arm64: dts: mt8183: Add display nodes for MT8183")
Reported-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>

Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Link: https://lore.kernel.org/r/20210131101726.804-1-matthias.bgg@kernel.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 64fbba76597c8..36a90dd2fa7c6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -6,7 +6,7 @@
  */
 
 #include <dt-bindings/clock/mt8183-clk.h>
-#include <dt-bindings/gce/mt8173-gce.h>
+#include <dt-bindings/gce/mt8183-gce.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/memory/mt8183-larb-port.h>
-- 
2.27.0



