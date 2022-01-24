Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C955499C90
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579613AbiAXWGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458063AbiAXVzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF1DC061779;
        Mon, 24 Jan 2022 12:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E86A61545;
        Mon, 24 Jan 2022 20:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84326C340E5;
        Mon, 24 Jan 2022 20:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056625;
        bh=NsNmxlzJcp4bHdt1JVI79chzoIVKauwC5RQte6uzHu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DYmM2gthlkn9/ZFfrqu8sPX9My9/eH0YPvQ/bUTvsTYLd+2YvYD9BYYBZmzbYXWW7
         PT3QLj2DBCqdAmLD229rFShWnEpWlV2OLnDX7TSjuwu/0HnW0ZJ6qjgq4tqkFQLGrU
         O+eaKy9cbyJzTc06+YooV8g18TjhhjX/PjMPRaFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 539/846] selftests/ftrace: make kprobe profile testcase description unique
Date:   Mon, 24 Jan 2022 19:40:56 +0100
Message-Id: <20220124184119.593749627@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit e5992f373c6eed6d09e5858e9623df1259b3ce30 ]

Commit 32f6e5da83c7 ("selftests/ftrace: Add kprobe profile testcase")
added a new kprobes testcase, but has a description which does not
describe what the test case is doing and is duplicating the description
of another test case.

Therefore change the test case description, so it is unique and then
allows easily to tell which test case actually passed or failed.

Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/profile.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc b/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
index 98166fa3eb91c..34fb89b0c61fa 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/profile.tc
@@ -1,6 +1,6 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
-# description: Kprobe dynamic event - adding and removing
+# description: Kprobe profile
 # requires: kprobe_events
 
 ! grep -q 'myevent' kprobe_profile
-- 
2.34.1



