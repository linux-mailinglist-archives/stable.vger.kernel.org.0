Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A532F78D9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbhAOMYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:24:35 -0500
Received: from ozlabs.org ([203.11.71.1]:34483 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728947AbhAOMYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:24:34 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4DHL2J52GBz9sWQ; Fri, 15 Jan 2021 23:23:52 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
In-Reply-To: <20210104205952.1399409-1-natechancellor@gmail.com>
References: <20210104204850.990966-1-natechancellor@gmail.com> <20210104205952.1399409-1-natechancellor@gmail.com>
Subject: Re: [PATCH v2] powerpc: Handle .text.{hot,unlikely}.* in linker script
Message-Id: <161071339895.2210050.3375251012287631556.b4-ty@ellerman.id.au>
Date:   Fri, 15 Jan 2021 23:23:52 +1100 (AEDT)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Jan 2021 13:59:53 -0700, Nathan Chancellor wrote:
> Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
> sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
> change [1].
> 
> After another LLVM change [2], these sections are seen in some PowerPC
> builds, where there is a orphan section warning then build failure:
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc: Handle .text.{hot,unlikely}.* in linker script
      https://git.kernel.org/powerpc/c/3ce47d95b7346dcafd9bed3556a8d072cb2b8571

cheers
