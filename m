Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC369EEC78
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfKDV5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387818AbfKDV5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:19 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6719D2184C;
        Mon,  4 Nov 2019 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904639;
        bh=8h+FkDc3xXvETtsrZrbsTH8LmB+VdeBjN9RyUmQkvEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imenMDP9BHo9/Tg+KjECk4+XhNY6Fp3iqmyBGShcm27zUwIVvgkH7pDq14qtBAMj8
         TMZC33MP6HxdvffAbZ/UdzEaq0CZE7m9YypEUjw2Wo+ERlE6fqAFfBlfR05DEKGJk5
         SeapVj99j+r8DjdgkygLfFIrDDM3pNa/WK7xVwxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Aristeu Rozanski <aris@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/149] x86/cpu: Add Atom Tremont (Jacobsville)
Date:   Mon,  4 Nov 2019 22:43:31 +0100
Message-Id: <20191104212136.034136452@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 00ae831dfe4474ef6029558f5eb3ef0332d80043 ]

Add the Atom Tremont model number to the Intel family list.

[ Tony: Also update comment at head of file to say "_X" suffix is
  also used for microserver parts. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Megha Dey <megha.dey@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190125195902.17109-4-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5d0b72f281402..82a57d344b9bc 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -6,7 +6,7 @@
  * "Big Core" Processors (Branded as Core, Xeon, etc...)
  *
  * The "_X" parts are generally the EP and EX Xeons, or the
- * "Extreme" ones, like Broadwell-E.
+ * "Extreme" ones, like Broadwell-E, or Atom microserver.
  *
  * While adding a new CPUID for a new microarchitecture, add a new
  * group to keep logically sorted out in chronological order. Within
@@ -80,6 +80,7 @@
 #define INTEL_FAM6_ATOM_GOLDMONT	0x5C /* Apollo Lake */
 #define INTEL_FAM6_ATOM_GOLDMONT_X	0x5F /* Denverton */
 #define INTEL_FAM6_ATOM_GOLDMONT_PLUS	0x7A /* Gemini Lake */
+#define INTEL_FAM6_ATOM_TREMONT_X	0x86 /* Jacobsville */
 
 /* Xeon Phi */
 
-- 
2.20.1



