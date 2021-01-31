Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F0E309D32
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhAaOuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:50:21 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47315 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231862AbhAaOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:42:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id F103E195A985;
        Sun, 31 Jan 2021 09:41:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:41:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jQVo7n
        Ck0AY+jQvUk9PEc2s7/rrJtTLqG5if5eG3m6g=; b=FkvWFbNKnnz0RmNyFYMeKG
        4QY82scprdgzbiFVUT76sG4VktgxyONGJlpS6bTJO0ATnJhaBzcNElrzslC8v8Na
        Zzx4LiN5zmjsuGRcgWmY1AFMEXwJ924G05nQ/SYKMtwjEsqvWELGIiza6JPqhtmf
        jUFCpe6UtOwfxaOLTclOzmnIuClieMxJ8+sJqbQ2ZLIjJahLcUb05olLsyUqVhtB
        QT1Z6AtrgLgi1bAzYCxrsAKtIYnRqyQXvcTNFtR1VsEnetCFZk8sldfyX7UZoknQ
        mYApV8tIzkKk/7fENRDGqaVQ/7b/XwRXR0xmjyJEti3pz5NDKXJvVfTzG45kcw1w
        ==
X-ME-Sender: <xms:fMEWYNPCk9dGC_2VtLfyg1qFFxIaqW6LuhtDb6wvuPPDDAVbOkMCRg>
    <xme:fMEWYP-hbWfPItZcRaH8rSoPmD0TIuKMr-omKFVzsTg7o3X1IzSOdbxIImbt0aRsz
    MPS73tE-rN8ZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fMEWYMRrrfmuyCoo-2qZR515WAeynCafM9g_gQNHd2Lk4UQbPUg-Gw>
    <xmx:fMEWYJtmPLMWnU3bXQz2X0pHoTVIL9rb0n23bh0IX34ETnXr7lFcjg>
    <xmx:fMEWYFe2DtLSNageCf3vpXzMTXOSLbwkjNuVCrDTeAV9DxpHpBjRtQ>
    <xmx:fMEWYGqXg1frEXxC6xh5iYB7bxy7NCzb8uMsidbe8RYFueeBXW_cLQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A2FB1080057;
        Sun, 31 Jan 2021 09:41:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: Fix kernel address detection of __is_lm_address()" failed to apply to 5.4-stable tree
To:     vincenzo.frascino@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, stable@vger.kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:40:58 +0100
Message-ID: <1612104058247187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 519ea6f1c82fcdc9842908155ae379de47818778 Mon Sep 17 00:00:00 2001
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Date: Tue, 26 Jan 2021 13:40:56 +0000
Subject: [PATCH] arm64: Fix kernel address detection of __is_lm_address()

Currently, the __is_lm_address() check just masks out the top 12 bits
of the address, but if they are 0, it still yields a true result.
This has as a side effect that virt_addr_valid() returns true even for
invalid virtual addresses (e.g. 0x0).

Fix the detection checking that it's actually a kernel address starting
at PAGE_OFFSET.

Fixes: 68dd8ef32162 ("arm64: memory: Fix virt_addr_valid() using __is_lm_address()")
Cc: <stable@vger.kernel.org> # 5.4.x
Cc: Will Deacon <will@kernel.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Link: https://lore.kernel.org/r/20210126134056.45747-1-vincenzo.frascino@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 18fce223b67b..99d7e1494aaa 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -247,9 +247,11 @@ static inline const void *__tag_set(const void *addr, u8 tag)
 
 
 /*
- * The linear kernel range starts at the bottom of the virtual address space.
+ * Check whether an arbitrary address is within the linear map, which
+ * lives in the [PAGE_OFFSET, PAGE_END) interval at the bottom of the
+ * kernel's TTBR1 address range.
  */
-#define __is_lm_address(addr)	(((u64)(addr) & ~PAGE_OFFSET) < (PAGE_END - PAGE_OFFSET))
+#define __is_lm_address(addr)	(((u64)(addr) ^ PAGE_OFFSET) < (PAGE_END - PAGE_OFFSET))
 
 #define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)

