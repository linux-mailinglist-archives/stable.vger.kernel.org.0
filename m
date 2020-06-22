Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE033204298
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 23:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgFVVXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 17:23:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:2469 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730460AbgFVVXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 17:23:30 -0400
IronPort-SDR: dpFSCi1544XuAKCIGfSov51p5HubZ1RFSF97AyqncOx3jTg3Mhm3x0Mc1afnj6ftv87YqcasMo
 G96M1rx0B1Eg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="123548596"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="123548596"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:23:29 -0700
IronPort-SDR: YU7fP6RdkdXBthLv3FK4h2DNntPCXOCmcZe053PnGOAcQrgdaPS3xyaH4oySFH+lnqaZBSospj
 70roBrLzBkVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="278894306"
Received: from scheller-mobl.ger.corp.intel.com (HELO localhost) ([10.252.33.117])
  by orsmga006.jf.intel.com with ESMTP; 22 Jun 2020 14:23:25 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Shuah Khan <shuah@kernel.org>
Cc:     pengfei.xu@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Nikita Sobolev <Nikita.Sobolev@synopsys.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        Joey Pabalinas <joeypabalinas@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] selftests: tpm: Use /bin/sh instead of /bin/bash
Date:   Tue, 23 Jun 2020 00:20:22 +0300
Message-Id: <20200622212034.20624-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200622212034.20624-1-jarkko.sakkinen@linux.intel.com>
References: <20200622212034.20624-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It's better to use /bin/sh instead of /bin/bash in order to run the tests
in the BusyBox shell.

Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
Cc: stable@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/tpm2/test_smoke.sh | 2 +-
 tools/testing/selftests/tpm2/test_space.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/tpm2/test_smoke.sh b/tools/testing/selftests/tpm2/test_smoke.sh
index 338d6b0272dc..1334e301d2a0 100755
--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
 # Kselftest framework requirement - SKIP code is 4.
diff --git a/tools/testing/selftests/tpm2/test_space.sh b/tools/testing/selftests/tpm2/test_space.sh
index 847cabb20a5f..00259cb746cf 100755
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
 # Kselftest framework requirement - SKIP code is 4.
-- 
2.25.1

