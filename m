Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3852534E7
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHZQ25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgHZQ2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:49 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF9FC061757
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:48 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id u10so703218wrp.3
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LHfpllJunTUfMKFidc/MV08iSyGLSotXc/21SDTzF6s=;
        b=RSLvoOATp/ovUC+Lxmu/zridwfnbtxW+mR8KrlBueYegr+97YFVuj39rWmvdYAAs+z
         QpFkdf2N04I8asggCEuZ/oykvZ2FPJVEWUDjWQ+h2ASEBGOH/gZf3logHPRNY8/fBSMh
         ByPFDM69yB08o93cGxFUTDgo3MAQ4jPu6Zr+5wCEcIIVmL+nS8CTTNsp3fXSgCwUtUph
         jDM6LBEtvFtDyIPjaQnGW7VfjqfT+GRgHi9XMIIHjQE++9XA3k6QAD0zj7uHmNpmzGDd
         QF6ZcRxL+Mjxxy61ERrDF6XmQ2TRf8/QQIM/THulJDOIDUmg7zOsDnOl7D7BpnsSw3+X
         qCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LHfpllJunTUfMKFidc/MV08iSyGLSotXc/21SDTzF6s=;
        b=B2yxINSmhFMtcsfcNx4rfDiESZ533hnSB/5bVJ784lgHH9lVBwjJPpHzMmkEtmyZoR
         nHv1BDh2+7V1mhYCn1Jm1ii/z7UVmfIMZHx9uggTBWC7VK6wn6h1CkE0qKfLEgY9nVxE
         1+6E7WYiLRcjk/FrSDTm6hOCCccqrUYhj+MJLI1OwUZc439sRqR4oUp+B9ZUIJDoOGub
         CbZ4GeKcOAV5bOMS6eEvLf5xJUYsUjXu5adWuGN5ACKeQ6yRcyahsWHAbhoObH9zdzIn
         24jdv1SYag7154Gf4dx2otrZws6Zq+F3ylMXNbPS8vYf02S60OGVeJYxOFdtJd0uLngp
         8CJw==
X-Gm-Message-State: AOAM533BvWRewm/AmQnqn9rijJvnkKTzmrvVlk+IXWSG3IknJTh0Yrv8
        E8wOshBTtb+YJDJe/NtstpAIF5o7FGX7mZljIeJQKXyBy1/t6jNlaQEnjIAHqccjwUwOtiTeaAB
        7fdewg3XbDpMdsilR1+sa1lifmGJ0c7KrrVFKyEhY5PdEz/Ak0T1YdcudH8Z27F8lXpw=
X-Google-Smtp-Source: ABdhPJyQeWby9ZzrxlopFj7ElObyE57OnTniCVQ6DoILGcAYmseeSs/kk62/M/PyaoJGJJha23GUHk60JfRrsQ==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:adf:de8d:: with SMTP id
 w13mr15948143wrl.129.1598459326188; Wed, 26 Aug 2020 09:28:46 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:27 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-6-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 5/6] kheaders: explain why include/config/autoconf.h is
 excluded from md5sum
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

This comment block explains why include/generated/compile.h is omitted,
but nothing about include/generated/autoconf.h, which might be more
difficult to understand. Add more comments.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
(cherry picked from commit f276031b4e2f4c961ed6d8a42f0f0124ccac2e09)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/gen_kheaders.sh | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index dc5744b93f8c..e13ca842eb7e 100755
--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -32,8 +32,15 @@ fi
 all_dirs="$all_dirs $dir_list"
 
 # include/generated/compile.h is ignored because it is touched even when none
-# of the source files changed. This causes pointless regeneration, so let us
-# ignore them for md5 calculation.
+# of the source files changed.
+#
+# When Kconfig regenerates include/generated/autoconf.h, its timestamp is
+# updated, but the contents might be still the same. When any CONFIG option is
+# changed, Kconfig touches the corresponding timestamp file include/config/*.h.
+# Hence, the md5sum detects the configuration change anyway. We do not need to
+# check include/generated/autoconf.h explicitly.
+#
+# Ignore them for md5 calculation to avoid pointless regeneration.
 headers_md5="$(find $all_dirs -name "*.h"			|
 		grep -v "include/generated/compile.h"	|
 		grep -v "include/generated/autoconf.h"	|
-- 
2.28.0.297.g1956fa8f8d-goog

