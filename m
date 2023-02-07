Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B651B68D759
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 13:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjBGM67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 07:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjBGM66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 07:58:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8C121A2E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 04:58:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC47FB8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 12:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0962DC4339B;
        Tue,  7 Feb 2023 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774735;
        bh=wXGwYkvpdBUu194YdF296ECcm5lErTVFBmIuJRS2o7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWscCdlPeOetimZnRn6PFJgMOreh9wnhbdErQ5CwoW0uVj84F4+MMw2BSiDW/cAoC
         Y5YI21S7+k+XLKUT8InZl3lR1MBz8maBTZhEfMw0EMjfOHUO1B5wuqpF7l82Mm6dfS
         yXokya39aSxtZj+aPYQROStWv/j8NNkuCQoPIvk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/208] selftests/filesystems: grant executable permission to run_fat_tests.sh
Date:   Tue,  7 Feb 2023 13:54:31 +0100
Message-Id: <20230207125635.103100289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pengfei Xu <pengfei.xu@intel.com>

[ Upstream commit 24b5308cf5ee9f52dd22f3af78a5b0cdc9d35e72 ]

When use tools/testing/selftests/kselftest_install.sh to make the
kselftest-list.txt under tools/testing/selftests/kselftest_install.

Then use tools/testing/selftests/kselftest_install/run_kselftest.sh to run
all the kselftests in kselftest-list.txt, it will be blocked by case
"filesystems/fat: run_fat_tests.sh" with "Warning: file run_fat_tests.sh
is not executable", so grant executable permission to run_fat_tests.sh to
fix this issue.

Link: https://lkml.kernel.org/r/dfdbba6df8a1ab34bb1e81cd8bd7ca3f9ed5c369.1673424747.git.pengfei.xu@intel.com
Fixes: dd7c9be330d8 ("selftests/filesystems: add a vfat RENAME_EXCHANGE test")
Signed-off-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/filesystems/fat/run_fat_tests.sh | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 tools/testing/selftests/filesystems/fat/run_fat_tests.sh

diff --git a/tools/testing/selftests/filesystems/fat/run_fat_tests.sh b/tools/testing/selftests/filesystems/fat/run_fat_tests.sh
old mode 100644
new mode 100755
-- 
2.39.0



