Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295B63B61F8
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhF1Oki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235179AbhF1Oja (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB5B61CD0;
        Mon, 28 Jun 2021 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890687;
        bh=nuV41df10RF+yOFq1wz8gkwsVW/lI/5lt8nlsskA7CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYWJNpTdLJgkT0eN7wNbPS7P/376PHxpLeANoyFRAy2OmlUWogS+puCLuzqYuwKHe
         O5XWoKQGNHWX1cCHpm53GonRoY4ABbM+XX9ljg8/teI7uboCu9EZwJk9UOOZYe4Qph
         YzQcjyXD9RrH+jGtoMlYX4L6r3MU2oiz+VhaOSNLLkhdeJ6R7zX7QOuKRcIAEmmv1C
         cfBNA+7MA71kRMjWphKP138MSf/kd51XCPdVdemEJ/hw2yPTMC2t6WOKyNegcl8sSD
         0j2EzusTdkoHYpXv6Y5BFH3Zet9m6NgvproWhutnFGbRNaDUsFcPRvKsn2ABjc3rfT
         tf3OZvOY/3oog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 71/71] Linux 5.4.129-rc1
Date:   Mon, 28 Jun 2021 10:30:04 -0400
Message-Id: <20210628143004.32596-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index 5db87d8031f1..057fa810f75d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 128
-EXTRAVERSION =
+SUBLEVEL = 129
+EXTRAVERSION = -rc1
 NAME = Kleptomaniac Octopus
 
 # *DOCUMENTATION*
-- 
2.30.2

