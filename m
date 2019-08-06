Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F283CD1
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfHFVdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfHFVdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:33:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8392D217F4;
        Tue,  6 Aug 2019 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127211;
        bh=v6CLPFTPD9bw6DudDkxxB588VZFuwJvTzq5aEVjbx3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlOwvsdSekZrrKRCflNbhecbwHLrux0wJdbKWcj77jtXVUchOWDZQawujpMF1x5up
         5a1vX5HnZSM7BzA99s5qVHPDFfatEApc9mQppodAk7K/dZITgBhBFb3MUC+2pRg8Zn
         zlcCJdfAPZ+aiEGwZ60c4TPHEQFdapEb9YTNO5LE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 09/59] platform/x86: intel_pmc_core: Add ICL-NNPI support to PMC Core
Date:   Tue,  6 Aug 2019 17:32:29 -0400
Message-Id: <20190806213319.19203-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>

[ Upstream commit 66013e8ec6850f9c62df6aea555fe7668e84dc3c ]

Ice Lake Neural Network Processor for deep learning inference a.k.a.
ICL-NNPI can re-use Ice Lake Mobile regmap to enable Intel PMC Core
driver on it.

Cc: Darren Hart <dvhart@infradead.org>
Cc: Andy Shevchenko <andy@infradead.org>
Cc: platform-driver-x86@vger.kernel.org
Link: https://lkml.org/lkml/2019/6/5/1034
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_pmc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel_pmc_core.c b/drivers/platform/x86/intel_pmc_core.c
index 1d902230ba611..be6cda89dcf5b 100644
--- a/drivers/platform/x86/intel_pmc_core.c
+++ b/drivers/platform/x86/intel_pmc_core.c
@@ -815,6 +815,7 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	INTEL_CPU_FAM6(KABYLAKE_DESKTOP, spt_reg_map),
 	INTEL_CPU_FAM6(CANNONLAKE_MOBILE, cnp_reg_map),
 	INTEL_CPU_FAM6(ICELAKE_MOBILE, icl_reg_map),
+	INTEL_CPU_FAM6(ICELAKE_NNPI, icl_reg_map),
 	{}
 };
 
-- 
2.20.1

