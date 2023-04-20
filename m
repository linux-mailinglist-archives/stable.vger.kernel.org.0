Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0356E91FE
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbjDTLHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbjDTLF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1A47D85;
        Thu, 20 Apr 2023 04:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7854647E6;
        Thu, 20 Apr 2023 11:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF1BC433A1;
        Thu, 20 Apr 2023 11:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988604;
        bh=vC7xAvcNK/5F12cP1kHH0jxs8tc0Uao6TcKhF+rlFzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9fR+O+tY6+HpoxW8cO5Z7Vr2yjNK9xX7fWSl9RXZlN75zipxidw2Q39UBjsl0mWE
         JOLk9xTUxuaMgiPYzQfcQmSIMMYyBwnJKWhNkER2ojev3m56+lVWZJzYRwft6WU9co
         c4BXW9tYGoz28UEiU9FRQQvZKqFYVqRNNAxDc4fnldQlFqefizT9Ww7gBo0LIqh3t6
         HwrRRo/OrIEOh6KRKkfIPRwWQYn9LeEHeCuxvCCQWVm34As32PuPTHusHXSXx23gGB
         1orSas2h+W30upr/iqNfWPox3ZfkVY8x1AGgG+V94p9zk5tGfI1/W7Pf85t3ti5hir
         lylTcjAiYF33w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com
Subject: [PATCH AUTOSEL 5.15 7/7] x86/cpu: Add model number for Intel Arrow Lake processor
Date:   Thu, 20 Apr 2023 07:03:07 -0400
Message-Id: <20230420110308.506181-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110308.506181-1-sashal@kernel.org>
References: <20230420110308.506181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 81515ecf155a38f3532bf5ddef88d651898df6be ]

Successor to Lunar Lake.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230404174641.426593-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index b8e7ea9e71e20..fc12d970a07c0 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -115,6 +115,8 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE		0xC6
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2

