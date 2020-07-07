Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F54217116
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbgGGPYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgGGPYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B95120853;
        Tue,  7 Jul 2020 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135440;
        bh=20y4Mugg4uM0Zxy27gW+xkoeKE5+EVAkevoG4qqLK3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qb2pCbZbA3o3x6sHsaMyQmd0poSoXzZ2whmuKXPMb9ZTmCsoQ0Bhwwn2TasKLPRjU
         EV7COvI4w2sKyh4ywyIALGD/g4EOGwj9zqiX2SOOT95pGy8xxtjMCA1vNyuEJS+Gox
         bDQH+3y0SprHqJsyP3Kh31XEJeepORDJYcPvLrZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.7 042/112] selftests: tpm: Use /bin/sh instead of /bin/bash
Date:   Tue,  7 Jul 2020 17:16:47 +0200
Message-Id: <20200707145803.000133983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 377ff83083c953dd58c5a030b3c9b5b85d8cc727 upstream.

It's better to use /bin/sh instead of /bin/bash in order to run the tests
in the BusyBox shell.

Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
Cc: stable@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/tpm2/test_smoke.sh |    2 +-
 tools/testing/selftests/tpm2/test_space.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/tpm2/test_smoke.sh
+++ b/tools/testing/selftests/tpm2/test_smoke.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
 python -m unittest -v tpm2_tests.SmokeTest
--- a/tools/testing/selftests/tpm2/test_space.sh
+++ b/tools/testing/selftests/tpm2/test_space.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/bin/sh
 # SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 
 python -m unittest -v tpm2_tests.SpaceTest


