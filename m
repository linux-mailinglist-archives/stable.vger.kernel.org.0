Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116D720E641
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732348AbgF2Vpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E721A246A9;
        Mon, 29 Jun 2020 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443998;
        bh=CqOeqfPXzvth/G+CUwq/RVhH4XxjIDmf9SOE6nHHQQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcZJFAumXtlZwLXGc6xwy5jpVhZ3tegQ0qylxRzi1q0gl7wBDVa46241f7TbYq+2C
         kB4lN3+1rDCJKuatx0ffzSocf4zXxqevEfDxUbYbI+tCE2LAUWaTY4sbMpWS30uhpL
         k226ogbHVlqDZXMym+98XJassJ/jp2cdU4gJtBqI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 103/265] ARM: dts: BCM5301X: Add missing memory "device_type" for Luxul XWC-2000
Date:   Mon, 29 Jun 2020 11:15:36 -0400
Message-Id: <20200629151818.2493727-104-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit de1f6d9304c38e414552c3565d36286609ced0c1 ]

This property is needed since commit abe60a3a7afb ("ARM: dts: Kill off
skeleton{64}.dtsi"). Without it booting silently hangs at:
[    0.000000] Memory policy: Data cache writealloc

Fixes: 984829e2d39b ("ARM: dts: BCM5301X: Add DT for Luxul XWC-2000")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
index 334325390aed0..29bbecd36f65d 100644
--- a/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
+++ b/arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts
@@ -17,6 +17,7 @@
 	};
 
 	memory {
+		device_type = "memory";
 		reg = <0x00000000 0x08000000
 		       0x88000000 0x18000000>;
 	};
-- 
2.25.1

