Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24385634E0D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 03:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiKWCxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 21:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiKWCxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 21:53:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E5F8DA42;
        Tue, 22 Nov 2022 18:53:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A865B61886;
        Wed, 23 Nov 2022 02:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087CAC433C1;
        Wed, 23 Nov 2022 02:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171999;
        bh=CEl+erU3B4NFZ+GlrjpjKVixJ09CXc80bUITZRJy/qs=;
        h=Date:To:From:Subject:From;
        b=iN5/D0XYRF8mp8n4MrsaJZ1HtOSoqaM/O6G42YNfVxWFVgFTJJxlmy+se32paNXYf
         zj7Y1Fuy8oeoahgiGbJQPqb4NZIFH9Ec0ZUlMnYS9gK3sVCpca9A1zYYDhW9t3ItUc
         bjHutyxCqpc3HSILBwEyiPL5ShzjkhHkT2nZwVHM=
Date:   Tue, 22 Nov 2022 18:53:18 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sam@gentoo.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch removed from -mm tree
Message-Id: <20221123025319.087CAC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
has been removed from the -mm tree.  Its filename was
     kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sam James <sam@gentoo.org>
Subject: kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
Date: Wed, 16 Nov 2022 18:26:34 +0000

Add missing <linux/string.h> include for strcmp.

Clang 16 makes -Wimplicit-function-declaration an error by default. 
Unfortunately, out of tree modules may use this in configure scripts,
which means failure might cause silent miscompilation or misconfiguration.

For more information, see LWN.net [0] or LLVM's Discourse [1], gentoo-dev@ [2],
or the (new) c-std-porting mailing list [3].

[0] https://lwn.net/Articles/913505/
[1] https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213
[2] https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e6e240
[3] hosted at lists.linux.dev.

[akpm@linux-foundation.org: remember "linux/"]
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
 
+#include <linux/string.h>
+
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0
_

Patches currently in -mm which might be from sam@gentoo.org are


