Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2973CE45D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347331AbhGSPnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240940AbhGSPhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE1761248;
        Mon, 19 Jul 2021 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711481;
        bh=QD1d3pOJsWBYGMDUpWa4YS0LLXpRn9mRsdxNn5EXTc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkVpjybQ2HlXssNOsJI8RUmiwKboLVMDPwHDV8L+pENpMfK3ho5EYcTUr2dnqusLd
         esXjuQxg7ihIbsVCdArajDUCFGZRDtKPI6YXQOmFjOH3lIM6brtPC/LubuPt+nY3FF
         10Vzl26syUwNlYlTiuH4x6KRJpwisdK3vObA9Jh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org,
        bowsingbetee <bowsingbetee@protonmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 019/292] EDAC/igen6: fix core dependency AGAIN
Date:   Mon, 19 Jul 2021 16:51:21 +0200
Message-Id: <20210719144943.166355936@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit a1c9ca5f65c9acfd7c02474b9d5cacbd7ea288df upstream.

My previous patch had a typo/thinko which prevents this driver
from being enabled: change X64_64 to X86_64.

Fixes: 0a9ece9ba154 ("EDAC/igen6: fix core dependency")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac@vger.kernel.org
Cc: bowsingbetee <bowsingbetee@protonmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -271,7 +271,7 @@ config EDAC_PND2
 config EDAC_IGEN6
 	tristate "Intel client SoC Integrated MC"
 	depends on PCI && PCI_MMCONFIG && ARCH_HAVE_NMI_SAFE_CMPXCHG
-	depends on X64_64 && X86_MCE_INTEL
+	depends on X86_64 && X86_MCE_INTEL
 	help
 	  Support for error detection and correction on the Intel
 	  client SoC Integrated Memory Controller using In-Band ECC IP.


