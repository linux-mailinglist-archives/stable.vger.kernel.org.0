Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB6E1E03DB
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 01:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbgEXXSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 19:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388202AbgEXXSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 May 2020 19:18:36 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2F9920812;
        Sun, 24 May 2020 23:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590362315;
        bh=wHnSQz1xLFqPadFQBvEagMYP+phV0pSRZsf5R0rRBus=;
        h=Date:From:To:Subject:From;
        b=dwTnWV3Fhx716cxDYQA+C99ZCGuTt9IKWlX/Wr7IHAJ0EAen7elZTpEVPZc9SFZ/4
         sA910ln4skCeOjXZT8EZykT2ORf45LadK44vfd481dtIlMVcwDA89ELDSVt+SCf9GR
         7h8PXvTVLVNu8Fumu2gjGRaWjDY5EhDc/pMThfSE=
Date:   Sun, 24 May 2020 16:18:34 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, dalias@libc.org, davem@davemloft.net,
        glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, ysato@users.sourceforge.jp
Subject:  [merged] sh-include-linux-time_typesh-for-sockios.patch
 removed from -mm tree
Message-ID: <20200524231834.hU9Liq05k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: sh: include linux/time_types.h for sockios
has been removed from the -mm tree.  Its filename was
     sh-include-linux-time_typesh-for-sockios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: sh: include linux/time_types.h for sockios

Using the socket ioctls on arch/sh (and only there) causes build time
problems when __kernel_old_timeval/__kernel_old_timespec are not already
visible to the compiler.

Add an explict include line for the header that defines these
structures.

Link: http://lkml.kernel.org/r/20200519131327.1836482-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Fixes: 8c709f9a0693 ("y2038: sh: remove timeval/timespec usage from headers")
Fixes: 0768e17073dc ("net: socket: implement 64-bit timestamps")
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/uapi/asm/sockios.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sh/include/uapi/asm/sockios.h~sh-include-linux-time_typesh-for-sockios
+++ a/arch/sh/include/uapi/asm/sockios.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_SH_SOCKIOS_H
 #define __ASM_SH_SOCKIOS_H
 
+#include <linux/time_types.h>
+
 /* Socket-level I/O control calls. */
 #define FIOGETOWN	_IOR('f', 123, int)
 #define FIOSETOWN 	_IOW('f', 124, int)
_

Patches currently in -mm which might be from arnd@arndb.de are

drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
arm64-add-support-for-folded-p4d-page-tables-fix.patch

