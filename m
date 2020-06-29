Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0204220DA51
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbgF2T4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387657AbgF2TkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3F3251DD;
        Mon, 29 Jun 2020 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444500;
        bh=xhWJChz3SBbtpKFTF6zZ2aiylfuY2mpZ7sYn66iPeus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcvsmngxQd9/gC1BZ5raLc3Jr+v1GySoQhajcpu04X8qv+NNx62GkaXxtUvsZ6xf4
         0ZZQdCi98PRwYcuDYawx/eGqrrEcNycCIexFFMAdbZekZn7KhNhn9bmb7mM9Nt8LnO
         3ZL142ODn4C89qYpWEBPrtRDdAhKQUJN1EmpEQPM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/178] Linux 5.4.50-rc1
Date:   Mon, 29 Jun 2020 11:25:23 -0400
Message-Id: <20200629152523.2494198-179-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 72230ad23299d..c68def87a88ad 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 49
-EXTRAVERSION =
+SUBLEVEL = 50
+EXTRAVERSION = -rc1
 NAME = Kleptomaniac Octopus
 
 # *DOCUMENTATION*
-- 
2.25.1

