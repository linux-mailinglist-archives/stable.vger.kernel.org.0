Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B122941C4
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 19:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408842AbgJTR5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 13:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408841AbgJTR5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Oct 2020 13:57:19 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 875A62223C;
        Tue, 20 Oct 2020 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603216638;
        bh=9YjFPnAqA0uzYmI3atA5MHEeFfobIzN1G6Wk7DSgOns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRCtLH5efl45rulVA4skkhvXE2e17kpae3sBo3DXNKP9PU64bhIS1PYgmIqBiG0g+
         rpIS3BHkU3rXss1y60JRwOTsWqm7QdUiZNyPuwHAWJZm+qH5Ag2u2Y0ecRFfPEdH7g
         J7nR9+tNXy0UshQlH3VwAj1qpMqWXBaAaS8M0SIg=
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        =?UTF-8?q?F=C4=81ng-ru=C3=AC=20S=C3=B2ng?= <maskray@google.com>
Subject: Re: [PATCH] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
Date:   Tue, 20 Oct 2020 18:57:10 +0100
Message-Id: <160319373854.2175971.17968938488121846972.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201016175339.2429280-1-ndesaulniers@google.com>
References: <20201016175339.2429280-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Oct 2020 10:53:39 -0700, Nick Desaulniers wrote:
> With CONFIG_EXPERT=y, CONFIG_KASAN=y, CONFIG_RANDOMIZE_BASE=n,
> CONFIG_RELOCATABLE=n, we observe the following failure when trying to
> link the kernel image with LD=ld.lld:
> 
> error: section: .exit.data is not contiguous with other relro sections
> 
> ld.lld defaults to -z relro while ld.bfd defaults to -z norelro. This
> was previously fixed, but only for CONFIG_RELOCATABLE=y.

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: link with -z norelro regardless of CONFIG_RELOCATABLE
      https://git.kernel.org/arm64/c/3b92fa7485eb

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
