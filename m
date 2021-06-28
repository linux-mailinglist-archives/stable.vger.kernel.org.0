Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604883B642D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhF1PGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236647AbhF1PCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:02:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89E9B61D79;
        Mon, 28 Jun 2021 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891265;
        bh=x1wkEdfh374yAeZ2oLuFPvMMfTcuddnDbANfeo4hC4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDCooLKJ9ozg/R8Mdnj24aJuAmFU3oMa1vtNrZfJeYDN7+pBAAVuyL4ZRTqYPywty
         aNIAe2AaHt6OBSpcQ1WZSOVBZWpfpiE4y7YDEQCak/3YOzOjDhHfBOnlrdX+9jvHNX
         sswmgna/8QFf4NwVTlAkRz4ihgqk8rgOcBzHW6IX+PP8y6I6d6ZGgT1aApMqTOm9z1
         PJ7WmFhMQDe+gxC7ruL9eRU67dfjlE5RoorHWZjn79F5sK7FQNRxaIPGtSeq97BNfu
         LZ4V/8l5mNmjAREID1i1CEICdRoRUvfEFhSZJ4eAdyVOiLN72eaPp67A+In4cNyvD3
         k6I+WkobedGiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 71/71] Linux 4.9.274-rc1
Date:   Mon, 28 Jun 2021 10:40:03 -0400
Message-Id: <20210628144003.34260-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 651d4fbf56aa..8891b5dd49e1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 273
-EXTRAVERSION =
+SUBLEVEL = 274
+EXTRAVERSION = -rc1
 NAME = Roaring Lionus
 
 # *DOCUMENTATION*
-- 
2.30.2

