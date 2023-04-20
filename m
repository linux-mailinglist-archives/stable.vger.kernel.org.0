Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003106E91BF
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 13:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbjDTLFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 07:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbjDTLE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 07:04:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1245B81;
        Thu, 20 Apr 2023 04:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A48A647DC;
        Thu, 20 Apr 2023 11:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285BDC4339B;
        Thu, 20 Apr 2023 11:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988549;
        bh=BxEpKquUAqaTHU2HUWRxzVwEbGcW5EywGMyl4xgY+ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIweLNCj4xFysspfp3U51XHJBZfq5qCqZCQYzz5tBAfGGDJnJa6CWdcdNNuBto8FS
         L0DlZMPmBKV2+L8FLN1bUvGTml/k3jp3MQiN6rM8quZabB87CLbXXQbpN2ZGWwmRf+
         1Kb6mJ0ltRP4W3D+Lpm0Zc9FzBru5KQPNENHLvlNM03Jt9hwB8VBeUZGL+9FRvPJ6U
         DXkN4NxHPsXcfpcHqZ7wae530PxKByynthOA6YYPG4NXGRLlQfZ98CCO9RGzCQIDP5
         yO7KmUp/edZwb8ZjHtczNGhQxQpdYeg/IOyhOTeEw5pV8jUDQFy6sJPgPimFqkBavd
         HACffe3NilLag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com
Subject: [PATCH AUTOSEL 6.2 17/17] x86/cpu: Add model number for Intel Arrow Lake processor
Date:   Thu, 20 Apr 2023 07:01:46 -0400
Message-Id: <20230420110148.505779-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
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

