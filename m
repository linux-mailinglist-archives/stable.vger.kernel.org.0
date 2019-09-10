Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9176DAF2EA
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 00:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfIJWZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 18:25:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:23481 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfIJWZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 18:25:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="185644850"
Received: from zhanzhiw-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.38.143])
  by fmsmga007.fm.intel.com with ESMTP; 10 Sep 2019 15:25:29 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, linux-integrity@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, Joey Pabalinas <joeypabalinas@gmail.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] selftests/tpm2: Add the missing TEST_FILES assignment
Date:   Tue, 10 Sep 2019 23:25:22 +0100
Message-Id: <20190910222523.8116-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Python files required by the selftests are not packaged because of
the missing assignment to TEST_FILES. Add the assignment.

Cc: stable@vger.kernel.org
Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/tpm2/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tpm2/Makefile b/tools/testing/selftests/tpm2/Makefile
index 9dd848427a7b..bf401f725eef 100644
--- a/tools/testing/selftests/tpm2/Makefile
+++ b/tools/testing/selftests/tpm2/Makefile
@@ -2,3 +2,4 @@
 include ../lib.mk
 
 TEST_PROGS := test_smoke.sh test_space.sh
+TEST_FILES := tpm2.py tpm2_tests.py
-- 
2.20.1

