Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF420E671
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgF2Vrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:47:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgF2Sfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D46247FD;
        Mon, 29 Jun 2020 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444158;
        bh=jdiMQr74Yq2b5xzRJm8F6KeMfVMUP2Cub25O16tZpEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGjRo4XDZVDsRuKBN0OHfECxgUVkrJKlICu9IZHSz0a4Z0DZixTR3G925BwcDOP8T
         serqgrfbQoxKuabuG5oXXOHqe+koQUnwtokLh1LlBu1py8hGnumiA+JEli/K0HsTQr
         ENiRW7+i0GA0cq015ZgUMZ1gQy3pww/sbsDKE1o4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 265/265] Linux 5.7.7-rc1
Date:   Mon, 29 Jun 2020 11:18:18 -0400
Message-Id: <20200629151818.2493727-266-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
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
index f928cd1dfdc17..a07567cf0754f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 7
-SUBLEVEL = 6
-EXTRAVERSION =
+SUBLEVEL = 7
+EXTRAVERSION = -rc1
 NAME = Kleptomaniac Octopus
 
 # *DOCUMENTATION*
-- 
2.25.1

