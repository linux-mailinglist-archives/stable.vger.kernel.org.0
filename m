Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB2162CD2D
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 22:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiKPVwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 16:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238611AbiKPVwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 16:52:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCF32253B;
        Wed, 16 Nov 2022 13:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE19ECE1C9D;
        Wed, 16 Nov 2022 21:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0A1C433C1;
        Wed, 16 Nov 2022 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668635448;
        bh=7t0eloWQUZL8YPy8U8mz6w1Mone30q9cZM4TN9c3Kcg=;
        h=Date:To:From:Subject:From;
        b=eRWWn5gADs/9fjLgxWNrmGLsDN6/as8+WXMf5ziGR1MQ9ZsDfeUJPpv0xRU7q3md4
         qsV/YRJAqrC5Atqbrkj//ZX90h9IKT5Vzu+4OcxMi4cctN79xC3zjQqThjOkXPgKrZ
         W4HtGyeLcoZPbD4KIo5EtnKQteYO/9TmF88JIdKI=
Date:   Wed, 16 Nov 2022 13:50:47 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sam@gentoo.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch added to mm-hotfixes-unstable branch
Message-Id: <20221116215047.DE0A1C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sam James <sam@gentoo.org>
Subject: kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
Date: Wed, 16 Nov 2022 18:26:34 +0000

Add missing <string.h> include for strcmp.

Clang 16 makes -Wimplicit-function-declaration an error by default. 
Unfortunately, out of tree modules may use this in configure scripts,
which means failure might cause silent miscompilation or misconfiguration.

For more information, see LWN.net [0] or LLVM's Discourse [1], gentoo-dev@ [2],
or the (new) c-std-porting mailing list [3].

[0] https://lwn.net/Articles/913505/
[1] https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213
[2] https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e6e240
[3] hosted at lists.linux.dev.

Link: https://lkml.kernel.org/r/20221116182634.2823136-1-sam@gentoo.org
Signed-off-by: Sam James <sam@gentoo.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/license.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/license.h~kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible
+++ a/include/linux/license.h
@@ -2,6 +2,8 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
+#include <string.h>
+
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0
_

Patches currently in -mm which might be from sam@gentoo.org are

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

