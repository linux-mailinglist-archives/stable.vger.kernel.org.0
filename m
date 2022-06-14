Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6250554B91E
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357108AbiFNSmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357107AbiFNSlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:41:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0677496B5;
        Tue, 14 Jun 2022 11:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 30D98CE1C03;
        Tue, 14 Jun 2022 18:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF01FC3411B;
        Tue, 14 Jun 2022 18:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232095;
        bh=O4dJF5JLbAqJkMTHNGlx2w5PLAWNKicogAva30Pq3ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMjJhHxrSl95aubt2lEvu90b/GJSWuR+W+Tb1/FWX7paOHIMSKtok7gyk/Kc23VV5
         9jCZZhM+BvcOzKbV2c/VBRLe6oobX/PU/EvN4uvkU+m8JVpQX7YaXtzgJjYiiJSw7g
         zZh4U7lR00qhH07eYg0iKwquDVEXqqg5BkD3/TVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.9 04/20] x86/cpu: Add Cannonlake to Intel family
Date:   Tue, 14 Jun 2022 20:39:47 +0200
Message-Id: <20220614183723.128868889@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183722.061550591@linuxfoundation.org>
References: <20220614183722.061550591@linuxfoundation.org>
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

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>

commit 850eb9fba3711e98bafebde26675d9c082c0ff48 upstream.

Add CPUID of Cannonlake (CNL) processors to Intel family list.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/intel-family.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -9,6 +9,10 @@
  *
  * Things ending in "2" are usually because we have no better
  * name for them.  There's no processor called "SILVERMONT2".
+ *
+ * While adding a new CPUID for a new microarchitecture, add a new
+ * group to keep logically sorted out in chronological order. Within
+ * that group keep the CPUID for the variants sorted by model number.
  */
 
 #define INTEL_FAM6_CORE_YONAH		0x0E
@@ -48,6 +52,8 @@
 #define INTEL_FAM6_KABYLAKE_MOBILE	0x8E
 #define INTEL_FAM6_KABYLAKE_DESKTOP	0x9E
 
+#define INTEL_FAM6_CANNONLAKE_MOBILE	0x66
+
 /* "Small Core" Processors (Atom) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */


