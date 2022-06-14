Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598A754B901
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357516AbiFNSoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiFNSn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:43:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140954AE05;
        Tue, 14 Jun 2022 11:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8342B81AF7;
        Tue, 14 Jun 2022 18:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE40C3411B;
        Tue, 14 Jun 2022 18:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232136;
        bh=f2EN4zGPjIX84IShYB7M8WTY5Mvki/OjMF8qulP8Pqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8VXD542TsKCmqIsw3ZBBYpQiaHIn4PJ8uN8fPjjZ2ataalUhhMyXNyDFK/rKL/aj
         +DSj2IMs6a7NkeF9nBOC2pWfZ7VpJNY/HO4Vmm4eEerBOvIRy6JnEmRgiD3mmQHr3J
         jcgbXPDYy7S2hrT4AyzSVJIWIipAOrAOMAscHXYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        rui.zhang@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 06/20] x86/CPU: Add more Icelake model numbers
Date:   Tue, 14 Jun 2022 20:39:57 +0200
Message-Id: <20220614183724.852600509@linuxfoundation.org>
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

commit e35faeb64146f2015f2aec14b358ae508e4066db upstream.

Add the CPUID model numbers of Icelake (ICL) desktop and server
processors to the Intel family list.

 [ Qiuxu: Sort the macros by model number. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190603134122.13853-1-kan.liang@linux.intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -55,6 +55,9 @@
 
 #define INTEL_FAM6_CANNONLAKE_MOBILE	0x66
 
+#define INTEL_FAM6_ICELAKE_X		0x6A
+#define INTEL_FAM6_ICELAKE_XEON_D	0x6C
+#define INTEL_FAM6_ICELAKE_DESKTOP	0x7D
 #define INTEL_FAM6_ICELAKE_MOBILE	0x7E
 
 /* "Small Core" Processors (Atom) */


