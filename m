Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8E3395C0A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhEaN1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:27:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231866AbhEaNZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:25:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D6C61396;
        Mon, 31 May 2021 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467255;
        bh=VNoJb72BASLscbJ76MB5QsneL7jW1r5so6opZSHcc3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sest4B5M2l6adbgCIyZvA2B3kdW8htVgP1F3Xbb/zehFmvfsLs43TepFVRzFnhcov
         6EuUvF46v0mRRnXqPrg/nwYFROP/TfUUi3yM+Axz/Sbi5GAHqbd2cB8ALNXuzGNy3o
         M8TIa64YcjFMxtJDu6joJMiW48235ubnrEiNIGGE=
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
Subject: [PATCH 4.9 63/66] MIPS: alchemy: xxs1500: add gpio-au1000.h header file
Date:   Mon, 31 May 2021 15:14:36 +0200
Message-Id: <20210531130638.246710532@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
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
index 0fc53e08a894..c05f7376148a 100644
--- a/arch/mips/alchemy/board-xxs1500.c
+++ b/arch/mips/alchemy/board-xxs1500.c
@@ -30,6 +30,7 @@
 #include <asm/bootinfo.h>
 #include <asm/reboot.h>
 #include <asm/mach-au1x00/au1000.h>
+#include <asm/mach-au1x00/gpio-au1000.h>
 #include <prom.h>
 
 const char *get_system_type(void)
-- 
2.30.2



