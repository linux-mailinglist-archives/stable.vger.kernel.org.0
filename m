Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C876356C0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiKWJdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237752AbiKWJdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:33:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA13D06C1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 781B6B81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1840C433D7;
        Wed, 23 Nov 2022 09:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195895;
        bh=95b1XakCFBg/d5siGzijyvjnKGr+D1NMWcvNvxWOtxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xeiay/nJbSllnzKcQUo1cr9EIqPq4xcmL+zVb0nLUdyknuV4nKJaCYve5FFiyJpK1
         1y7/FmNdoffErL6KJDmCEJVxnRf/W7NlL8GkavMy0Ljo7mPH2R5pHLCj5VrRutpYug
         3rMwQS+PSH4UEah3gt08jOwqEsxmKkT9nZPAsLws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 032/181] x86/cpu: Add several Intel server CPU model numbers
Date:   Wed, 23 Nov 2022 09:49:55 +0100
Message-Id: <20221123084603.778735641@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 7beade0dd41d42d797ccb7791b134a77fcebf35b ]

These servers are all on the public versions of the roadmap. The model
numbers for Grand Ridge, Granite Rapids, and Sierra Forest were included
in the September 2022 edition of the Instruction Set Extensions document.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20221103203310.5058-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 27158436f322..13922963431a 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -105,10 +105,15 @@
 
 #define INTEL_FAM6_SAPPHIRERAPIDS_X	0x8F	/* Golden Cove */
 
+#define INTEL_FAM6_EMERALDRAPIDS_X	0xCF
+
+#define INTEL_FAM6_GRANITERAPIDS_X	0xAD
+#define INTEL_FAM6_GRANITERAPIDS_D	0xAE
+
 #define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 
-/* "Small Core" Processors (Atom) */
+/* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
 #define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
@@ -135,6 +140,10 @@
 #define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
 #define INTEL_FAM6_ATOM_TREMONT_L	0x9C /* Jasper Lake */
 
+#define INTEL_FAM6_SIERRAFOREST_X	0xAF
+
+#define INTEL_FAM6_GRANDRIDGE		0xB6
+
 /* Xeon Phi */
 
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
-- 
2.35.1



