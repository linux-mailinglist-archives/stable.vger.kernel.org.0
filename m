Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE483960E7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbhEaOdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhEaObF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15AE961C30;
        Mon, 31 May 2021 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468935;
        bh=RpnSHOZbPR7RayPJWJNhGEtED4nLexQcZ2v3i/i/Qvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2zLU6GTfyLLMPuqRpH8Waado2VE8/QjJOF0jrjB7gQ+cULqbd+ZjKoBdEuKv3dUN
         RYnuyDzVd9rLzdMMFGu5q1NBYU6jIqOKVwdxJEzg6UhUXdWP7YtG+2MZ96nK/94A7H
         Hj7RoHxPYYkGA0uX/wPZ9knb/yiHNxAeRdNP2XqM=
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
Subject: [PATCH 5.4 168/177] MIPS: alchemy: xxs1500: add gpio-au1000.h header file
Date:   Mon, 31 May 2021 15:15:25 +0200
Message-Id: <20210531130653.725375610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index c67dfe1f4997..ec35aedc7727 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -18,6 +18,7 @@
 #include <asm/reboot.h>
 #include <asm/setup.h>
 #include <asm/mach-au1x00/au1000.h>
+#include <asm/mach-au1x00/gpio-au1000.h>
 #include <prom.h>
 
 const char *get_system_type(void)
-- 
2.30.2



