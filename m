Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BC563DFD8
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiK3SvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiK3Suy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572F89D828
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E73D7B81CA6
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4813DC433D7;
        Wed, 30 Nov 2022 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834250;
        bh=GHyvOY7SR3SM2NukHTDbufgzpkUSCUz3IoJMrSrM4Y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMVY52XONUtxlCz0ddORkKKOnLmktOtWP74LiUVFV7Wdkan33li38Vez0msNbBuXT
         f94pQK2cSl4y1XuB7mLwPle9iK4VS23THdGsSb5AAoImJqfqS5a20r3L4GFAxs/fog
         gCRWczpGUehHbU6p+DZI+5oTMccMSV3f/vYdGn3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 185/289] nios2: add FORCE for vmlinuz.gz
Date:   Wed, 30 Nov 2022 19:22:50 +0100
Message-Id: <20221130180548.318701320@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 869e4ae4cd2a23d625aaa14ae62dbebf768cb77d ]

Add FORCE to placate a warning from make:

arch/nios2/boot/Makefile:24: FORCE prerequisite is missing

Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
index 8c3ad76602f3..29c11a06b750 100644
--- a/arch/nios2/boot/Makefile
+++ b/arch/nios2/boot/Makefile
@@ -20,7 +20,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 $(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
 	$(call if_changed,gzip)
 
-$(obj)/vmImage: $(obj)/vmlinux.gz
+$(obj)/vmImage: $(obj)/vmlinux.gz FORCE
 	$(call if_changed,uimage)
 	@$(kecho) 'Kernel: $@ is ready'
 
-- 
2.35.1



