Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D8C16F8D6
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 08:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBZH6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 02:58:21 -0500
Received: from mga18.intel.com ([134.134.136.126]:23098 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgBZH6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Feb 2020 02:58:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 23:58:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,487,1574150400"; 
   d="scan'208";a="284904722"
Received: from xpf-desktop.sh.intel.com ([10.239.13.107])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Feb 2020 23:58:17 -0800
From:   "Xu, Pengfei" <pengfei.xu@intel.com>
To:     x86@kernel.org, stable@vger.kernel.org,
        Pengfei Xu <pengfei.xu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc:     Xu@vger.kernel.org
Subject: [Linux] [PATCH] selftests/x86: fix trailing whitespace in test_vsyscall.c
Date:   Wed, 26 Feb 2020 16:07:24 +0800
Message-Id: <20200226080724.8834-1-pengfei.xu@intel.com>
X-Mailer: git-send-email 2.14.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is an trailing whitespace mistake in test_vsyscall.c.
Fix it.

Signed-off-by: Xu, Pengfei <pengfei.xu@intel.com>
---
 tools/testing/selftests/x86/test_vsyscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index a4f4d4cf22c3..e8b4a2ab1964 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -210,7 +210,7 @@ static int check_gtod(const struct timeval *tv_sys1,
 	}
 
 	d1 = tv_diff(tv_other, tv_sys1);
-	d2 = tv_diff(tv_sys2, tv_other); 
+	d2 = tv_diff(tv_sys2, tv_other);
 	printf("\t%s time offsets: %lf %lf\n", which, d1, d2);
 
 	if (d1 < 0 || d2 < 0) {
-- 
2.14.1

