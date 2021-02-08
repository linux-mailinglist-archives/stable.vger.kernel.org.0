Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09726313C31
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhBHSEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:04:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235256AbhBHSAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF25264EB9;
        Mon,  8 Feb 2021 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807111;
        bh=LtxRUfpLwRQQJdBOvkOkAPlbx4qTobni8oVIcD7kdA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/jcIdWPU3n9NEb6BcO2yjffncobY0dF2xjkQynRGVJNDhNiN3jL6SqGHHMv99gYy
         7QcT624P1GUuubUIyQi2yTBKxIKl+Sx3zFxjRFVAyURcUdvd1oiCSGrRSSYc1lACHR
         HIeahW4DHO8+GJQN36zx7F6bwv8zt0O6QSWBiFYx1oadK4/Fzu2oT3kh/YN/zg3mHL
         GbJzH0wxwiQ6dxvAfeatqqtUWUISc7nja3XO1/flwdkdE/+6ukRoHPvBv4ErMlmtEA
         dv2ZAhcpp4JXtSuGpoI50J30H0o+j9mJult2bCXo5HRhLWKTe65+jO794Q4ZrAy9ns
         UM6Vp77AphViA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 18/36] x86/split_lock: Enable the split lock feature on another Alder Lake CPU
Date:   Mon,  8 Feb 2021 12:57:48 -0500
Message-Id: <20210208175806.2091668-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175806.2091668-1-sashal@kernel.org>
References: <20210208175806.2091668-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 8acf417805a5f5c69e9ff66f14cab022c2755161 ]

Add Alder Lake mobile processor to CPU list to enumerate and enable the
split lock feature.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20210201190007.4031869-1-fenghua.yu@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 59a1e3ce3f145..816fdbec795a4 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1159,6 +1159,7 @@ static const struct x86_cpu_id split_lock_cpu_ids[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE,		1),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X,	1),
 	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE,		1),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L,		1),
 	{}
 };
 
-- 
2.27.0

