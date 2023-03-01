Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93A6A72EB
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCASKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCASKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8BFA9
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B6E76140D
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F1CC433D2;
        Wed,  1 Mar 2023 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694238;
        bh=XvkHYM4aHlvY8OJnfGfosr0f5gSKSpyrVM69yuv2oAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCMHuWiwOXtIeMZUKFduC0N10uFEhikC3B78oNQiikynpaaWCZG9QeTDBl6hjxRna
         iI+Wj9xUDFcRcjEX4zHBImYEzzCVQJvj3HguqBdh53tWQJGpV10NNmHUhGPuzyvuRH
         evN8P0APHS/UhpYjVO0Kapx39e8UNk8GwBXpz6UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/22] x86/cpu: Add Lunar Lake M
Date:   Wed,  1 Mar 2023 19:08:45 +0100
Message-Id: <20230301180653.143689495@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit f545e8831e70065e127f903fc7aca09aa50422c7 ]

Intel confirmed the existence of this CPU in Q4'2022
earnings presentation.

Add the CPU model number.

[ dhansen: Merging these as soon as possible makes it easier
	   on all the folks developing model-specific features. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20230208172340.158548-1-tony.luck%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 13922963431a0..b8e7ea9e71e20 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -113,6 +113,8 @@
 #define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 
+#define INTEL_FAM6_LUNARLAKE_M		0xBD
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.0



