Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7ED11B61B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbfLKP6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730496AbfLKPOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2044224689;
        Wed, 11 Dec 2019 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077255;
        bh=a+n6KNgx3G9rwCcYtxtazuj+4A3mkWZjxOFPQ1YfoLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrSh4QqO0M1lAPwXxnWWP8+WQSIJyUoq2Q1W9BJH8RkkT7BxU8LzRkn1bPKsIk8wb
         8qo/3kISAKpB/xt0TxkvozExagPOonjUID6F/n6IC+qISriV4OtKFeM/O3Fqr3plif
         h2kF28XIw3xmo9WqNp0lwGRercuGJnIpYP+vIWS0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 131/134] selftests: vm: add fragment CONFIG_TEST_VMALLOC
Date:   Wed, 11 Dec 2019 10:11:47 -0500
Message-Id: <20191211151150.19073-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 746dd4012d215b53152f0001a48856e41ea31730 ]

When running test_vmalloc.sh smoke the following print out states that
the fragment is missing.

 # ./test_vmalloc.sh: You must have the following enabled in your kernel:
 # CONFIG_TEST_VMALLOC=m

Rework to add the fragment 'CONFIG_TEST_VMALLOC=m' to the config file.

Link: http://lkml.kernel.org/r/20190916095217.19665-1-anders.roxell@linaro.org
Fixes: a05ef00c9790 ("selftests/vm: add script helper for CONFIG_TEST_VMALLOC_MODULE")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/vm/config b/tools/testing/selftests/vm/config
index 1c0d76cb5adfd..93b90a9b1eebf 100644
--- a/tools/testing/selftests/vm/config
+++ b/tools/testing/selftests/vm/config
@@ -1,2 +1,3 @@
 CONFIG_SYSVIPC=y
 CONFIG_USERFAULTFD=y
+CONFIG_TEST_VMALLOC=m
-- 
2.20.1

