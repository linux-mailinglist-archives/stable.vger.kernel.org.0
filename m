Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81937395CF7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhEaNkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhEaNhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13C4161450;
        Mon, 31 May 2021 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467584;
        bh=AGDQ7EhDEKWLNEGK3KULBHI5AROZPAykwWkmLbXLINI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuttTQYd8luIeR0wvgM9NfKKCUJ8DkICIE8TTU/JvBVupJcedMxarWggkd7fS/K9G
         5b/hPyMoTPKT6u7JSaLkGbDlASXI09RtBVwGsuPz8m/AEmpgN1rsNGjT3sB9pNTwig
         tFId7EMBvDnH4wUB0PdSGki7wYMOWBU3P0s8/JbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/116] MIPS: alchemy: xxs1500: add gpio-au1000.h header file
Date:   Mon, 31 May 2021 15:14:47 +0200
Message-Id: <20210531130643.878727518@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ff4cff962a7eedc73e54b5096693da7f86c61346 ]

board-xxs1500.c references 2 functions without declaring them, so add
the header file to placate the build.

../arch/mips/alchemy/board-xxs1500.c: In function 'board_setup':
../arch/mips/alchemy/board-xxs1500.c:56:2: error: implicit declaration of function 'alchemy_gpio1_input_enable' [-Werror=implicit-function-declaration]
   56 |  alchemy_gpio1_input_enable();
../arch/mips/alchemy/board-xxs1500.c:57:2: error: implicit declaration of function 'alchemy_gpio2_enable'; did you mean 'alchemy_uart_enable'? [-Werror=implicit-function-declaration]
   57 |  alchemy_gpio2_enable();

Fixes: 8e026910fcd4 ("MIPS: Alchemy: merge GPR/MTX-1/XXS1500 board code into single files")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Manuel Lauss <manuel.lauss@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/board-xxs1500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/alchemy/board-xxs1500.c b/arch/mips/alchemy/board-xxs1500.c
index 5f05b8714385..b968cff5baa7 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -31,6 +31,7 @@
 #include <asm/reboot.h>
 #include <asm/setup.h>
 #include <asm/mach-au1x00/au1000.h>
+#include <asm/mach-au1x00/gpio-au1000.h>
 #include <prom.h>
 
 const char *get_system_type(void)
-- 
2.30.2



