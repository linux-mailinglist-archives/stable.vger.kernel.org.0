Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB936E6390
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjDRMln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjDRMlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223D7146CD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC39F6331E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE572C433EF;
        Tue, 18 Apr 2023 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821685;
        bh=lhK3xitY2JVy52Kmt0YPT/Z/XI1bNXJ98P9QLBAXV2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPUjCLxxerSWXumkWxi/oFUOa+exJCssiVpGF8UJ9jOucV8illsEwN+iPDdHWYB32
         pLPB13DPn1TDkol06lYDLSGpel7dLFqnLITX5Le8lL8Eo9r9gHSgbBFFg81hi8HUit
         U/WdkeBESnEJ83tqtbo6FK3Awvrxdiv7L9ZRnDWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/91] sh: remove meaningless archclean line
Date:   Tue, 18 Apr 2023 14:22:18 +0200
Message-Id: <20230418120308.112501810@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 10c6ae274fe29f732ca9bbcd7016e9827673c954 ]

The vsyscall directory is cleaned up by the ordinary way
via arch/sh/kernel/Makefile:

  obj-$(CONFIG_VSYSCALL)          += vsyscall/

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: d83806c4c0cc ("purgatory: fix disabling debug info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 88ddb6f1c75b0..7814639006213 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -200,7 +200,6 @@ archprepare:
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
-	$(Q)$(MAKE) $(clean)=arch/sh/kernel/vsyscall
 
 archheaders:
 	$(Q)$(MAKE) $(build)=arch/sh/kernel/syscalls all
-- 
2.39.2



