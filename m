Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812B4A3645
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbiA3MeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbiA3MeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:34:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24ABC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 04:34:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A18F1B8291E
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 12:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C816BC340E4;
        Sun, 30 Jan 2022 12:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643546056;
        bh=JhQH1od0nAclxEvrgIZznYuaJ2uz3HBrFnUjr1LVivg=;
        h=Subject:To:Cc:From:Date:From;
        b=elt57jAZntCHnXZiRiiaFyD9A51o61rH1ZYmWAewOessaseZQWZY9cBedfVkjAaFW
         OPbph7cR+ao8/tsP2v0YXZHR1MzDt+V6c5fiW1fFQ25yfvddPzcMPP6mIVik7NgWij
         Hs4bsOz3KkNfW6U602DgeKhnuNeh+W4P4q3QYNOw=
Subject: FAILED: patch "[PATCH] x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN" failed to apply to 5.10-stable tree
To:     tony.luck@intel.com, ailin.xu@intel.com, bp@suse.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 13:34:13 +0100
Message-ID: <164354605382174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e464121f2d40eabc7d11823fb26db807ce945df4 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Fri, 21 Jan 2022 09:47:38 -0800
Subject: [PATCH] x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

Missed adding the Icelake-D CPU to the list. It uses the same MSRs
to control and read the inventory number as all the other models.

Fixes: dc6b025de95b ("x86/mce: Add Xeon Icelake to list of CPUs that support PPIN")
Reported-by: Ailin Xu <ailin.xu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220121174743.1875294-2-tony.luck@intel.com

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index bb9a46a804bf..baafbb37be67 100644
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

