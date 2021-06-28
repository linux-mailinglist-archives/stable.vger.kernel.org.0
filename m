Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996073B62E2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbhF1OuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236290AbhF1OrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C31261C92;
        Mon, 28 Jun 2021 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890881;
        bh=swM6UjZeWSlenpf0xNQWZmWJcGxUmqoN9w+2zmdIq04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myAWce8zepaelHPnxUW2hM719BsLT5Y74CyiefZGkvhiQvtbpxT+aW0v8egtHpxXW
         wEXmsoNtsgwurdhOCGbMFUl/LUudNW8j4LtQPr2dpR5l3O0hLEdVh2VSF3/DG5/DZM
         g+4wjPijuaV8LAveZRx5LQ6cxPQdjY3cMXlopiKKzR4F498ayorc0ldzoXr2yCQzhh
         d44ACAWDKCqnfD3Vu6u4+rgRWoPIOTERwGSlL4iUB4SId3oGmAmB4iHyk0x8FT6Haw
         duPrIf6DJfKszriJYAEmGGuQ5rI9QnzPiyO7vKIcOx91M18VtTMtjXqC5sFRZhdhdI
         Br5Ce23Eu3p/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 109/109] Linux 4.19.196-rc1
Date:   Mon, 28 Jun 2021 10:33:05 -0400
Message-Id: <20210628143305.32978-110-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index cda7a18b925a..3a382632a24a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 195
-EXTRAVERSION =
+SUBLEVEL = 196
+EXTRAVERSION = -rc1
 NAME = "People's Front"
 
 # *DOCUMENTATION*
-- 
2.30.2

