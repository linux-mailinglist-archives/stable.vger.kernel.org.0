Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740E26E04B5
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbjDMClN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjDMCkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B285FDE;
        Wed, 12 Apr 2023 19:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05BAE63AA8;
        Thu, 13 Apr 2023 02:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804B0C433D2;
        Thu, 13 Apr 2023 02:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681353464;
        bh=vC7xAvcNK/5F12cP1kHH0jxs8tc0Uao6TcKhF+rlFzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDaacmfD/jsT53BSU01J8n3Yr3Uhdmqd1kTzlZfQdp3Haz2AzXeRs2cidzVzZ3Eou
         bi4W8TO8z6/B9R8tSvBc4brq5tmTIpA/vz/Elg0VC9a8y2m1TbQi5tiiG+qtwarQhL
         iHu1NX5m6rDxawuElBn8GT6980QWgE6I0/lzMuqZnp/ZLZ7wZWo93UljzcT18BjUXc
         COquznLjLxh4xb9okltOjb1nBiwONSs0WXuMXDXboLPxK/vnHCq4RhRqLOARa5T9ux
         r0vS2wJ2+xch5I+flRWHc3ioTGbiQZ7tIcHT4AdWctkA/wsuEs52IEe5HRsK7SYJ48
         Zh1bB6RF13CQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com
Subject: [PATCH AUTOSEL 5.15 8/8] x86/cpu: Add model number for Intel Arrow Lake processor
Date:   Wed, 12 Apr 2023 22:37:25 -0400
Message-Id: <20230413023727.74875-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230413023727.74875-1-sashal@kernel.org>
References: <20230413023727.74875-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

