Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024303B6086
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhF1OZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhF1OYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82E7961C7C;
        Mon, 28 Jun 2021 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890024;
        bh=Qcx2exETMwbWlcfQpu+JtH3K3hkT6PG7gh86QlRK8YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVqMWKAOYkA/ZT506ryb44tfKp2lbwMCdhKu4/vjUhphK7BIp5PpCfruE1e7PL+Py
         xGn3QJ9lUTB2G5Osz8DE6PITSvfv4FI5A8tYMbk+vDmoAItQjcteKo0d6HeCFZoJgY
         qVsT3NMFfue84HPnVqwZRfPNLfwJCh8PevpdFMERi5niA80TR+27jF6DqpAfc6mAJy
         p4I51t2s6FDnB+qmhhl1g2XHguPTxo9uLxV3feO+kXz/42JkFZbiG+bBsNvSGoeTyR
         29r3X8Ly0YeNcmqBiMzqAY1lA/ZV8DKPt0ezzJ5ZFybdz9jcsp7aqW3DD1z2A+vybq
         tf2lgNV4F0f0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 110/110] Linux 5.12.14-rc1
Date:   Mon, 28 Jun 2021 10:18:28 -0400
Message-Id: <20210628141828.31757-111-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
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
index d2fe36db78ae..a4b63b0f262b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 12
-SUBLEVEL = 13
-EXTRAVERSION =
+SUBLEVEL = 14
+EXTRAVERSION = -rc1
 NAME = Frozen Wasteland
 
 # *DOCUMENTATION*
-- 
2.30.2

