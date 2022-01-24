Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1A4990BC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346719AbiAXUDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:03:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353260AbiAXUBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C155B8122F;
        Mon, 24 Jan 2022 20:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D309C340E5;
        Mon, 24 Jan 2022 20:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054494;
        bh=XKhNpFcyGUjE+sjTlejmD2OUYPSklbFBgEeUXUUIQe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPU4jHB/7hZKEoubXPoZsU5KKFr++YmltxEJQmdIYTQt3Alr5Rx5V8artuy2hswLq
         9T8JADaa8ULydhnUrI0yapJBBgRhv8Xy1kz7B1Q/vYNi1uok/4SJG3TB4dADHKhMdI
         43s/bev1ns/KgMaKHSnAHWaxxOV7keTrVcZawfNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/563] x86/kbuild: Enable CONFIG_KALLSYMS_ALL=y in the defconfigs
Date:   Mon, 24 Jan 2022 19:42:53 +0100
Message-Id: <20220124184038.548917070@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



