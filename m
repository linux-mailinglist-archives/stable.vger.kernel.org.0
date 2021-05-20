Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9003438A588
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhETKRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236476AbhETKPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 343406198F;
        Thu, 20 May 2021 09:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503934;
        bh=vkFFtSBmwEKNYszD+U0WXB2my47SbLhZne37+HJ8phQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE41QeH6kYfkaURSWJl7BGBGY8PhpM7nGMZY0u1C//lXPkPysoW+A8mwtvW56zZKy
         8gLnJSs5M0IQiyDVf5EHJubGUQvz2S7VExJWFpFqFYusDNV9tmXYTTsDrRREm19MQO
         ikn28Zi80sXy38BYdMPOzAJiAn+YhbY94wVuYi7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.14 005/323] bpf: fix up selftests after backports were fixed
Date:   Thu, 20 May 2021 11:18:17 +0200
Message-Id: <20210520092120.308727153@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank van der Linden <fllinden@amazon.com>

After the backport of the changes to fix CVE 2019-7308, the
selftests also need to be fixed up, as was done originally
in mainline 80c9b2fae87b ("bpf: add various test cases to selftests").

4.14 commit 03f11a51a19 ("bpf: Fix selftests are changes for CVE 2019-7308")
did that, but since there was an error in the backport, some
selftests did not change output. So, add them now that this error
has been fixed, and their output has actually changed as expected.

This adds the rest of the changed test outputs from 80c9b2fae87b.

Fixes: 03f11a51a19 ("bpf: Fix selftests are changes for CVE 2019-7308")
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -6207,6 +6207,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6231,6 +6232,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6257,6 +6259,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6282,6 +6285,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R8 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6330,6 +6334,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6401,6 +6406,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6452,6 +6458,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6479,6 +6486,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6505,6 +6513,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6534,6 +6543,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R7 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{
@@ -6592,6 +6602,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "unbounded min value",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 		.result_unpriv = REJECT,
 	},
@@ -6644,6 +6655,7 @@ static struct bpf_test tests[] = {
 		},
 		.fixup_map1 = { 3 },
 		.errstr = "R0 min value is negative, either use unsigned index or do a if (index >=0) check.",
+		.errstr_unpriv = "R1 has unknown scalar with mixed signed bounds",
 		.result = REJECT,
 	},
 	{


