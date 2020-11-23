Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3552C13DD
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 20:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgKWSuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 13:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbgKWSuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 13:50:04 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EA1C20657;
        Mon, 23 Nov 2020 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606157403;
        bh=kvZDsZCsT70IKJdnC3Il6gC1HEfY+MTZvJtsXIRWU7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TKBoeITIIN/NzEbWlmeXyTDUEhwk65ymgGUIiK8RueheZ9hym00E2Md0Fd1uECx2c
         ex0PlpI6klJIw7fvvCcuhbNNnxLKGol5j6xxacP3Yqyf77kuPS5ZmmCgiZtnUqy6G4
         bDp3Bdircfql0RPPVc3s27kclsCsJrRdy4GT25OA=
Date:   Mon, 23 Nov 2020 19:50:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: Re: [PATCH 5.4 044/158] compiler.h: fix barrier_data() on clang
Message-ID: <X7wEWQsR6N8KMzVI@kroah.com>
References: <20201123121819.943135899@linuxfoundation.org>
 <20201123121822.053682010@linuxfoundation.org>
 <CAKwvOdmX_M6wn-UUO39EqRZNbHCn22dsNND6sZ6q+Tzjyez=7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmX_M6wn-UUO39EqRZNbHCn22dsNND6sZ6q+Tzjyez=7A@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 10:31:10AM -0800, Nick Desaulniers wrote:
> Doesn't this depend on a v2 of
> https://lore.kernel.org/lkml/fe040988-c076-8dec-8268-3fbaa8b39c0f@infradead.org/
> ? Oh, looks like v1 got picked up:
> https://lore.kernel.org/lkml/mhng-8c56f671-512a-45e7-9c94-fa39a80451da@palmerdabbelt-glaptop1/.
> Won't this break RISCV VDSO?

Oops, let me drop this, I did so in the past for 5.9.y and it looks like
Sasha missed that and added the fixed patch to 5.4.y...

thanks,

greg k-h
