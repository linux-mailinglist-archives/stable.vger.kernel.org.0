Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C8754168A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376944AbiFGUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377147AbiFGUuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10601F77CB;
        Tue,  7 Jun 2022 11:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54577B8233E;
        Tue,  7 Jun 2022 18:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2678C385A5;
        Tue,  7 Jun 2022 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627193;
        bh=DIdJhrhMDzys4waQkH84mHqeyCx7EgI+hQjsMXPByAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKS484lSYzYwirgdEvDozrB7ZW+xJdJkx7S9zlTNyahXaS1WHN5h1wcauIYUAXb/i
         Ey21zTqUaz/RWwm7hEPOod8B3sMyW3EpZ6BpCoyw3nhJhwpSghK4/TUlxB6Z8eTS5O
         CAAqKD4XAAFfh0vtevSbKWgV6bmXrvT4l/B0cozI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveria <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 601/772] rtla: Minor grammar fix for rtla README
Date:   Tue,  7 Jun 2022 19:03:13 +0200
Message-Id: <20220607165006.651737274@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: John Kacur <jkacur@redhat.com>

[ Upstream commit 22d146f7c1e97f4870e4497c0202939a031f740c ]

- Change to "The rtla meta-tool includes"
- Remove an unnecessary "But, "
- Adjust the formatting of the paragraph resulting from the changes.
- Simplify the wording for the libraries and tools.

Link: https://lkml.kernel.org/r/437f0accdde53713ab3cce46f3564be00487e031.1651247710.git.bristot@kernel.org
Link: https://lore.kernel.org/r/20220408161012.10544-1-jkacur@redhat.com/

Cc: Daniel Bristot de Oliveria <bristot@kernel.org>
Fixes: 79ce8f43ac5a ("rtla: Real-Time Linux Analysis tool")
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/README.txt | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/tracing/rtla/README.txt b/tools/tracing/rtla/README.txt
index 6c88446f7e74..0fbad2640b8c 100644
--- a/tools/tracing/rtla/README.txt
+++ b/tools/tracing/rtla/README.txt
@@ -1,15 +1,13 @@
 RTLA: Real-Time Linux Analysis tools
 
-The rtla is a meta-tool that includes a set of commands that
-aims to analyze the real-time properties of Linux. But, instead of
-testing Linux as a black box, rtla leverages kernel tracing
-capabilities to provide precise information about the properties
-and root causes of unexpected results.
+The rtla meta-tool includes a set of commands that aims to analyze
+the real-time properties of Linux. Instead of testing Linux as a black box,
+rtla leverages kernel tracing capabilities to provide precise information
+about the properties and root causes of unexpected results.
 
 Installing RTLA
 
-RTLA depends on some libraries and tools. More precisely, it depends on the
-following libraries:
+RTLA depends on the following libraries and tools:
 
  - libtracefs
  - libtraceevent
-- 
2.35.1



