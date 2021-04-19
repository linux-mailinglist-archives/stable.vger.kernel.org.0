Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD736443B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbhDSNZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242012AbhDSNZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 119CF61360;
        Mon, 19 Apr 2021 13:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838405;
        bh=C/VYN5RIlURjwTeCntiP7S3o0MmPWCTiJ6aemB2IPo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqBTSzkSQGfoU/3blUpxXHVGDtGiUBJzfAjeKCxg38gkdM9ZngRuFYIRp3PDV1jDP
         eh7X65WGQSaI1tGGpSiHC9j44d7kd+i+xPBDAtnftwcVFarRKlLQtzhh3Wbnlq7QTl
         2BaPwNuI1Cr4QnWzxoAfiKp1eqJSO05GOjahgXeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.4 48/73] riscv: Fix spelling mistake "SPARSEMEM" to "SPARSMEM"
Date:   Mon, 19 Apr 2021 15:06:39 +0200
Message-Id: <20210419130525.382778372@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130523.802169214@linuxfoundation.org>
References: <20210419130523.802169214@linuxfoundation.org>
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
@@ -101,7 +101,7 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on MMU
-	select SPARSEMEM_STATIC if 32BIT && SPARSMEM
+	select SPARSEMEM_STATIC if 32BIT && SPARSEMEM
 	select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
 
 config ARCH_SELECT_MEMORY_MODEL


