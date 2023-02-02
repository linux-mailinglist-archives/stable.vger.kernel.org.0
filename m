Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6EA687532
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 06:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjBBF3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 00:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjBBF20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 00:28:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1236A298E0;
        Wed,  1 Feb 2023 21:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ABBBB824B4;
        Thu,  2 Feb 2023 05:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7FBC4339E;
        Thu,  2 Feb 2023 05:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675315690;
        bh=jO10o07RAKyXXgWsy3XBxX0WTtST48LzT0RY2uOU2ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJYbG6MzdPYF9ZY0ifhKKBtcGhNXI2gHdLLRsG6lZ7zYJTR7u1LSKcuhBEFoqyKcH
         p+BWD8sd/qQCJafibLWpr3F2wISNeLXhmvZySVrFSeBE+E7vGRYalDN1K6RbWFla21
         DuphVx+RBCz5e1eYPEKmJTZNeABF1nEtwyP0ZajQQ6zRO95PiGcpU+heUpFCN42LF7
         Tqy+hGnTPvn3FeuIjxEW5DYJFzwNDYyosw+Wz//a62eWcsI0kugaBUw4VfUKw6nH+s
         jwBwYIVlCN8SUAvFxf8HkV1OOn8hTsvylv6Qdbi/B8a7l++NTQ7Pc5/3gDSs4oaokG
         UZVWTdlP5qJmA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 4.19 15/16] docs: Fix path paste-o for /sys/kernel/warn_count
Date:   Wed,  1 Feb 2023 21:26:03 -0800
Message-Id: <20230202052604.179184-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202052604.179184-1-ebiggers@kernel.org>
References: <20230202052604.179184-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 00dd027f721e0458418f7750d8a5a664ed3e5994 upstream.

Running "make htmldocs" shows that "/sys/kernel/oops_count" was
duplicated. This should have been "warn_count":

  Warning: /sys/kernel/oops_count is defined 2 times:
  ./Documentation/ABI/testing/sysfs-kernel-warn_count:0
  ./Documentation/ABI/testing/sysfs-kernel-oops_count:0

Fix the typo.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-doc/202212110529.A3Qav8aR-lkp@intel.com
Fixes: 8b05aa263361 ("panic: Expose "warn_count" to sysfs")
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ABI/testing/sysfs-kernel-warn_count | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-warn_count b/Documentation/ABI/testing/sysfs-kernel-warn_count
index 08f083d2fd51b..90a029813717d 100644
--- a/Documentation/ABI/testing/sysfs-kernel-warn_count
+++ b/Documentation/ABI/testing/sysfs-kernel-warn_count
@@ -1,4 +1,4 @@
-What:		/sys/kernel/oops_count
+What:		/sys/kernel/warn_count
 Date:		November 2022
 KernelVersion:	6.2.0
 Contact:	Linux Kernel Hardening List <linux-hardening@vger.kernel.org>
-- 
2.39.1

