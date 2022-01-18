Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CC249189E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345145AbiARCr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:47:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346315AbiARCoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:44:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC7E6B81253;
        Tue, 18 Jan 2022 02:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD2DC36AE3;
        Tue, 18 Jan 2022 02:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473869;
        bh=XKhNpFcyGUjE+sjTlejmD2OUYPSklbFBgEeUXUUIQe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXxSIX+MGdbHkbraKhSm3DkGZhd/f+1KoS/7J8r0XZPNwW5QVcymAcMAOrv43hlL5
         /7/BrP1tiALYmF8ar7Cy3rdCEy3d37rT/J14VeRGwmSZD3jDv1hpPMj6JSAnWsGMPP
         ae9ct+fmxZNAks13bac0cQUAOFI2SbIiPjKwWv/EGu67gJoP1Hn7ljMv1Rp3bDSn8m
         XnQHOAenqhqDhMJQnmHg6kanxuwtwJGQWuPytN9JFQXiAFrJnp04vcyzNEsUVCJzr5
         0Uy9e3eMKvuSiKmf5FM3PqyYi+hDiahtKWj2ejG6MDuWEdzm8LkqO1qrCyWAa1FDsc
         /jJsLyFdjMIWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, yuzenghui@huawei.com,
        emil.l.velikov@gmail.com, mbenes@suse.cz, jeyu@kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 115/116] x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs
Date:   Mon, 17 Jan 2022 21:40:06 -0500
Message-Id: <20220118024007.1950576-115-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 78210793d357c..38d7acb9610cc 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -264,3 +264,4 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_BOOT_PARAMS=y
+CONFIG_KALLSYMS_ALL=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9936528e19393..c6e587a9a6f85 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -260,3 +260,4 @@ CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_BOOT_PARAMS=y
+CONFIG_KALLSYMS_ALL=y
-- 
2.34.1

