Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAB6322CC
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiKUMqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiKUMpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAEEBFF5F
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:45:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 594EEB80F9D
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B83EC433D6;
        Mon, 21 Nov 2022 12:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034751;
        bh=Yq3VMNuFpn69nMZtKKLtJ9N5U8vP+OtWHwbbLu+uqVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXPejQGCnypOjFiVqBxK0UKgLlyFFiVRFLNPwt3+uaXxd67myOam01MRl5ICH9RG2
         8VIBqrr0PgmJ1gDr/omfoofbIIeOtFrQww2n0xQl1j68dMOkl/gHMyvpC1Cqzelm7F
         VEVpyhWOBadJWcCrfNQbuYaeoPoLIV7S45Qk26uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 30/34] x86/bugs: Add Cannon lake to RETBleed affected CPU list
Date:   Mon, 21 Nov 2022 13:43:52 +0100
Message-Id: <20221121124151.975135284@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust cpu model name CANNONLAKE_L -> CANNONLAKE_MOBILE ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1053,6 +1053,7 @@ static const struct x86_cpu_id cpu_vuln_
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(CANNONLAKE_MOBILE,X86_STEPPING_ANY,		RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPING_ANY,		MMIO),


