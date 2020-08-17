Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105F32474F3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392231AbgHQTRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgHQPin (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D0B622DD6;
        Mon, 17 Aug 2020 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678722;
        bh=XPZYl87iBLU/pIelDeSdz+Pkk/v/wT9X5KhsNXGFJJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUKeyCkrKnhqkqKWnHwKy48M+9Zo7H4qvlx7ULHdyO7bAHwBQbY6AOlq389oC/aXW
         vI0DUi15G2/p52VqlcxkoPtQl052hLJnBie8G5rfr6ko0QH9yiQCIIyCpoQQTr1YlX
         nySD3McNPf4vkni0mKCbncLf/GtgErL4EMWRBfvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.8 432/464] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Date:   Mon, 17 Aug 2020 17:16:25 +0200
Message-Id: <20200817143854.473210762@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit cf99c505cf7a5b6d3deee91e3571871f20320d31 upstream.

Only Loongson64 platform has and needs loongson_regs.h, including it
unconditionally will cause build errors.

Fixes: 7f2a83f1c2a941ebfee5 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Message-Id: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kvm/vz.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -29,7 +29,9 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
+#ifdef CONFIG_CPU_LOONGSON64
 #include "loongson_regs.h"
+#endif
 
 #include "trace.h"
 


