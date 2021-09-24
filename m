Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631DF4172D8
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344559AbhIXMvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344570AbhIXMua (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B7176128B;
        Fri, 24 Sep 2021 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487708;
        bh=jeB8rICi2PBdXa8FY+3ayij9Dcc/Q25iDNHXwdQ4Y2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+H6v01OmT6cBsTnLMLx+OcS1PIx7AkV7gb2AstDjD4L/+zlRJYD1uLK+XqbcGF64
         2Un5gkhXdsLnDxmT60C+EtdrcEMuKIRX8hzi5uQXnlsE+LRBhGeJAyebUNcTjUcKhG
         58aOwRV5dqjwzzj+0VaFEl0wEGtTosL+Eb+Lnw2M=
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
Subject: [PATCH 4.19 17/34] Kconfig.debug: drop selecting non-existing HARDLOCKUP_DETECTOR_ARCH
Date:   Fri, 24 Sep 2021 14:44:11 +0200
Message-Id: <20210924124330.525960013@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
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
index 46a910acce3f..6970759f296c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -853,7 +853,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
-- 
2.33.0



