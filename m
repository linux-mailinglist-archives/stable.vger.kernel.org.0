Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4814E2F516E
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 18:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbhAMRvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 12:51:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbhAMRvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 12:51:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B7821534;
        Wed, 13 Jan 2021 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610560269;
        bh=GCHM+tMvgF8JkEdJGt25/Nt0ID3tcKwPVVPXCHvpn2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSVH9q3lBCNXG3v4gRRWPyBw0/6z2LC1j/yREM9i5+0jlDcvs6Yxppq5ih0SDQODT
         uhAoR5SCvCQ4y8VxxOLQy7DhfS1Y6zjnNWsPrHapqPVc3aeCXTLJYk84khV3SZ7gzT
         HwOMZNwAzyAUksEnpFubRDvESrvnolOfakuoEIzp0gIw7G8BC1T5fspUteTeC1Yr+L
         yzHIU6d6HlpeBkHEy4NmwYXZ5sPyA58QYI/R3fr5jEGmIotrbwhuoW6Xqq3l/jNXJf
         D/2WQJOYtkBFNL0cAXY7O2jsyjHHx1l0UrpbJoDLPIkf9yNYx7NBPq4oK+YZL4Qr6A
         ZaG8YP8eSLA2g==
Date:   Wed, 13 Jan 2021 12:51:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alistair Delva <adelva@google.com>
Subject: Re: 78762b0e79bc for linux-5.4.y
Message-ID: <20210113175107.GT4035784@sasha-vm>
References: <CAKwvOd=F_wWLxhnV3J8jx1L3SXPd8NFYyOKzAh7rL0iRb_aNyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=F_wWLxhnV3J8jx1L3SXPd8NFYyOKzAh7rL0iRb_aNyA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 03:41:37PM -0800, Nick Desaulniers wrote:
>Please consider applying the following patch for LLVM_IAS=1 support
>for Android's i386 cuttlefish virtual device:
>commit 78762b0e79bc ("x86/asm/32: Add ENDs to some functions and
>relabel with SYM_CODE_*")
>which first landed in v5.5-rc1.
>
>There was a small conflict in arch/x86/xen/xen-asm_32.S due to the
>order of backports that was trivial to resolve.  You can see the list
>of commits to it in linux-5.7.y:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/arch/x86/xen/xen-asm_32.S?h=linux-5.7.y
>as arch/x86/xen/xen-asm_32.S was removed in
>commit a13f2ef168cb ("x86/xen: remove 32-bit Xen PV guest support") in v5.9-rc1.

Queued up, thanks!

-- 
Thanks,
Sasha
