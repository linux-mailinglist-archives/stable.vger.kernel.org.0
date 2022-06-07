Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9903F540B52
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237836AbiFGS2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352086AbiFGSQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DE9133932;
        Tue,  7 Jun 2022 10:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 46D51CE21CD;
        Tue,  7 Jun 2022 17:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212E1C385A5;
        Tue,  7 Jun 2022 17:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624222;
        bh=2R1mQvAJ3EHxKA7Z2wDfWH5G/0RmduuCe6zF8RkqES4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9An50rywmhPLOZj7QfmKbYAumG8ZdKsxVSkYxkOSsYw5yr34VdZHBJK5tZ493BNV
         eMwr6RI/f/iufdue05K1qKpf+6Jw3GmjWf7OqdKvc52qnRnRn0w1nrr1SUmCzEysY1
         Dt9Z4G2dixHk00RH0jxdoCvrzHrEZj5lc0noiD1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Yuanchu Xie <yuanchu@google.com>,
        David Rientjes <rientjes@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/667] selftests/damon: add damon to selftests root Makefile
Date:   Tue,  7 Jun 2022 18:58:33 +0200
Message-Id: <20220607164942.223235036@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuanchu Xie <yuanchu@google.com>

[ Upstream commit 678f0cdc572c5fda940cb038d70eebb8d818adc8 ]

Currently the damon selftests are not built with the rest of the
selftests. We add damon to the list of targets.

Fixes: b348eb7abd09 ("mm/damon: add user space selftests")
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c852eb40c4f7..14206d1d1efe 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -8,6 +8,7 @@ TARGETS += clone3
 TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += efivarfs
 TARGETS += exec
-- 
2.35.1



