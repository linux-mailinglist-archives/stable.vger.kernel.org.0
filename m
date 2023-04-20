Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83E646E9201
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbjDTLHZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbjDTLFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F45FF4;
        Thu, 20 Apr 2023 04:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE70B647D4;
        Thu, 20 Apr 2023 11:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826EAC433A0;
        Thu, 20 Apr 2023 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988586;
        bh=BxEpKquUAqaTHU2HUWRxzVwEbGcW5EywGMyl4xgY+ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+cBk2Y3zupAXSHEjfLUnZ1XrpAZcjEptORxMHjkJAlYTQvoGc3H0ACQ7GjvnM6GD
         49Vg+EaWHWNWmO+PJCjxh78hu2oiL2RUXbzdLaE21X2cze6uGGFVn1XWz6GPsBtF3E
         UbxQ83SvC1aUxxq2FadjpuI9C5uA4+U9AKLny3va3Ed9pl1JrDaLNKe6ffcBS3KGIH
         3tfZBQAKI6miL21CvzmefptICMrotbbQYnHDakwYc3+JFZ6Y2k4XXJo/m8yCXK/6cf
         8Ck6QKsi8C2gnnWj4zW9LKNKKtHcEtUQkKAW5ODtEgouNL4ZceBDlMalrvNXKAcUhi
         3Kt56GPrEse3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com
Subject: [PATCH AUTOSEL 6.1 15/15] x86/cpu: Add model number for Intel Arrow Lake processor
Date:   Thu, 20 Apr 2023 07:02:29 -0400
Message-Id: <20230420110231.505992-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110231.505992-1-sashal@kernel.org>
References: <20230420110231.505992-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index cbaf174d8efd9..b3af2d45bbbb5 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -125,6 +125,8 @@
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
+#define INTEL_FAM6_ARROWLAKE		0xC6
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.2

