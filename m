Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EC25AAEC2
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiIBM3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiIBM2a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:28:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37D6DCFF8;
        Fri,  2 Sep 2022 05:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53B6C620F0;
        Fri,  2 Sep 2022 12:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C694C433C1;
        Fri,  2 Sep 2022 12:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121375;
        bh=+0RIXtjL4dCGFnZcWvWmOCTGFsuswLnX0WkQWCR8Q18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVMyTI/33qtSAzs5/3lCerMzOkxVkkaMp+bVfjHg6qDMWAllTESyXau7VlTN6IaJH
         QMrxQ42kHRVR2RWSRcY5Jkl+i7dj6tEbGbOxamhQdK+1pcE/WE1FG2cQnHe4oPcWfj
         4uhCpahItRbqL+eRRZLZHo/ZxwPtE8Mlb2E39eS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 4.14 29/42] x86/cpu: Add Tiger Lake to Intel family
Date:   Fri,  2 Sep 2022 14:18:53 +0200
Message-Id: <20220902121359.810537853@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gayatri Kammela <gayatri.kammela@intel.com>

commit 6e1c32c5dbb4b90eea8f964c2869d0bde050dbe0 upstream.

Add the model numbers/CPUIDs of Tiger Lake mobile and desktop to the
Intel family.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190905193020.14707-2-tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -71,6 +71,9 @@
 #define INTEL_FAM6_ALDERLAKE		0x97
 #define INTEL_FAM6_ALDERLAKE_L		0x9A
 
+#define INTEL_FAM6_TIGERLAKE_L		0x8C
+#define INTEL_FAM6_TIGERLAKE		0x8D
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */


