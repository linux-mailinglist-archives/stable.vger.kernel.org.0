Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC02534E5
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgHZQ24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgHZQ2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:45 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6F0C061756
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:45 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id p23so967198wmc.2
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ktgwgtEcDnGHDubc6AjOIa3QJevlYyX2Xfy7+GppRf0=;
        b=pR+ftzKgbzQBiJkPHA17spJ9YB2ynvQyURBHLX2DqwfOyvhUW9KBer14jJHl6NwdD2
         F2x7plHLT0OQFzWU1eDIb2X5YpzBvRFVKIA00mEW2IxnWg6wgvQhFzH46kS6zTaLL0KY
         qxXesZTHhQWZj5QrqQrFuqyInw4nqDbhXrf4sWNIUrY+d9HdkKyVKxGBvrslX8wqobV2
         xZN1hth76CVuh+mxaKC+ec6iCCoLIq9YpHX/XqTP3BJBeSQ+aoDZ0q4iP9Z4VF8kSSpX
         z1BSVNWYTD8STbaHVkK+yjaMaFcRarJ4+iw6F/2U06DYjPXwTJk8es0dTZnruwPXkbQI
         NOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ktgwgtEcDnGHDubc6AjOIa3QJevlYyX2Xfy7+GppRf0=;
        b=opBZrwrbV4DuLwR8Vp9/CAvoGGKWoz8iDnoJqOay+6ivjSCaQeej3cWRMTdU8hmPyK
         +u4ycN84rBwdH6KGhG38UstWTayTfCH2FhAZvCdDrQRh5PuBGBsrSKnRMnnJQsP7t7JB
         3zKwCgwpS3tKIW6uppK/gbsrzYJnbo6Kwae2wQNeQd68RoYBJkSTDCqLrZ8nNBcIbQTM
         i4kTefIGfYhYm/owBFtbhUCYMiHBUHnzCR5ES3mIYfMBYGLusWAvi+LwRCFuKXCAaf20
         29CTg7ujAqEakXVbIHPKgzfBkSmuVyX/jOGTv4zD8hv6lIPDmPPOY5z7lCEKXvdtauFE
         GuMQ==
X-Gm-Message-State: AOAM532GCdBB0YQQjVZAsLTnioF1Ol5O1guC1RQm25ZDxkxStHuS2HHf
        IYdQ+ML8pBZM5+cTHRlCo30f46HGBksX7JQEMmPn1z00evEgrdSD2Oo8IzqOi9x/LMLngCOwaAi
        1vlne6q7JVT5pMdC9m2EAR+4zsEdgviaRBMtSZb8Pd2sNjwVqychnCgGknQRSJeLny7I=
X-Google-Smtp-Source: ABdhPJyURleKkvyYNZ5T3/ot4msLuzD0r2TgY2KngOdo/atyENDLT9vCW73c4CrCNH++0dEcztaiN0gQKZuGwg==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:a5d:540f:: with SMTP id
 g15mr8472392wrv.130.1598459324001; Wed, 26 Aug 2020 09:28:44 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:26 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-5-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 4/6] kheaders: remove the last bashism to allow sh to run it
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

'pushd' ... 'popd' is the last bash-specific code in this script.
One way to avoid it is to run the code in a sub-shell.

With that addressed, you can run this script with sh.

I replaced $(BASH) with $(CONFIG_SHELL), and I changed the hashbang
to #!/bin/sh.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
(cherry picked from commit 1463f74f492eea7191f0178e01f3d38371a48210)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/Makefile        |  2 +-
 kernel/gen_kheaders.sh | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index daad787fb795..42557f251fea 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -128,7 +128,7 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 $(obj)/kheaders.o: $(obj)/kheaders_data.tar.xz
 
 quiet_cmd_genikh = CHK     $(obj)/kheaders_data.tar.xz
-      cmd_genikh = $(BASH) $(srctree)/kernel/gen_kheaders.sh $@
+      cmd_genikh = $(CONFIG_SHELL) $(srctree)/kernel/gen_kheaders.sh $@
 $(obj)/kheaders_data.tar.xz: FORCE
 	$(call cmd,genikh)
 
diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index 0f7752dd93a6..dc5744b93f8c 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
 # This script generates an archive consisting of kernel headers
@@ -57,11 +57,12 @@ rm -rf $cpio_dir
 mkdir $cpio_dir
 
 if [ "$building_out_of_srctree" ]; then
-	pushd $srctree > /dev/null
-	for f in $dir_list
-		do find "$f" -name "*.h";
-	done | cpio --quiet -pd $cpio_dir
-	popd > /dev/null
+	(
+		cd $srctree
+		for f in $dir_list
+			do find "$f" -name "*.h";
+		done | cpio --quiet -pd $cpio_dir
+	)
 fi
 
 # The second CPIO can complain if files already exist which can happen with out
-- 
2.28.0.297.g1956fa8f8d-goog

