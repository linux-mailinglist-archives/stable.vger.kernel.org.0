Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9EB3BBBC5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 12:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhGELCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 07:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231314AbhGELCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 07:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04F526141C;
        Mon,  5 Jul 2021 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625482782;
        bh=jVEznDZBHwXs3iXlq3onq1Qk0ye87DewuuPJO9ikdkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RN45mpgOtjJ2W1jTua0IED4CbDRJhd5NZdPV+Aig7ZcWbJi1sqjjgMCFNbtNUTdwz
         A07TPmt8EDy0w5xBOxY+iuEQtNvtOAadn7MFR7ML7n5xPGdQrqYMu0KMSK/NfhQPTq
         ASSD3oTo8g9DpnkXT3F75mfL8/+BqL7pgrW1IsyLibzZNzsLWmGlKygRsXJw5rL0xt
         hLmRjFYdQhu3YzG2JvfMt5fz46fMftHutm2sFTBoaA3FCl4yej2bmmxDfP1X1VnsPP
         vg+0rBNu0MhLR6mcpvV1pQQXVVDd5VQsUoF+2/ExBwbNvSyJw1LfB3EO3GFUEYCQzB
         TopTqKHJG9Pzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 7/7] Linux 5.12.15-rc1
Date:   Mon,  5 Jul 2021 06:59:34 -0400
Message-Id: <20210705105934.1513188-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705105934.1513188-1-sashal@kernel.org>
References: <20210705105934.1513188-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.15-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.15-rc1
X-KernelTest-Deadline: 2021-07-07T10:59+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 433f164f9ee0..db547eea0737 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 12
-SUBLEVEL = 14
-EXTRAVERSION =
+SUBLEVEL = 15
+EXTRAVERSION = -rc1
 NAME = Frozen Wasteland
 
 # *DOCUMENTATION*
-- 
2.30.2

