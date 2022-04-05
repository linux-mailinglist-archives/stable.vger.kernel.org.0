Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4923F4F2F06
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiDEIoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241290AbiDEIdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:33:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31069C4;
        Tue,  5 Apr 2022 01:31:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B318CB81C13;
        Tue,  5 Apr 2022 08:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2342CC385A0;
        Tue,  5 Apr 2022 08:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147470;
        bh=8/YNMu7+LX6RHTLGnnonVq5mzG5eSceZVaeyn/2kX5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEKEYyENUwUNHvub+wWekDVAUWzh+hGRvecg0uOWKHuDMuAfam+p+iUnS5DLuzGxv
         FAReWQn4rSrI4dbEyx3yDnEhMJoi4mEFkhM8QqeG/tJsVrkWDYVpiBrwCrbXyZdSju
         P34HVUweHGcBKTSgaisB6gfPb9pnfSYJBYFcPS7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Palmer <daniel@0x0f.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0010/1017] ARM: mstar: Select HAVE_ARM_ARCH_TIMER
Date:   Tue,  5 Apr 2022 09:15:23 +0200
Message-Id: <20220405070354.477448879@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit ea49432d184a6a09f84461604b7711a4e9f5ec9c ]

The mstar SoCs have an arch timer but HAVE_ARM_ARCH_TIMER wasn't
selected. If MSC313E_TIMER isn't selected then the kernel gets
stuck at boot because there are no timers available.

Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Link: https://lore.kernel.org/r/20220301104349.3040422-1-daniel@0x0f.com'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mstar/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mstar/Kconfig b/arch/arm/mach-mstar/Kconfig
index cd300eeedc20..0bf4d312bcfd 100644
--- a/arch/arm/mach-mstar/Kconfig
+++ b/arch/arm/mach-mstar/Kconfig
@@ -3,6 +3,7 @@ menuconfig ARCH_MSTARV7
 	depends on ARCH_MULTI_V7
 	select ARM_GIC
 	select ARM_HEAVY_MB
+	select HAVE_ARM_ARCH_TIMER
 	select MST_IRQ
 	select MSTAR_MSC313_MPLL
 	help
-- 
2.34.1



