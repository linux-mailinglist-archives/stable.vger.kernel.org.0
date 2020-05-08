Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D470F1CB030
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgEHMhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:37:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgEHMhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D42A721835;
        Fri,  8 May 2020 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941419;
        bh=lzfuXVt3dhMt9V8K+8sDawX4ICe4lJX0t+yk7fsVlzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rH4KQK+eKtCaRrsJ3K8uH6dcJ0AI48f/jLtpjIbCnsqAHZbpxZMRNJWGDZVT2o9Rk
         yYoxG7y9oqHuK7jYJjmB1gh8onbRsqGaMxm30rHI/TPTzDZ5ddPBm44RvW1kY+dDES
         Xo/Jug/TQqQiWgSXy2lzpblwguA+MnHkYq3+Y0DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>,
        Alexander Sverdlin <alexander.svedlin@gmail.com>,
        Jonas Gorski <jogo@openwrt.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 009/312] MIPS: Fix macro typo
Date:   Fri,  8 May 2020 14:30:00 +0200
Message-Id: <20200508123125.163681325@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaedon Shin <jaedon.shin@gmail.com>

commit 2549cc967ebb4043f3507b55e3dc579f44d3b516 upstream.

Change the CONFIG_MIPS_CMDLINE_EXTEND to CONFIG_MIPS_CMDLINE_DTB_EXTEND
to resolve the EXTEND_WITH_PROM macro.

Signed-off-by: Jaedon Shin <jaedon.shin@gmail.com>
Fixes: 2024972ef533 ("MIPS: Make the kernel arguments from dtb available")
Reviewed-by: Alexander Sverdlin <alexander.svedlin@gmail.com>
Cc: Jonas Gorski <jogo@openwrt.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/11909/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -695,7 +695,7 @@ static void __init request_crashkernel(s
 
 #define USE_PROM_CMDLINE	IS_ENABLED(CONFIG_MIPS_CMDLINE_FROM_BOOTLOADER)
 #define USE_DTB_CMDLINE		IS_ENABLED(CONFIG_MIPS_CMDLINE_FROM_DTB)
-#define EXTEND_WITH_PROM	IS_ENABLED(CONFIG_MIPS_CMDLINE_EXTEND)
+#define EXTEND_WITH_PROM	IS_ENABLED(CONFIG_MIPS_CMDLINE_DTB_EXTEND)
 
 static void __init arch_mem_init(char **cmdline_p)
 {


