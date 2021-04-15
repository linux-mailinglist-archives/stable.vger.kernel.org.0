Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF77B361163
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhDORs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhDORs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 13:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2951D601FD;
        Thu, 15 Apr 2021 17:48:34 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <jiancai@google.com>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: alternatives: Move length validation in alternative_{insn, endif}
Date:   Thu, 15 Apr 2021 18:48:29 +0100
Message-Id: <161850887861.19953.221061108559265600.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210414000803.662534-1-nathan@kernel.org>
References: <20210414000803.662534-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 13 Apr 2021 17:08:04 -0700, Nathan Chancellor wrote:
> After commit 2decad92f473 ("arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is
> set atomically"), LLVM's integrated assembler fails to build entry.S:
> 
> <instantiation>:5:7: error: expected assembly-time absolute expression
>  .org . - (664b-663b) + (662b-661b)
>       ^
> <instantiation>:6:7: error: expected assembly-time absolute expression
>  .org . - (662b-661b) + (664b-663b)
>       ^
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: alternatives: Move length validation in alternative_{insn, endif}
      https://git.kernel.org/arm64/c/22315a2296f4

-- 
Catalin

