Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57957242E
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbiGLS4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbiGLS4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:56:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB0EB012;
        Tue, 12 Jul 2022 11:46:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E044B81BAB;
        Tue, 12 Jul 2022 18:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F68C3411C;
        Tue, 12 Jul 2022 18:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651599;
        bh=o4/srVdodmfnh4pywnFMEK+V/2gNOqg0RGT2S3PRrWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjJHVxIYeCo2HNvtzcE5Tlt+IOpdlWF0Uo1+JNxC+o/XEohiYCrPapL2LDA+L1rD0
         RSoCGwhE6ErMAHJ7RoAyyfWLY6utB7n4w7HPQ7oseBPM1USJQD/KlFP34+Toko9wOS
         Ej8zVg1Vy0xeVTptHG+u20WD21e7flpuWzDyXH2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 126/130] x86/bugs: Add Cannon lake to RETBleed affected CPU list
Date:   Tue, 12 Jul 2022 20:39:32 +0200
Message-Id: <20220712183252.279724350@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f54d45372c6ac9c993451de5e51312485f7d10bc upstream.

Cannon lake is also affected by RETBleed, add it to the list.

Fixes: 6ad0ad2bf8a6 ("x86/bugs: Report Intel retbleed vulnerability")
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1129,6 +1129,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_L,	X86_STEPPING_ANY,		RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),


