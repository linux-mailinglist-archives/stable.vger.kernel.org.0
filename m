Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8283F6774
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHXRfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239034AbhHXRcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC56D61505;
        Tue, 24 Aug 2021 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824760;
        bh=FZAvtgUWeXnithMagpl5slVvvRi710EXwDS5K22TEsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lY0x06TmCQ//bKxeAGFU7kitMcN6TZVXABY/+11fy90/CExeoYVeY+fBJt7cgMC19
         Aby3nYOeMbHN2H5E7oWyTyDK9Z31trsrVoH17mXlVtEBfXrolB/A5lEdyV6valwdVA
         eK+HvYYMTtNw3Sq1JeSPy1Zctf+5z+V0v6snjflLe+p8SANESHFVrW76zXIn9ZJRHo
         3w9q+YrpPhy2I3x3N3sJl10KzHYIHIo/uoFNUNoYVG3qCC1Er7hWxYY9MCtYM0ZJ1u
         7G7o5cQYQotL+U6uIqefn8RnV/rM2ggn/Y3/TZZ1N/r5tlJE230mcOqbAji4JGKecm
         AZEU08CAt2UaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 64/64] Linux 4.14.245-rc1
Date:   Tue, 24 Aug 2021 13:04:57 -0400
Message-Id: <20210824170457.710623-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index ef77eb6d5d29..10ff170e0743 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 244
-EXTRAVERSION =
+SUBLEVEL = 245
+EXTRAVERSION = -rc1
 NAME = Petit Gorille
 
 # *DOCUMENTATION*
-- 
2.30.2

