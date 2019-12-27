Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F9312B842
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfL0Ryo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbfL0Rmd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D33C2222C3;
        Fri, 27 Dec 2019 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468552;
        bh=tNIxl4x5EyhwWirr1G7H/6k1XgznDwSrGldniwcZWT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjVmLdNEmgq6rPBNrDqKD9o6s/b8tTjF9Okz+pWy1JDCbXnib65Q+oXus0au38TZn
         Uploc58MSbu6xx/EBrdehCpGV27EWr/b1XnkAOsk+kJTFf/jzt9KVYKXrEw9UrPhry
         tBnszVb6s2IqDGq7//SaZ8+FJavvR/t+f+NF5W84=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     SeongJae Park <sjpark@amazon.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 079/187] kselftest: Support old perl versions
Date:   Fri, 27 Dec 2019 12:39:07 -0500
Message-Id: <20191227174055.4923-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

[ Upstream commit 4eac734486fd431e0756cc5e929f140911a36a53 ]

On an old perl such as v5.10.1, `kselftest/prefix.pl` gives below error
message:

    Can't locate object method "autoflush" via package "IO::Handle" at kselftest/prefix.pl line 10.

This commit fixes the error by explicitly specifying the use of the
`IO::Handle` package.

Signed-off-by: SeongJae Park <sjpark@amazon.de>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/prefix.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kselftest/prefix.pl b/tools/testing/selftests/kselftest/prefix.pl
index ec7e48118183..31f7c2a0a8bd 100755
--- a/tools/testing/selftests/kselftest/prefix.pl
+++ b/tools/testing/selftests/kselftest/prefix.pl
@@ -3,6 +3,7 @@
 # Prefix all lines with "# ", unbuffered. Command being piped in may need
 # to have unbuffering forced with "stdbuf -i0 -o0 -e0 $cmd".
 use strict;
+use IO::Handle;
 
 binmode STDIN;
 binmode STDOUT;
-- 
2.20.1

