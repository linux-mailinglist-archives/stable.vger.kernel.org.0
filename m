Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8649181B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344464AbiARCo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346857AbiARCkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:40:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1886B8125F;
        Tue, 18 Jan 2022 02:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44390C36AEB;
        Tue, 18 Jan 2022 02:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473602;
        bh=5ND4c0WFizvbyzJNtRy1VuRdoEZMvxVRqMNu9KAXCrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQBcjwJSWvupi4TQqIVzbbN6jvlG8xeyQZKiS0BFP3HMmOzwlqcjXMtbS6HToR9lH
         89mVrdmdv124yeZp/bp/g1sRLIS8bdbZJpEgNLZyEKsQhlM4hM7GRK6fLIn+x5+A9M
         eX9pSzaQDufxin2EDJS/xInIWXFvk1j3jVCKPWiltUcR5NiWc4sGEfpUOg0IlcM5jF
         HctYUm2eQKNXYrWETX8wQaoEogNBSbgAWAuR/YJc+5sg7BC2QFL6Rui7kwaXOFTlTc
         E1oN894rs5RtVBzaX8+W8cVbzGhfUTh//PhsGpkac8pH9d1QX5mc2FTYysQcju/HDU
         rgaH+JtG9BEKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        emil.l.velikov@gmail.com, akpm@linux-foundation.org,
        mbenes@suse.cz, yuzenghui@huawei.com, jeyu@kernel.org
Subject: [PATCH AUTOSEL 5.15 187/188] x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs
Date:   Mon, 17 Jan 2022 21:31:51 -0500
Message-Id: <20220118023152.1948105-187-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit b6aa86cff44cf099299d3a5e66348cb709cd7964 ]

Most distro kernels have this option enabled, to improve debug output.

Lockdep also selects it.

Enable this in the defconfig kernel as well, to make it more
representative of what people are using on x86.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/YdTn7gssoMVDMgMw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/configs/i386_defconfig   | 1 +
 arch/x86/configs/x86_64_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index e81885384f604..99398cbdae434 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -262,3 +262,4 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_BOOT_PARAMS=y
+CONFIG_KALLSYMS_ALL=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index e8a7a0af2bdaa..d7298b104a456 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -258,3 +258,4 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_BOOT_PARAMS=y
+CONFIG_KALLSYMS_ALL=y
-- 
2.34.1

