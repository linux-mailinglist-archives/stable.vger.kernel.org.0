Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E92310711F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfKVKeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:34:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbfKVKeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:34:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B0720708;
        Fri, 22 Nov 2019 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418850;
        bh=zwiB0jeC03ZgwzHt91IsT3P3zsTUgNluiRma6fPjWNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJT09dIuRbtI3Mkt/cE+pA7W4obbTYaceOczvtlDSirT6FmKpwwg6xJDJ37DolGTW
         E5uJtL538zUaLfQTm8xqErA5V3BbNTbvlFVst71WxbUczMVXfusXy77mBNCrEBvvVQ
         gQ7rxriWcOC2ppirE6+eysLtwhcFFR9KaQbIy878=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/159] ARM: dts: ux500: Correct SCU unit address
Date:   Fri, 22 Nov 2019 11:27:42 +0100
Message-Id: <20191122100756.858577292@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2f217d24ecaec2012e628d21e244eef0608656a4 ]

The unit address of the Cortex-A9 SCU device node contains one zero too
many.  Remove it.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 50f5e9d092038..86bd320057a38 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -186,7 +186,7 @@
 			      <0xa0410100 0x100>;
 		};
 
-		scu@a04100000 {
+		scu@a0410000 {
 			compatible = "arm,cortex-a9-scu";
 			reg = <0xa0410000 0x100>;
 		};
-- 
2.20.1



