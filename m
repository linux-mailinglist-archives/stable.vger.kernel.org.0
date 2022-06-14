Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E297954B90D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357198AbiFNSpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356353AbiFNSnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:43:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540724A91F;
        Tue, 14 Jun 2022 11:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CF3CB81AF4;
        Tue, 14 Jun 2022 18:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CEAC3411B;
        Tue, 14 Jun 2022 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232133;
        bh=KuQzGMB/TGELsDVIKt9X9t+czdHlsCotrXvjvJZQ58M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJKq+NqDQC9srwkw3cwsX+fFV4AE7yLqmvkPJXxN1C0oqftFCc1oVpJ0h++DT2J7U
         yzhoQ8GsYzMm8a57lIk+IG+WkdAwa7iqHQFJdMnPJw1XvssfpwkqbQvGLMJ7EFo/5j
         V9A6an28dOBrmKIPrZ40Iu7rkBy2lc0OhD/UDplU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David E. Box" <david.e.box@intel.com>, dvhart@infradead.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 05/20] x86/CPU: Add Icelake model number
Date:   Tue, 14 Jun 2022 20:39:56 +0200
Message-Id: <20220614183724.632217777@linuxfoundation.org>
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

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>

commit 8cd8f0ce0d6aafe661cb3d6781c8b82bc696c04d upstream.

Add the CPUID model number of Icelake (ICL) mobile processors to the
Intel family list. Icelake U/Y series uses model number 0x7E.

Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David E. Box" <david.e.box@intel.com>
Cc: dvhart@infradead.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: platform-driver-x86@vger.kernel.org
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190214115712.19642-2-rajneesh.bhardwaj@linux.intel.com
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -55,6 +55,8 @@
 
 #define INTEL_FAM6_CANNONLAKE_MOBILE	0x66
 
+#define INTEL_FAM6_ICELAKE_MOBILE	0x7E
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */


