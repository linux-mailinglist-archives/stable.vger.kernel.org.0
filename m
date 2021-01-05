Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9725A2EAAB5
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 13:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbhAEM04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 07:26:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730084AbhAEM0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 07:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B39522AAA;
        Tue,  5 Jan 2021 12:26:05 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     kernel-team <kernel-team@android.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>,
        Alan Modra <amodra@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Smith <Peter.Smith@arm.com>,
        Quentin Perret <qperret@google.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH v2] arm64: link with -z norelro for LLD or aarch64-elf
Date:   Tue,  5 Jan 2021 12:26:03 +0000
Message-Id: <160984952218.5069.304716966175823056.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201218002432.788499-1-ndesaulniers@google.com>
References: <CAKwvOd=LZHzR11kuhT2EjFnUdFwu5hQmxiwqeLB2sKC0hWFY=g@mail.gmail.com> <20201218002432.788499-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 17 Dec 2020 16:24:32 -0800, Nick Desaulniers wrote:
> With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> BFD can produce this warning when the target emulation mode does not
> support RELRO program headers, and -z relro or -z norelro is passed.
> 
> Alan Modra clarifies:
>   The default linker emulation for an aarch64-linux ld.bfd is
>   -maarch64linux, the default for an aarch64-elf linker is
>   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
>   you get an emulation that doesn't support -z relro.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: link with -z norelro for LLD or aarch64-elf
      https://git.kernel.org/arm64/c/311bea3cb9ee

Also added the second Fixes tag with a cc stable.

-- 
Catalin

