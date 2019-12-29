Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6B512C33D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfL2Pz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:55:26 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52733 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:55:26 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EBF621D51;
        Sun, 29 Dec 2019 10:55:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=wjMf0V
        Or/fnAXTtPZLfSZaQ0ctXH1IQYJ9ANj8o4Ye0=; b=S6jlPYHDKeLfQaDabl1fm/
        7/0RFa1a2BczF9PQZJkcpWDc6hwHtJXK/AaKWAFSiXZtT0WikGykgnxeg7znp3BY
        kHEp/olJEiRQJDG3BGxUB8oK3j0NIbW8hQT/TKrtgvOVm1WLt8oIfXpAppj2me9A
        43zIHXIv0/sAV3Qp3Ft8gvfNbfN5jIw2zEJuRBWuifF0D3J30+C4ZF+hc2Re03u5
        +4kpDLVDOtUyacaDxBc4XMLkgfWlRML8JGu4oR6730t0Bmt0SDHZM1PrDm4udMyZ
        qgSBhOvqWDLbIACNXnRdb+apnZKuc1HEPnMpUQLrQF9mQGxUOtaJCDWBo+eQecuw
        ==
X-ME-Sender: <xms:bcwIXjr44D9mjPNY6O0zO8SZSNKE-M5XzzuQ_6Qx0OJX7nr1faXm0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:bswIXnZkkBLvfLVlUuAh5mRaoOxLcaVAajuKJS-YmctadY8qRJ9f4g>
    <xmx:bswIXtK9VijIacIOdCZnml7IqaI-T8XL8ktccShs81vC1-5CLPO25Q>
    <xmx:bswIXn17QU_eDtfBYTBKFbqpRIRvnFAFn5Se1_A0l1Foj8NyKkYZyA>
    <xmx:bswIXmDYV1W5c6k9yYxQEQ2R1tWbnkxkyMVYoipshg9ZazYyr3R4RA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6B453060AAA;
        Sun, 29 Dec 2019 10:55:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD" failed to apply to 4.14-stable tree
To:     jschoenh@amazon.de, Yazen.Ghannam@amd.com, bp@suse.de,
        hpa@zytor.com, linux-edac@vger.kernel.org, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        x86@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:55:16 +0100
Message-ID: <157763491610201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3a57ddad061acc90bef39635caf2b2330ce8f21 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Date: Tue, 10 Dec 2019 01:07:30 +0100
Subject: [PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The function mce_severity_amd_smca() requires m->bank to be initialized
for correct operation. Fix the one case, where mce_severity() is called
without doing so.

Fixes: 6bda529ec42e ("x86/mce: Grade uncorrected errors for SMCA-enabled systems")
Fixes: d28af26faa0b ("x86/MCE: Initialize mce.bank in the case of a fatal error in mce_no_way_out()")
Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>
Link: https://lkml.kernel.org/r/20191210000733.17979-4-jschoenh@amazon.de

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5f42f25bac8f..2e2a421c8528 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -819,8 +819,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 		if (quirk_no_way_out)
 			quirk_no_way_out(i, m, regs);
 
+		m->bank = i;
 		if (mce_severity(m, mca_cfg.tolerant, &tmp, true) >= MCE_PANIC_SEVERITY) {
-			m->bank = i;
 			mce_read_aux(m, i);
 			*msg = tmp;
 			return 1;

