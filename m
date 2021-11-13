Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B0B44F35D
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhKMNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhKMNjR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:39:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1538A61051;
        Sat, 13 Nov 2021 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636810584;
        bh=gSETIOX28EOLQVh/kVpLdv0a8DgmohpdC3f5F32o1BE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twfXlkhJKoHSFeFIrjgE8Bp3vioKfx6bZCF2G2sMLEyst2dChKi8J99YN8/3t7hRu
         4I5yrw6kUmSVBb4cdIsemLhdtr7Ted4PxQuSczcSnBIlSzO9CbSL+LX3mb/1zZ2tey
         noFdsY+NTI4tzSMV5WTZWmnQiUhSvNpgQUPPAydg=
Date:   Sat, 13 Nov 2021 14:36:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tim Lewis <elatllat@gmail.com>
Cc:     Yang Shi <shy828301@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        f.fainelli@gmail.com, torvalds@linux-foundation.org,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        jonathanh@nvidia.com, shuah@kernel.org, linux@roeck-us.net,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY+/Vn3np8OGkfBz@kroah.com>
References: <CA+3zgmuJ5a_==NkV+x_JFr=zGN+FyUADot4mwNjJO=P4Q+VjZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+3zgmuJ5a_==NkV+x_JFr=zGN+FyUADot4mwNjJO=P4Q+VjZA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 13, 2021 at 08:19:12AM -0500, Tim Lewis wrote:
> > commit 8615ff6dd1ac9e01b6fcf0fc0652353f79f524ed
> > Author: Yang Shi <shy828301@gmail.com>
> > Date:   Thu Oct 28 14:36:11 2021 -0700
> >
> >     mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
> >
> >     commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream.
> 
> For the sake of testing,
> other than this breaking systemd-journal,
> postgresql is another service that would hang forever with 100% CPU,
> on arm64 (odroid-c4) using Ubuntu 20.04.

Thanks, this commit was dropped from this release.

greg k-h
