Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7D073C37
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388571AbfGXUHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392474AbfGXUEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:04:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8947F21855;
        Wed, 24 Jul 2019 20:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998654;
        bh=JQKSJ1jhwu21v74Y60lwYJZUJ6awPSfOEu+ZXl0FSWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc8z/fGvWUFXiacqNEa1f5XieIsYxA5iEvseuaySLBukPPyXMs5FOpN+VzmuMcInY
         bVlqajzrbdg7yfqqmRTZKrTPFlE9s5KHDltLBg8uJ8nJZameiRRNf/Aad85hYbPQNg
         H7t8yqbx0pwvem8Ph1E62N6nkbZ+lKL+hS1Icfn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, bp@suse.de,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/271] x86/cpu: Add Ice Lake NNPI to Intel family
Date:   Wed, 24 Jul 2019 21:18:56 +0200
Message-Id: <20190724191700.928300974@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e32d045cd4ba06b59878323e434bad010e78e658 ]

Add the CPUID model number of Ice Lake Neural Network Processor for Deep
Learning Inference (ICL-NNPI) to the Intel family list. Ice Lake NNPI uses
model number 0x9D and this will be documented in a future version of Intel
Software Development Manual.

Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@suse.de
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Linux PM <linux-pm@vger.kernel.org>
Link: https://lkml.kernel.org/r/20190606012419.13250-1-rajneesh.bhardwaj@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 2e38fb82b91d..aebedbaf5260 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -56,6 +56,7 @@
 #define INTEL_FAM6_ICELAKE_XEON_D	0x6C
 #define INTEL_FAM6_ICELAKE_DESKTOP	0x7D
 #define INTEL_FAM6_ICELAKE_MOBILE	0x7E
+#define INTEL_FAM6_ICELAKE_NNPI		0x9D
 
 /* "Small Core" Processors (Atom) */
 
-- 
2.20.1



