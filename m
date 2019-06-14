Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F157469BA
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfFNUaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfFNUaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:11 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20F8F2184E;
        Fri, 14 Jun 2019 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544211;
        bh=y8FjzOdyTg0muEdxU886G2sk4rKHSaiJe14dSNsxpeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KP+7zcDgC0dPo4VcF7enAKv4WkWa9TIPpBpC3i3ze84RivNToYdHCYYUT4RyEwnfr
         M7G2qk6M6W8xIjIeuEom7pBCbxABLtWGonlyHgWSX5arWM7eDynCPMjzF36P7dY3D0
         aO/1wN/Xdt0bbMkjp3JbpGLDex4oOOMvnYuTve58=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/39] selftests: vm: install test_vmalloc.sh for run_vmtests
Date:   Fri, 14 Jun 2019 16:29:25 -0400
Message-Id: <20190614202946.27385-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202946.27385-1-sashal@kernel.org>
References: <20190614202946.27385-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naresh Kamboju <naresh.kamboju@linaro.org>

[ Upstream commit bc2cce3f2ebcae02aa4bb29e3436bf75ee674c32 ]

Add test_vmalloc.sh to TEST_FILES to make sure it gets installed for
run_vmtests.

Fixed below error:
./run_vmtests: line 217: ./test_vmalloc.sh: No such file or directory

Tested with: make TARGETS=vm install INSTALL_PATH=$PWD/x

Signed-off-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index dc68340a6a96..2cf3dc49bd03 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -24,6 +24,8 @@ TEST_GEN_FILES += virtual_address_range
 
 TEST_PROGS := run_vmtests
 
+TEST_FILES := test_vmalloc.sh
+
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
-- 
2.20.1

