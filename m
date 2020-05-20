Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6A1DA6FD
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgETBLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 21:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgETBLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 21:11:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE3120708;
        Wed, 20 May 2020 01:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589937111;
        bh=udlxMHEXr/AVGuRRIWp8U6kMMLg3Zh9mHrhTFuHE1/g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fi/9JgWdjJP60hBBhZtULTLzcBkZ7KU4nqiq11fb81wuyJlKxDNx1WG8ad1JwKxRI
         t/F4irs3RKgFnkqiqeyjlCIpaSzLgK5Zp/FH/3zEl8LP9aqWLACAwS90e5J8LFuKMZ
         mlSyv7xGQy5QIsivKcRMgORrKhOoJze8SmE4gikQ=
Date:   Tue, 19 May 2020 18:11:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     arnd@arndb.de, dalias@libc.org, davem@davemloft.net,
        glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, ysato@users.sourceforge.jp
Subject:  + sh-include-linux-time_typesh-for-sockios.patch added to
 -mm tree
Message-ID: <20200520011150.gRbyMdQi1%akpm@linux-foundation.org>
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: sh: include linux/time_types.h for sockios
has been added to the -mm tree.  Its filename is
     sh-include-linux-time_typesh-for-sockios.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-include-linux-time_typesh-for-sockios.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-include-linux-time_typesh-for-sockios.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-include-linux-time_typesh-for-sockios.patch
drm-remove-drm-specific-kmap_atomic-code-fix.patch
bitops-avoid-clang-shift-count-overflow-warnings.patch
ubsan-fix-gcc-10-warnings.patch
arm64-add-support-for-folded-p4d-page-tables-fix.patch

