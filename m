Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58F12C33F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfL2Pz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:55:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58631 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2Pz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:55:28 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 82A4E21D6E;
        Sun, 29 Dec 2019 10:55:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iV+aIu
        p0onh/pn/Cj/sdsGWAkrti9aSm3HItR+t4568=; b=XyoC8CTO2ufvi2MwYtIEjB
        s9veQkK825lQxAZf03ezA0Ta8SzE7LF1wbiu8L/AllK4ZndLBbRxyX5EKBOCn/eK
        mcGL76Jy/3qhQyvNQX15pqoLF8gIbX/eqTqIAnswBRsqzr5dqUJNI+K9J2RfYpjc
        6sr/2U69KYIjFIs1SKUxmc3LvhpSd2j6fkSDMGIhOL5B2C4RHbvlQuPV1E7bO58F
        pHvJBbqjVVIWPW43wUZZseR6u4395r4veHf9ErsN6SS2wgRoNx9h2gmgI7/BwvwL
        w+mqmThYo4h23C7t3YCjyChP9NrmXiYyizN3wLE6DrmCN+O0ewmqwJOI1X0FpLaQ
        ==
X-ME-Sender: <xms:b8wIXoTbVgSUqE4eI4Kqbkw6vo95wB43icc-_RbvUOs_cGenMP6QMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:b8wIXkMsdVU8eDjvLq5gJWSxzYxRmdku4Hzfw4wpuJtIxGgexp0byg>
    <xmx:b8wIXoe6O8DSVlPyjkYSCwa4-ACsAIQS6dsLTCS7drUKXLVx5x2VkA>
    <xmx:b8wIXnXL7JM_nwmwO--V1EVfsQ-uCEJFWQVaa6vKdUxKkRhjtUu9aQ>
    <xmx:b8wIXkVNFj-DTXtMoN87eE-zV-TiykurmTpysMtv1kNSH_x7bV5hbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E4C53060AA8;
        Sun, 29 Dec 2019 10:55:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD" failed to apply to 4.9-stable tree
To:     jschoenh@amazon.de, Yazen.Ghannam@amd.com, bp@suse.de,
        hpa@zytor.com, linux-edac@vger.kernel.org, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        x86@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:55:17 +0100
Message-ID: <1577634917235161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

