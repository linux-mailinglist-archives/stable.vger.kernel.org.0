Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91C63639E8
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 06:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhDSEEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 00:04:52 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54461 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhDSEEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 00:04:48 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FNtVT5PRGz9vGv; Mon, 19 Apr 2021 14:04:17 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        Laurent Dufour <ldufour@linux.ibm.com>, stable@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Andrei Vagin <avagin@gmail.com>
In-Reply-To: <20210326191720.138155-1-dima@arista.com>
References: <20210326191720.138155-1-dima@arista.com>
Subject: Re: [PATCH] powerpc/vdso: Separate vvar vma from vdso
Message-Id: <161880478605.1398509.2763333717274966533.b4-ty@ellerman.id.au>
Date:   Mon, 19 Apr 2021 13:59:46 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 26 Mar 2021 19:17:20 +0000, Dmitry Safonov wrote:
> Since commit 511157ab641e ("powerpc/vdso: Move vdso datapage up front")
> VVAR page is in front of the VDSO area. In result it breaks CRIU
> (Checkpoint Restore In Userspace) [1], where CRIU expects that "[vdso]"
> from /proc/../maps points at ELF/vdso image, rather than at VVAR data page.
> Laurent made a patch to keep CRIU working (by reading aux vector).
> But I think it still makes sence to separate two mappings into different
> VMAs. It will also make ppc64 less "special" for userspace and as
> a side-bonus will make VVAR page un-writable by debugger (which previously
> would COW page and can be unexpected).
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/vdso: Separate vvar vma from vdso
      https://git.kernel.org/powerpc/c/1c4bce6753857dc409a0197342d18764e7f4b741

cheers
