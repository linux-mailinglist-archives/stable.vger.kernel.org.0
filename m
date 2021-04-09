Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550B2359AED
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhDIKHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhDIKC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B0C6127C;
        Fri,  9 Apr 2021 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962420;
        bh=aJ+3X9i87fk/SJTGsZozIBg0BfKzDMILthx6RBghRvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfFYMSpd/aT17WYqIfxhqifjA/OYqSa3meMApf0qhKTn+9BFIzOz3vJlf9849sROE
         t5uh9DT0Jmgwm89ByaPEhrReQLKbCQfdv/i84Uic5Z1oJrs4c15HEWQ2JAZ0THQCMM
         ye9CDzIUP6lwyq7zgfS0w94AKeJ+0xCr22Jz6vAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mans Rullgard <mans@mansr.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 01/45] ARM: dts: am33xx: add aliases for mmc interfaces
Date:   Fri,  9 Apr 2021 11:53:27 +0200
Message-Id: <20210409095305.448913442@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mans Rullgard <mans@mansr.com>

[ Upstream commit 9bbce32a20d6a72c767a7f85fd6127babd1410ac ]

Without DT aliases, the numbering of mmc interfaces is unpredictable.
Adding them makes it possible to refer to devices consistently.  The
popular suggestion to use UUIDs obviously doesn't work with a blank
device fresh from the factory.

See commit fa2d0aa96941 ("mmc: core: Allow setting slot index via
device tree alias") for more discussion.

Signed-off-by: Mans Rullgard <mans@mansr.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 5b213a1e68bb..5e33d0e88f5b 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -40,6 +40,9 @@ aliases {
 		ethernet1 = &cpsw_emac1;
 		spi0 = &spi0;
 		spi1 = &spi1;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
 	};
 
 	cpus {
-- 
2.30.2



