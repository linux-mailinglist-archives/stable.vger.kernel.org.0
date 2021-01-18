Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677A92FA415
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405404AbhARPGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390369AbhARLly (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC7F5224B0;
        Mon, 18 Jan 2021 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970072;
        bh=vzFYKVTRqI/LR9uvXRyhzY8foJxD0XoHan+viCS6YMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ww2wd3AAejI2kZxx1VJlJ+YlmfdC55L86nfg7/5hAYLbwTY+oHqFbxVOjdWL9JVHe
         qRlnNt1UVxdnr5BmvcvfLnmHz8L++a89Ug6AKF80e1LCGUFBqMjt8hqTLz/Y5P058s
         buO1aoBy23bBnMRDKjYdtMBvCsgaNygxEzJdfyo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        Pekka Enberg <penberg@kernel.org>,
        Atish Patra <atish.patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.10 025/152] riscv: Drop a duplicated PAGE_KERNEL_EXEC
Date:   Mon, 18 Jan 2021 12:33:20 +0100
Message-Id: <20210118113353.987115113@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

commit 0ea02c73775277001c651ad4a0e83781a9acf406 upstream.

commit b91540d52a08 ("RISC-V: Add EFI runtime services") add
a duplicated PAGE_KERNEL_EXEC, kill it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Atish Patra <atish.patra@wdc.com>
Fixes: b91540d52a08 ("RISC-V: Add EFI runtime services")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/include/asm/pgtable.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -99,7 +99,6 @@
 				| _PAGE_DIRTY)
 
 #define PAGE_KERNEL		__pgprot(_PAGE_KERNEL)
-#define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL | _PAGE_EXEC)
 #define PAGE_KERNEL_READ	__pgprot(_PAGE_KERNEL & ~_PAGE_WRITE)
 #define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL | _PAGE_EXEC)
 #define PAGE_KERNEL_READ_EXEC	__pgprot((_PAGE_KERNEL & ~_PAGE_WRITE) \


