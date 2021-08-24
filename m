Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2646B3F6614
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhHXRUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233639AbhHXRSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 610F561A80;
        Tue, 24 Aug 2021 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824528;
        bh=eEYg/B55dRYvHXv+wyT+PjWLfT6t1pVbe1DU5SaQ68o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ljw+CfzgTKu0rIeLsTdv6nLf6eO0AGoe7nElqfZ1fkiUBkC2s2ZrN227dpyEiEsGF
         Bw6Oc7n0sd2eHLwnVN7vd3tIDthk4b2JUeU8Z7YpA172pt3bV2VJTh6WAlLmDwJCmh
         yN1dcEmixzWysrK9TxZKrSldY6n8VV+Dte4fkWwKKVqJtza8KjFtmTxpN3sjYYj4JA
         NCv8IW0eLrFMJchalV6V8MfCCV7s29EpSTrJ09zvQ4pJT/DLJWi1/NLHGeH/IgWpFw
         jS/oWu8/zlt8iKDMcUmJjBBcwv9rkWZ8AssZYpSvhyZjsmUE+ei/TzwwL74XFpxV4c
         ox3aMc3FX/oaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 61/61] Linux 5.4.143-rc1
Date:   Tue, 24 Aug 2021 13:01:06 -0400
Message-Id: <20210824170106.710221-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index ef3adc6ccb87..279a2f261a67 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 142
-EXTRAVERSION =
+SUBLEVEL = 143
+EXTRAVERSION = -rc1
 NAME = Kleptomaniac Octopus
 
 # *DOCUMENTATION*
-- 
2.30.2

