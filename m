Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88A3F6807
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhHXRj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241605AbhHXRgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:36:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C74661BE2;
        Tue, 24 Aug 2021 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824817;
        bh=33KM5CjdMIk139wwCKYxIjjNm9bDTq1SwXqP1doeXqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQs4a9AgZqqg7HxbwT5wKnffANHbiATL5bYivEJ88mw2Mb55Y7dvw9lCBJNXB1j+4
         /tAp7Cj4UbYaShVM1wlNsKYno/SoXmf1JXLVubQZ6vBur5OwGUdZHHHQ6pycGKlwnb
         OC5vNVfqXgM8A+HFkXiPm/ml4mBllzX9t44ocSB4q7fdVXQ7GAOVnp2EXJbTDIgrri
         Ri6OBWt07yK1jGkv1u01xA5HWEca2I6rowymu/GmNwRQ2rMzwhePNvYiOdzrQtZSt0
         PVFpDQyggWtgIqBqHFfQ61FE5KbDj/c6hoE82ZgLmiU4+r1OwD0IBOdChWkh4EP/f/
         SVIXh/NGOsx3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 43/43] Linux 4.9.281-rc1
Date:   Tue, 24 Aug 2021 13:06:14 -0400
Message-Id: <20210824170614.710813-44-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
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
index 7cd5634469b1..332713b5a28f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 280
-EXTRAVERSION =
+SUBLEVEL = 281
+EXTRAVERSION = -rc1
 NAME = Roaring Lionus
 
 # *DOCUMENTATION*
-- 
2.30.2

