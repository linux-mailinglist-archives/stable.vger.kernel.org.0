Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C12A0B33
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgJ3Qde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgJ3Qde (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 12:33:34 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A793F2083B;
        Fri, 30 Oct 2020 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604075613;
        bh=4zHX29Tfjk3KBEzmH18Pqsg+zeW3GZGtPFzIR3bgJqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDDe5gIeHFdJ+GGKo38rl2WEWeMmtR3d+3ZKoSFPpzX/qgjR23NnKZlCTbDO9XXTA
         AMSSJb0rsgQRu+/PGyNmvZixLVLdk7bpzZCAuST8ozKWoWbjVckdQ7TJvXw0U0fueH
         FJwDvy3iK6O9fyZBMA980e2tKNCZyyWr9BqncJwM=
From:   Will Deacon <will@kernel.org>
To:     Fangrui Song <maskray@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Jian Cai <jiancai@google.com>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
Date:   Fri, 30 Oct 2020 16:33:26 +0000
Message-Id: <160404675162.1783664.3255910174275487900.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201029181951.1866093-1-maskray@google.com>
References: <20201029181951.1866093-1-maskray@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Oct 2020 11:19:51 -0700, Fangrui Song wrote:
> Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
> arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
> macros. This can lead to the assembly snippet `.weak memcpy ... .globl
> memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
> memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
> https://reviews.llvm.org/D90108) will error on such an overridden symbol
> binding.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S
      https://git.kernel.org/arm64/c/ec9d78070de9

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
