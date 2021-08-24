Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B8E3F6572
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239623AbhHXRNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240302AbhHXRLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D3F261A56;
        Tue, 24 Aug 2021 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824446;
        bh=uL1DaM94REAeRLW7BRqL4uEvCXSVHOqK5eVwzTmDwXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8PJyX4nRNcE+WC0fENyVKUlU2kulQlI+1Pu+PhVGSKkTSLC/8IzzsCYqViOi2rJQ
         nDKY9dOAvg4AA5uMPdp0gN0OuNoK3ho0jD/V89lfWTNPWzyPAXpon47fvBWtmNOZhy
         V37XSgH8uuTcLyL1U3iDltMuj4gr7AaUzSGjJAgdVlnx+PKPw8dFVg8WVteungGVyP
         IMQbYPJyOYalLWtdb1PWa9KStVct2gvHl6OnqQ6gvEtpUK9+n+DZRFPvfzJ1ugQMYg
         mWxTzCDRwW4EEL/kZwFk2GOUJ0UaVIzDTPeqkcfma2c960U07jmETtzUhDKV1ZWXc0
         2fmgUTTI5Wj+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 98/98] Linux 5.10.61-rc1
Date:   Tue, 24 Aug 2021 12:59:08 -0400
Message-Id: <20210824165908.709932-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 7f25cfee84ec..f3dfed58669a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 60
-EXTRAVERSION =
+SUBLEVEL = 61
+EXTRAVERSION = -rc1
 NAME = Dare mighty things
 
 # *DOCUMENTATION*
-- 
2.30.2

