Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07410DD385
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388151AbfJRWSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732932AbfJRWHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420DD2245B;
        Fri, 18 Oct 2019 22:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436451;
        bh=2MwhBruz8QdI3sEGgqpLqqGmZkYq661yl/ZJ1kyxMhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SR5d067kkF4ZJSWZd6TiWn1yEwVnuQhkpXtDIxZpNAvZO2ypYEj1FRF5a8T/D8A2X
         rLDoTk1lwepUDwkwYU1mUbMPmq29+GzXz2FjTT022naCPFzTBSlxU6jxE0dzUCNGX4
         16LRiGWBQc3rwCOKBcPhqR1latDGoGOv+vmyyGDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 085/100] x86/cpu: Add Comet Lake to the Intel CPU models header
Date:   Fri, 18 Oct 2019 18:05:10 -0400
Message-Id: <20191018220525.9042-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 8d7c6ac3b2371eb1cbc9925a88f4d10efff374de ]

Comet Lake is the new 10th Gen Intel processor. Add two new CPU model
numbers to the Intel family list.

The CPU model numbers are not published in the SDM yet but they come
from an authoritative internal source.

 [ bp: Touch up commit message. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: ak@linux.intel.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1570549810-25049-2-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 82a57d344b9bc..2a8e5f78e23c4 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -61,6 +61,9 @@
 #define INTEL_FAM6_TIGERLAKE_L		0x8C
 #define INTEL_FAM6_TIGERLAKE		0x8D
 
+#define INTEL_FAM6_COMETLAKE		0xA5
+#define INTEL_FAM6_COMETLAKE_L		0xA6
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.20.1

