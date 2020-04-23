Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43FD1B64D9
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 21:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgDWTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 15:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgDWTwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 15:52:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B5FC20728;
        Thu, 23 Apr 2020 19:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587671522;
        bh=nT1Q9b4Dgyu4j+2afF+llngj8ZH5eLTlMwhjGW0yEuM=;
        h=Date:From:To:Subject:From;
        b=cym3h7d9jbtkvxd/Vfsta4QeKJIudgQDTfTjpFabagV0pZRWOqD2VWUXvpIl6o0Fp
         ZPgyTWKmMGRZYPgFFCAxIk0Q1IQu45omP+pwgamyypH/TCwQWSzSSJf73OQg2LtbZK
         9xLfvhdXXQ7+3pWXagVa5lOVmgWGslqXiusoGQV0=
Date:   Thu, 23 Apr 2020 12:52:02 -0700
From:   akpm@linux-foundation.org
To:     l.stach@pengutronix.de, martin@martingkelly.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  [merged] tools-vm-fix-cross-compile-build.patch removed
 from -mm tree
Message-ID: <20200423195202.eb2XQdOc8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tools/vm: fix cross-compile build
has been removed from the -mm tree.  Its filename was
     tools-vm-fix-cross-compile-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


