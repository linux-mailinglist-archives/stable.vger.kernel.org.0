Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5BCD2330
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbfJJIkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733181AbfJJIkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C45FF21920;
        Thu, 10 Oct 2019 08:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696800;
        bh=nZadMcj7fPoGQcubnVdX3ztsZDaR+rVqTVTDnDv6IP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suGodArxf4QTjeHoTqJYLkmlZJv+BVc/S3zQMvb7G0FnWZXPE1EghuuA1a+zf9fWZ
         j3VAnh//3dQbFA6CUPxg36i4aXeKep7UFHaowcVowj12XI1Py37Zu7YPUdTtrkaqxY
         x+OsToNSjDFn/ulqh5GIETcsEVTHpIQF7H8I98DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Petr Vorel <pvorel@suse.cz>
Subject: [PATCH 5.3 057/148] selftests/tpm2: Add the missing TEST_FILES assignment
Date:   Thu, 10 Oct 2019 10:35:18 +0200
Message-Id: <20191010083614.606686413@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

commit 981c107cbb420ee028f8ecd155352cfd6351c246 upstream.

The Python files required by the selftests are not packaged because of
the missing assignment to TEST_FILES. Add the assignment.

Cc: stable@vger.kernel.org
Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/tpm2/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/tpm2/Makefile
+++ b/tools/testing/selftests/tpm2/Makefile
@@ -2,3 +2,4 @@
 include ../lib.mk
 
 TEST_PROGS := test_smoke.sh test_space.sh
+TEST_FILES := tpm2.py tpm2_tests.py


