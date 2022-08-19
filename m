Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D90B59A18B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350948AbiHSQCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351244AbiHSQBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:01:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1412610A760;
        Fri, 19 Aug 2022 08:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32284615E7;
        Fri, 19 Aug 2022 15:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF0EC433D6;
        Fri, 19 Aug 2022 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924379;
        bh=mMHWB+1et05fSZ7uZu7j8PjCDavhZJN072Bc+vANuQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QhWrXHAP641NBwiyPF6Ri7d7kuzAzCsPpejPf2gVIrxZgb5uwGKnJKWoUyGloEs0A
         4gvIF5Ieyr+PGjSckS58o3kJ1vGdiFIqFDhOhY8/bhj4Ges7PqQ2k7t1C6jo+zicmk
         MkCWvqVVIJRByNPKtg6MrrbAgCzV0X+j3lhk38fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brian Cain <bcain@codeaurora.org>,
        David Rientjes <rientjes@google.com>,
        Oliver Glitta <glittao@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/545] hexagon: select ARCH_WANT_LD_ORPHAN_WARN
Date:   Fri, 19 Aug 2022 17:38:11 +0200
Message-Id: <20220819153834.707125710@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 113616ec5b64b23a1c9b663adafadabdfbec0f51 ]

Now that we handle all of the sections in a Hexagon defconfig, select
ARCH_WANT_LD_ORPHAN_WARN so that unhandled sections are warned about by
default.

Link: https://lkml.kernel.org/r/20210521011239.1332345-4-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index f2afabbadd43..cc2c1ae48e62 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -32,6 +32,7 @@ config HEXAGON
 	select MODULES_USE_ELF_RELA
 	select GENERIC_CPU_DEVICES
 	select SET_FS
+	select ARCH_WANT_LD_ORPHAN_WARN
 	help
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
-- 
2.35.1



