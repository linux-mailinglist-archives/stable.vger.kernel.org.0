Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186F996150
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbfHTNqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbfHTNmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:42:21 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBA0E2339F;
        Tue, 20 Aug 2019 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308540;
        bh=XLQvMLaa4CApdFhHK4HaqlISLkGZom8MvsfkBRH6x7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tL5tFvjiE9kX6z0YVRC1pCtq9Nq66cQfqNnCBKl5YLut7621IULiT15FF5I50zuYa
         tSu+7h2Ocn90c028lBO23tnPpXGnR948jtOsfYJLOdmSiRcnMHEyaWfhRbaFwuSSuS
         ZbPN7+N0n4GqPvagahwLB1uQGR9G1iIlHN7FG6C4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 07/27] intel_th: Use the correct style for SPDX License Identifier
Date:   Tue, 20 Aug 2019 09:41:53 -0400
Message-Id: <20190820134213.11279-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134213.11279-1-sashal@kernel.org>
References: <20190820134213.11279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>

[ Upstream commit fac7b714c514fcc555541e1d6450c694b0a5f8d3 ]

This patch corrects the SPDX License Identifier style
in header files related to Drivers for Intel(R) Trace Hub
controller.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/msu.h | 2 +-
 drivers/hwtracing/intel_th/pti.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/msu.h b/drivers/hwtracing/intel_th/msu.h
index 9cc8aced6116a..979548791b7db 100644
--- a/drivers/hwtracing/intel_th/msu.h
+++ b/drivers/hwtracing/intel_th/msu.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Intel(R) Trace Hub Memory Storage Unit (MSU) data structures
  *
diff --git a/drivers/hwtracing/intel_th/pti.h b/drivers/hwtracing/intel_th/pti.h
index e9381babc84c3..7dfc0431333b7 100644
--- a/drivers/hwtracing/intel_th/pti.h
+++ b/drivers/hwtracing/intel_th/pti.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Intel(R) Trace Hub PTI output data structures
  *
-- 
2.20.1

