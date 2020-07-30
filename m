Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F962331ED
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG3MWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 08:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgG3MWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 08:22:06 -0400
Received: from gaia (unknown [95.146.230.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61F592082E;
        Thu, 30 Jul 2020 12:22:04 +0000 (UTC)
Date:   Thu, 30 Jul 2020 13:22:01 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/alternatives: move length validation inside the
 subsection
Message-ID: <20200730122201.GM25149@gaia>
References: <20200729215152.662225-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729215152.662225-1-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 02:51:52PM -0700, Sami Tolvanen wrote:
> Commit f7b93d42945c ("arm64/alternatives: use subsections for replacement
> sequences") breaks LLVM's integrated assembler, because due to its
> one-pass design, it cannot compute instruction sequence lengths before the
> layout for the subsection has been finalized. This change fixes the build
> by moving the .org directives inside the subsection, so they are processed
> after the subsection layout is known.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/1078
> Cc: <stable@vger.kernel.org> # 4.14+

Commit f7b93d42945c went in 5.8-rc4. Why is this cc stable from 4.14? If
Will picks it up for 5.8, it doesn't even need a cc stable.

Please add a Fixes: tag as well.

-- 
Catalin
