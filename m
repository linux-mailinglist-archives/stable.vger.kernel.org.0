Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1B4174C1
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346078AbhIXNKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346847AbhIXNIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D776461391;
        Fri, 24 Sep 2021 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488229;
        bh=6euuBzakJbT3+lBxnNivNGGGSBUl0+1EH6ISDNxaWgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dpvk8UmWEHKSsF5NXCXYaQYmxf53COEL7zsJCiogCum+myjSWFOx5nGZgxmFDYw88
         /alK+mDu8ULegsFe8WS/YeOWqE14S5huQWmtxb2MO4faohWw/rcnxljHRp00SJH6dx
         kl6tbQEbWPNKu083FBYFyvRA7FxtJmYClOjZ98a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Babu Moger <babu.moger@oracle.com>,
        Don Zickus <dzickus@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 32/63] Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH
Date:   Fri, 24 Sep 2021 14:44:32 +0200
Message-Id: <20210924124335.370245849@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 6fe26259b4884b657cbc233fb9cdade9d704976e ]

Commit 05a4a9527931 ("kernel/watchdog: split up config options") adds a
new config HARDLOCKUP_DETECTOR, which selects the non-existing config
HARDLOCKUP_DETECTOR_ARCH.

Hence, ./scripts/checkkconfigsymbols.py warns:

HARDLOCKUP_DETECTOR_ARCH Referencing files: lib/Kconfig.debug

Simply drop selecting the non-existing HARDLOCKUP_DETECTOR_ARCH.

Link: https://lkml.kernel.org/r/20210806115618.22088-1-lukas.bulwahn@gmail.com
Fixes: 05a4a9527931 ("kernel/watchdog: split up config options")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bf174798afcb..95f909540587 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -981,7 +981,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
-- 
2.33.0



