Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EEC54B932
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357430AbiFNSoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357308AbiFNSn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190174BFC6;
        Tue, 14 Jun 2022 11:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7F81617C0;
        Tue, 14 Jun 2022 18:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA66C3411B;
        Tue, 14 Jun 2022 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232139;
        bh=Y3rD/lbIKwVJ592ZEjrFig/429jBDUnciTwOvvj3Cy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSGhorW44yChRuMexhaUdApKYFuTlEeD5G2hfqIqMYjtg6jdM1/fqshmPE9Ee2aHm
         6Dpufnjy8HctdIg9AbvZDRSu1NKGienxglLuclnruXC+hKsqVvd5W6sWv7dlmyg2hc
         ymMb/HvvN4+l2f98FFNbBQQiejtFcvsSLd6A7iJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 07/20] x86/cpu: Add Comet Lake to the Intel CPU models header
Date:   Tue, 14 Jun 2022 20:39:58 +0200
Message-Id: <20220614183725.083916399@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183723.328825625@linuxfoundation.org>
References: <20220614183723.328825625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 8d7c6ac3b2371eb1cbc9925a88f4d10efff374de upstream.

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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -60,6 +60,9 @@
 #define INTEL_FAM6_ICELAKE_DESKTOP	0x7D
 #define INTEL_FAM6_ICELAKE_MOBILE	0x7E
 
+#define INTEL_FAM6_COMETLAKE		0xA5
+#define INTEL_FAM6_COMETLAKE_L		0xA6
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */


