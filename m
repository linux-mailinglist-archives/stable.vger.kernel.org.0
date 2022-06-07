Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A14541A0D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379072AbiFGV1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379146AbiFGVZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31C7151FC1;
        Tue,  7 Jun 2022 12:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E52617CC;
        Tue,  7 Jun 2022 19:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43F7C385A5;
        Tue,  7 Jun 2022 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628501;
        bh=7Oi7c7ERhq7qN2Ka0vo7GkEF09sRa/TAobOsEbe99pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEzsfrSjbxi2HMSFiDCtzAP5789tj6+rMXZmoCyuHPLwQQahea0CL23NslpgnZX7n
         nfO26kvBbkAJgI6XWOflai8pu8p8VzpTo8V2FwvGMktyY5m8wpEzXrhv1zxc4EtOpk
         Whw/unKfUv80ikvhKLSgpBEbqsXuWqOh07wuyHmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        Yuanchu Xie <yuanchu@google.com>,
        David Rientjes <rientjes@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 352/879] selftests/damon: add damon to selftests root Makefile
Date:   Tue,  7 Jun 2022 18:57:50 +0200
Message-Id: <20220607165013.078194263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 2319ec87f53d..bd2ac8b3bf1f 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += clone3
 TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += damon
 TARGETS += drivers/dma-buf
 TARGETS += efivarfs
 TARGETS += exec
-- 
2.35.1



