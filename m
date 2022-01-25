Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F93549BAC8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348886AbiAYR5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385267AbiAYRzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:55:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0541C061753;
        Tue, 25 Jan 2022 09:55:36 -0800 (PST)
Date:   Tue, 25 Jan 2022 17:55:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643133334;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDyWzT40y6W7zz1MmiwXNMh+3a0HubyZ5kxWop7Bb1o=;
        b=t5ohNN3ixcVkB53gYEyFF0Mg4UaL6z5v9wt3lW+p0XbZ5x0/Z9vJ2BAOUkzXl/LzcB3JRk
        uNYqMQcmwRHmzn7T0U0conMen7a2qTFxLTgE0PLbNGKfYlnckQbwx/Rtbnn+hd96U7/K6V
        CogTZ82bDfGOyTmeCRy7D99Vp7o5eIw5BdPrp17LN6lG7Fw3AuVJTIc4pRhyu0gPNmIx1q
        /dcUUZ4SNCV2qKZisUBR99vvt74mqXqVKSVjAP2ClbJB4V0uL2UlhjT27Q4GF2pjqwlKWZ
        JjU+5UYHF+tAY7zPh2JwpiYmjrX3nlRXCa+ZYpyRQioY+BqtUpbf17amHAfmKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643133334;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XDyWzT40y6W7zz1MmiwXNMh+3a0HubyZ5kxWop7Bb1o=;
        b=QQS0FmdAXDaFnKvH1x4TqdaUTckBMb+KbEzJH7hWQj45gInbbV41Ly9XAyGW5tJEr2Y1nS
        2jkkUhVSR4BgryDw==
From:   "tip-bot2 for Tony Luck" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpu: Add Xeon Icelake-D to list of CPUs that
 support PPIN
Cc:     Ailin Xu <ailin.xu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220121174743.1875294-2-tony.luck@intel.com>
References: <20220121174743.1875294-2-tony.luck@intel.com>
MIME-Version: 1.0
Message-ID: <164313333280.16921.9365038595618004818.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e464121f2d40eabc7d11823fb26db807ce945df4
Gitweb:        https://git.kernel.org/tip/e464121f2d40eabc7d11823fb26db807ce945df4
Author:        Tony Luck <tony.luck@intel.com>
AuthorDate:    Fri, 21 Jan 2022 09:47:38 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 25 Jan 2022 18:40:30 +01:00

x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

Missed adding the Icelake-D CPU to the list. It uses the same MSRs
to control and read the inventory number as all the other models.

Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
Reported-by: Ailin Xu <ailin.xu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220121174743.1875294-2-tony.luck@intel.com
---
 arch/x86/kernel/cpu/mce/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index bb9a46a..baafbb3 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -486,6 +486,7 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
 	case INTEL_FAM6_BROADWELL_X:
 	case INTEL_FAM6_SKYLAKE_X:
 	case INTEL_FAM6_ICELAKE_X:
+	case INTEL_FAM6_ICELAKE_D:
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
 	case INTEL_FAM6_XEON_PHI_KNL:
 	case INTEL_FAM6_XEON_PHI_KNM:
