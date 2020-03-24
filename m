Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE751910B6
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgCXNVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729060AbgCXNVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:21:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A29220775;
        Tue, 24 Mar 2020 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056105;
        bh=glIX5Z7bJqEDQ5JgvMe9Z3yqwXPHOV3ppkP4+fwmd/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIqLrVaBAyfR855SVPQbFkUd6/o0XF2/wgpqOh7NAR8VPP3xs3io8pXQ7tLJiRjwA
         lPC9l0dg8LsKK5xKaCJN/8XVGftV54QQJ+FW9Xe9eorPl15PsE9Zodiht6hBSbnsH2
         QWmepOaGbeufd3v7DY+COYWEiiVEJZxFprCTHrmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 023/119] ARM: bcm2835_defconfig: Explicitly restore CONFIG_DEBUG_FS
Date:   Tue, 24 Mar 2020 14:10:08 +0100
Message-Id: <20200324130810.692890651@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 1bba60808404b873defa0f3560497eb2e8fe86b8 ]

The commit 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")
accidentally dropped the DEBUG FS support in bcm2835_defconfig. So
restore the config as before the commit.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 0e4a459f56c3 ("tracing: Remove unnecessary DEBUG_FS dependency")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/bcm2835_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 519ff58e67b30..0afcae9f7cf8a 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -178,6 +178,7 @@ CONFIG_SCHED_TRACER=y
 CONFIG_STACK_TRACER=y
 CONFIG_FUNCTION_PROFILER=y
 CONFIG_TEST_KSTRTOX=y
+CONFIG_DEBUG_FS=y
 CONFIG_KGDB=y
 CONFIG_KGDB_KDB=y
 CONFIG_STRICT_DEVMEM=y
-- 
2.20.1



