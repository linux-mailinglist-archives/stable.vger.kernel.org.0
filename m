Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1445931BCE0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhBOPg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhBOPfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BB3364EC7;
        Mon, 15 Feb 2021 15:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403105;
        bh=LtxRUfpLwRQQJdBOvkOkAPlbx4qTobni8oVIcD7kdA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppdRvsrT7eGD49Vt2GMYHbGQ0J7KV9XOF2vq0nhxQWeAJRUb2izIFasxg/cyJNzOL
         EsVvPvchsaNKufe0Tj1mVyH8N8qsqcIIJwgJjac0mR0/53JX2ckrmwR4N90AB3L+A6
         cOfdtW8oRdMCG1Fytkn440ISjUIbgboXr4wMygHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/104] x86/split_lock: Enable the split lock feature on another Alder Lake CPU
Date:   Mon, 15 Feb 2021 16:26:42 +0100
Message-Id: <20210215152720.427102627@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



