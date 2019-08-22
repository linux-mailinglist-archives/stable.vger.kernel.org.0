Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E070299A0C
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390780AbfHVRJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390773AbfHVRJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:28 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1105E233FE;
        Thu, 22 Aug 2019 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493767;
        bh=5YVlE2vUMqpY/t3ntX9fqj9uTRocxjJIUKfF3Fc0gsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM+ociBgyenWZCDpqpJN9fxMWFkKJqrbmpg91biqpIGY4rTYKXBTWdf6T1tsJIc8/
         VqLH/O0QfabzisoWfFxmPMNBs0oYhq1f8ZvMyUWe73ODhxcXyQkxX6J0z8SpqeXIEy
         axAwgIl1T9BOz/WzjBqXq3whKpRTMjb3OKBCmNA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 135/135] Linux 5.2.10-rc1
Date:   Thu, 22 Aug 2019 13:08:11 -0400
Message-Id: <20190822170811.13303-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index cfc667fe99597..20297675a90a6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 2
-SUBLEVEL = 9
-EXTRAVERSION =
+SUBLEVEL = 10
+EXTRAVERSION = -rc1
 NAME = Bobtail Squid
 
 # *DOCUMENTATION*
-- 
2.20.1

