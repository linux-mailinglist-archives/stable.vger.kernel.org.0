Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4564F1F2C00
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730704AbgFIATq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730594AbgFHXSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:18:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30CE12086A;
        Mon,  8 Jun 2020 23:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658293;
        bh=QxLNTLoFkVAQRZFL6FP0AaYyx28XvLeBWZ3LvlBhJ8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVQxpcZXnkpB7zmBcH2XkpHeUfuUVaQCwvw6MyoIZ18Pf7H3JSYzta9d/F5waAduO
         DjookbKN+nVbiZ+TnN77DH9XXQ9QaCuXaZNo6IpQhRnN0MIaWZAMFDnKZaUi8EPtI2
         tzumfTXm8NUykWbRGxdbdpQSTx5C88lygfHt1e2E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 297/606] ARM: 8970/1: decompressor: increase tag size
Date:   Mon,  8 Jun 2020 19:07:02 -0400
Message-Id: <20200608231211.3363633-297-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Stelmach <l.stelmach@samsung.com>

[ Upstream commit 2c962369d72f286659e6446919f88d69b943cb4d ]

The size field of the tag header structure is supposed to be set to the
size of a tag structure including the header.

Fixes: c772568788b5f0 ("ARM: add additional table to compressed kernel")
Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/vmlinux.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index fc7ed03d8b93..51b078604978 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -43,7 +43,7 @@ SECTIONS
   }
   .table : ALIGN(4) {
     _table_start = .;
-    LONG(ZIMAGE_MAGIC(2))
+    LONG(ZIMAGE_MAGIC(4))
     LONG(ZIMAGE_MAGIC(0x5a534c4b))
     LONG(ZIMAGE_MAGIC(__piggy_size_addr - _start))
     LONG(ZIMAGE_MAGIC(_kernel_bss_size))
-- 
2.25.1

