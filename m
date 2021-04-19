Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD836431B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbhDSNOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239211AbhDSNMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:12:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CADC613BC;
        Mon, 19 Apr 2021 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837920;
        bh=Xl0Hx7EhbWhAeoUdUuxL7tXccNlyWCrJr3C0xmUYDLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0N+aGyZ0OE+RGrBv2oQbw/PKAamXFEaeA4E+KSGxpECtbQeLGQF22o6gMkxu2RhQg
         qP+8L+/CAJ5WYPLR8uUuUDoANQ6S/6vB82Cy7CNFa3g3CniWzIjVnNUQ5SGhyoNJ6w
         c4g8CHnw9ze4QmrWJhg7I2p+IXofuAoLmbOfpqXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.11 066/122] riscv: Fix spelling mistake "SPARSEMEM" to "SPARSMEM"
Date:   Mon, 19 Apr 2021 15:05:46 +0200
Message-Id: <20210419130532.426740345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 199fc6b8dee7d6d50467a57e0dc7e3e1b7d59966 upstream.

There is a spelling mistake when SPARSEMEM Kconfig copy.

Fixes: a5406a7ff56e ("riscv: Correct SPARSEMEM configuration")
Cc: stable@vger.kernel.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -147,7 +147,7 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on MMU
-	select SPARSEMEM_STATIC if 32BIT && SPARSMEM
+	select SPARSEMEM_STATIC if 32BIT && SPARSEMEM
 	select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
 
 config ARCH_SELECT_MEMORY_MODEL


