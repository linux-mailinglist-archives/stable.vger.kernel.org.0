Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8A0499B3E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574899AbiAXVul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457024AbiAXVko (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D03061519;
        Mon, 24 Jan 2022 21:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DA2C340E4;
        Mon, 24 Jan 2022 21:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060443;
        bh=m4BNfYQYC4dEYNrO6HUF/i8ht6RJdxFTmGaSFBrmAO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gd8LoQLJVHvw6TgNDOjI/is9zJypsvjTi0Wg4/1Q2IJDQxIjb/NIhX7f25F68RtEY
         IpbX5hknXv90D9GOphjTqf2bSUxITuL/ttapBSEn9aOYJIu06khgSmOIx5M2my+I/+
         PwmT54Ljp2a8KmPLCnqqCMY5nxzRQxMs9dk8ivvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.16 0950/1039] RISC-V: defconfigs: Set CONFIG_FB=y, for FB console
Date:   Mon, 24 Jan 2022 19:45:39 +0100
Message-Id: <20220124184157.220884764@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

commit 3d12b634fe8206ea974c6061a3f3eea529ffbc48 upstream.

We have CONFIG_FRAMEBUFFER_CONSOLE=y in the defconfigs, but that depends
on CONFIG_FB so it's not actually getting set.  I'm assuming most users
on real systems want a framebuffer console, so this enables CONFIG_FB to
allow that to take effect.

Fixes: 33c57c0d3c67 ("RISC-V: Add a basic defconfig")
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/configs/defconfig      |    1 +
 arch/riscv/configs/rv32_defconfig |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -78,6 +78,7 @@ CONFIG_DRM=m
 CONFIG_DRM_RADEON=m
 CONFIG_DRM_NOUVEAU=m
 CONFIG_DRM_VIRTIO_GPU=m
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -73,6 +73,7 @@ CONFIG_POWER_RESET=y
 CONFIG_DRM=y
 CONFIG_DRM_RADEON=y
 CONFIG_DRM_VIRTIO_GPU=y
+CONFIG_FB=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_XHCI_HCD=y


