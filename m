Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD7311139
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhBERtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233344AbhBEPyd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:54:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419236502C;
        Fri,  5 Feb 2021 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534287;
        bh=Gn6px7AxTK0LfiiaMAPzDSLUDUl4XdQcRx2RH3s/lCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTxb8JV0e586uBEy/KHvgR+1vVVLrhue4fPV7+t4kMg52aGgW+G0RxLMYb/Mf29+b
         Ts0CKdr1KYODX4Ca/Rvv2fi1vHl6aAjtRkBifO3zlZsS0EmWbeGztPLjjHPd2zIfyu
         ulPppd5i/7B4mQwpOpv/zy56SFIxkrKKbXx4Q+DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/57] x86/cpu: Add another Alder Lake CPU to the Intel family
Date:   Fri,  5 Feb 2021 15:07:21 +0100
Message-Id: <20210205140658.346346145@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

[ Upstream commit 6e1239c13953f3c2a76e70031f74ddca9ae57cd3 ]

Add Alder Lake mobile CPU model number to Intel family.

Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210121215004.11618-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5e658ba2654a7..9abe842dbd843 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -97,6 +97,7 @@
 
 #define	INTEL_FAM6_LAKEFIELD		0x8A
 #define INTEL_FAM6_ALDERLAKE		0x97
+#define INTEL_FAM6_ALDERLAKE_L		0x9A
 
 /* "Small Core" Processors (Atom) */
 
-- 
2.27.0



