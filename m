Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F031C1AD55F
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 06:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgDQEpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 00:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQEpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 00:45:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 948FE206D5;
        Fri, 17 Apr 2020 04:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587098730;
        bh=kDk+WqaNh0i0x4n4msX+HEVK0U5H7Tz2MZr3L9wy8vk=;
        h=Date:From:To:Subject:From;
        b=WcAtc2IOVQ5rRNBt6MviA8QdNmderPlK1fsdb4rvt0SIr8e1vAgUoB65eC1DK1JET
         Jt1xAAlQ7abxqKHuTeIoB1iYe80c4ctyhJwOu/nZ/8QyVQZKzdxDNRcqjJAo9JwZTL
         R/M5uH8VW5vPlJwB6Xia2YYyq+qXALzuwxVsp9bg=
Date:   Thu, 16 Apr 2020 21:45:30 -0700
From:   akpm@linux-foundation.org
To:     l.stach@pengutronix.de, martin@martingkelly.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  + tools-vm-fix-cross-compile-build.patch added to -mm
 tree
Message-ID: <20200417044530.nwVTUpFRV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tools/vm: fix cross-compile build
has been added to the -mm tree.  Its filename is
     tools-vm-fix-cross-compile-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-fix-cross-compile-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-fix-cross-compile-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lucas Stach <l.stach@pengutronix.de>
Subject: tools/vm: fix cross-compile build

7ed1c1901fe5 (tools: fix cross-compile var clobbering) moved the setup of
the CC variable to tools/scripts/Makefile.include to make the behavior
consistent across all the tools Makefiles.  As the vm tools missed the
include we end up with the wrong CC in a cross-compiling evironment.

Link: http://lkml.kernel.org/r/20200416104748.25243-1-l.stach@pengutronix.de
Fixes: 7ed1c1901fe5 (tools: fix cross-compile var clobbering)
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Cc: Martin Kelly <martin@martingkelly.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/vm/Makefile~tools-vm-fix-cross-compile-build
+++ a/tools/vm/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for vm tools
 #
+include ../scripts/Makefile.include
+
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api
_

Patches currently in -mm which might be from l.stach@pengutronix.de are

tools-vm-fix-cross-compile-build.patch

