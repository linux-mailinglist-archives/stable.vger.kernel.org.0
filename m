Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC9A3B6385
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhF1O5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236284AbhF1OzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:55:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF2B61D4A;
        Mon, 28 Jun 2021 14:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891065;
        bh=+Q6c51PZYLxR1l5LiZhgvYZwZcDH5hLn+4Dne76I/1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6+Fk3zt0X6C8xgDVt/ufgDVHxuqaA9eae5dt316yMU9dpu1cgCmdw6kFOENAPn33
         lmV4zxwmjE2eTKSIOrLpkKG19FINrnNqgVoTLpv8ROF3qPlVx0f5jPCUObHFzLEbDt
         i2ttyjD4G5a1CnsbQr/4Udx4G7W/uj84xUW5ySE2EK38AIA5ox4TICSSa8WTDz8JhK
         +llBPQyo68207v7b+Gb9GQXWTpb5nP0F0sNUUytNyxto457u9xJEiszsB6HeJr4FvF
         2dAs0XKJeehGdjlKaoc8boDP9sGA2Ymyk2uLL0g9N1bLC0zRTZ3ViyNdJSd3OQmNBC
         J11B2awnbjsfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 88/88] Linux 4.14.238-rc1
Date:   Mon, 28 Jun 2021 10:36:28 -0400
Message-Id: <20210628143628.33342-89-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index e2977b8f8e6a..79d42138af06 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 237
-EXTRAVERSION =
+SUBLEVEL = 238
+EXTRAVERSION = -rc1
 NAME = Petit Gorille
 
 # *DOCUMENTATION*
-- 
2.30.2

