Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF1B830A
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 22:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbfISU6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 16:58:53 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46160 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732070AbfISU6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 16:58:53 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8BB3AC0390;
        Thu, 19 Sep 2019 20:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568926732; bh=J0zJEzcfcFgRLmj4dqXRUat6VykPyyAFuhXeW0Xenrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9xORNl3iGWQcAGN/9HG47iPi+tLpK0V2e22IDvnktz2Eu6tO/+iCxge/5xvi9/+i
         tdPdhLUrjwttWtgxTFoLO/E/EFodq/hAJ1uKE78kCBlApPs1pGDhUs5oH+itFPW7uV
         B/eb5bQfxDAmeVsQ1Z5nOpTHulBwvdUmJNdCtCe1obngKnlnX4cPFvRNec0PRN6jDr
         fUnnFt4pepoqhp+omX39Uk3ujB64Qti/zwLaw2pTWszLJk4wOMZU5ZSzw15957WvsD
         GHR7k0R7ZVb70BH7FLP4U66oAkFbKjR0WuYRmKncTh2el3z3OG1J6G+92tXgYA6fuW
         FBMW5AyZ89CYA==
Received: from vineetg-Latitude-E7450.internal.synopsys.com (unknown [10.13.182.230])
        by mailhost.synopsys.com (Postfix) with ESMTP id 572FAA0065;
        Thu, 19 Sep 2019 20:58:51 +0000 (UTC)
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-snps-arc@lists.infradead.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        kbuild test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: [PATCH] ARC: export "abort" for modules
Date:   Thu, 19 Sep 2019 13:58:47 -0700
Message-Id: <20190919205847.4806-1-vgupta@synopsys.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190919105432.GA2809200@kroah.com>
References: <20190919105432.GA2809200@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a custom patch (no mainline equivalent) for stable backport only
to address 0-Day kernel test infra ARC 4.x.y builds errors.

The reason for this custom patch as that it is a single patch, touches
only ARC, vs. atleast two 7c2c11b208be09c1, dc8635b78cd8669 which touch
atleast 3 other arches (one long removed) and could potentially have a
fallout.

Reported-by: kbuild test robot <lkp@intel.com>
CC: stable@vger.kernel.org	# 4.4, 4.9
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/traps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/kernel/traps.c b/arch/arc/kernel/traps.c
index 2fb0cd39a31c..cd6e3615e3d1 100644
--- a/arch/arc/kernel/traps.c
+++ b/arch/arc/kernel/traps.c
@@ -163,3 +163,4 @@ void abort(void)
 {
 	__asm__ __volatile__("trap_s  5\n");
 }
+EXPORT_SYMBOL(abort);
-- 
2.20.1

