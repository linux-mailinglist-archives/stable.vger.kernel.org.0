Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66040311A4E
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 04:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBFDjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 22:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhBFDg4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 22:36:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A416500A;
        Sat,  6 Feb 2021 00:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612569635;
        bh=XF+uWHXm1g4GhLFkSCQZgabMbC0W+zMiDr00i0BB7pI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MUBkFywyjwSFpZaFfaUsNzWKizsls1f3nSxTsStEExgKF2ys/FpaDDGw/Ybdmh4re
         uocmD6LRTXdD22N2SOWqE5QwA+uSlmXEuX7UjSjEMly1TkGIUuU7cFDufXA6Vcv9FS
         DYeE+aXNXmQTlGd0m1mujbVSUP/m5ORVhqydg9+s=
Date:   Fri, 5 Feb 2021 16:00:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kbuild@vger.kernel.org, linux-arch@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Caroline Tice <cmtice@google.com>,
        Nick Clifton <nickc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Chris Murphy <bugzilla@colorremedies.com>,
        Mark Wielaard <mark@klomp.org>, stable@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH v9 1/3] vmlinux.lds.h: add DWARF v5 sections
Message-Id: <20210205160034.a0e0ba06752bef03e60f91f8@linux-foundation.org>
In-Reply-To: <20210205202220.2748551-2-ndesaulniers@google.com>
References: <20210205202220.2748551-1-ndesaulniers@google.com>
        <20210205202220.2748551-2-ndesaulniers@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  5 Feb 2021 12:22:18 -0800 Nick Desaulniers <ndesaulniers@google.com> wrote:

> We expect toolchains to produce these new debug info sections as part of
> DWARF v5. Add explicit placements to prevent the linker warnings from
> --orphan-section=warn.
> 
> Compilers may produce such sections with explicit -gdwarf-5, or based on
> the implicit default version of DWARF when -g is used via DEBUG_INFO.
> This implicit default changes over time, and has changed to DWARF v5
> with GCC 11.
> 
> .debug_sup was mentioned in review, but without compilers producing it
> today, let's wait to add it until it becomes necessary.
> 

There isn't anything in this changelog which explains why a -stable
backport was requested?  Or is there?  Irritating linker warnings? 
More than that?

