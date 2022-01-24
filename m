Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8CA499954
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455003AbiAXVeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376793AbiAXVZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:25:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6613961469;
        Mon, 24 Jan 2022 21:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E1C340E4;
        Mon, 24 Jan 2022 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059497;
        bh=NsNmxlzJcp4bHdt1JVI79chzoIVKauwC5RQte6uzHu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfETxqB4EkckEr6KgubzH4oOV2JDEYGuSE1mDs4hDozpoJHiNLomr+NQdTXaUN9hz
         YM5H3WAwwXR29AT2juotLcwA004u0bQHBsLDaPZEpHmWDM3Fzd6wHASuBZ3iyMdAOj
         +Zx1DPnauuScXjLHPJGOeU0HmwqI3hYVTMTbWRNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0636/1039] selftests/ftrace: make kprobe profile testcase description unique
Date:   Mon, 24 Jan 2022 19:40:25 +0100
Message-Id: <20220124184146.724019608@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



