Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7341729A
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbhIXMtl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344080AbhIXMsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B52F361263;
        Fri, 24 Sep 2021 12:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487628;
        bh=zXfFRyfYyAp7NTKlRijMpSZHiOrhBezwzfycXWgKBbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAySPps5Obv+CsHxJ3BSl4KCraJg5eHaFn0VbWnVnc4807JtKbMXYyWUU37+QdmCA
         F61jzg8836Ad0UX34fnynRglfG4G4FcIUagcf+/If1Uutu0SaxoOjZ46UmLfRTTpDR
         hbNazoIx85wscTam6aVXLn8ITwAzwYwKh3BfmBYk=
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
Subject: [PATCH 4.14 14/27] Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH
Date:   Fri, 24 Sep 2021 14:44:08 +0200
Message-Id: <20210924124329.646208137@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
index e1df563cdfe7..428eaf16a1d2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -816,7 +816,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
-- 
2.33.0



