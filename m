Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A6410705C
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfKVKnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbfKVKnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:43:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0852A20637;
        Fri, 22 Nov 2019 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419403;
        bh=2xHlJ7gI+TDUsL3xXM2gRKzP41ulc+uIo4yml40r8aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv+e1FCkXYZqCsnwT+WyFxhwZiDbaDjpQxJ+8jeCv7lASbBrT8LmKFfGbdrzAf7lF
         uk/p38gfdtbhNcHOvXbS6t5c+F9YzRXTiQ3faNJBeu3tDovB7QnvvFJYVY3LXh59fd
         l+k8TU6XQ4Ne9rG+wgrzYYL7AEDQH575Z4SSBnkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 099/222] ARM: dts: ux500: Correct SCU unit address
Date:   Fri, 22 Nov 2019 11:27:19 +0100
Message-Id: <20191122100910.563764366@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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
index d309314f3a364..45869c3234358 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -188,7 +188,7 @@
 			      <0xa0410100 0x100>;
 		};
 
-		scu@a04100000 {
+		scu@a0410000 {
 			compatible = "arm,cortex-a9-scu";
 			reg = <0xa0410000 0x100>;
 		};
-- 
2.20.1



