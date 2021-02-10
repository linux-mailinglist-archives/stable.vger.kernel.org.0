Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F033170C0
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 20:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhBJT4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 14:56:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232614AbhBJT42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 14:56:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F4A364EEA;
        Wed, 10 Feb 2021 19:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612986947;
        bh=ySOGh/LfDfk0EzIqZMt+l+18yGYgMtEtuEXYBi5g4TA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NZ6ZYISXE7p99BEUvfNFWg2og56folXbUeOyoZ8+kVzAgtDJZ03+I89uh4iqrlRRy
         wM2C9l4aWJRzKKmf+ok848J0AJTyWwt6ew8vnqxJu1GlFrcUUaE9TUtK94YXdsNHCJ
         8yySFz0SyNzlod+AzBQBWQPyjbm7HOIHMGF6VDYlea6MdSW+8HVeFO2Edf7fRjQwOV
         Nj6pRFBYyT+aDuCael3O1mDT42s3EMVULHPdrlyNP+9QKLaIjrKkANbOF5yd3aMh8E
         QpDbZWI82gbDPsSARpuVP3x+QlX+rv4nc5QxC9gLrojopDQJtijBc1PAZSxbBHpouq
         6Bc1tai7xcQCQ==
Received: by mail-ot1-f46.google.com with SMTP id l23so2968977otn.10;
        Wed, 10 Feb 2021 11:55:47 -0800 (PST)
X-Gm-Message-State: AOAM531WjL7YeecWllIsaLrmfoH5pgyWCQJvDwA8FervTAIi+m0l0r4k
        gJ+hNPcq6kk3vOB9mPjreYO3GFOZ6vHDqfaT1qI=
X-Google-Smtp-Source: ABdhPJzFbtRr/UiFKse9DDFj7qK/D6leqlSGTX/krNy8dk6itAmmGB+6zN0Q1h8IBj4DQy1pe/Nkq+znMh4FLhb764M=
X-Received: by 2002:a05:6830:18e6:: with SMTP id d6mr3452163otf.251.1612986946460;
 Wed, 10 Feb 2021 11:55:46 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org> <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
 <YCPgzb1PhtvfUh9y@osiris> <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
In-Reply-To: <CAHk-=wghVA-6aNQz3rwr5VHmJAHkUvGyzKFpsEN1HPB5SL+aQA@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 10 Feb 2021 20:55:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3P6tMpVaLJHwNbp8sEj9+XVh5j4ymNAiXjF6P=noxL-g@mail.gmail.com>
Message-ID: <CAK8P3a3P6tMpVaLJHwNbp8sEj9+XVh5j4ymNAiXjF6P=noxL-g@mail.gmail.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Tuan Hoang1 <Tuan.Hoang1@ibm.com>,
        Debian <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 8:17 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Feb 10, 2021 at 5:39 AM Heiko Carstens <hca@linux.ibm.com> wrote:
> >
> > I couldn't spot any and also gave the patch below a try and my system
> > still boots without any errors.
> > So, as far as I can tell it _should_ be ok to change this.
>
> So your patch (with the fix on top) looks sane to me.
>
> I'm not entirely sure it is worth it, but the fact that we've had bugs
> wrt this before does seem to imply that we should do this.
>
> I'd remove the __kernel_ino_t type entirely, but I wonder if user
> space might depend on it. I do find
>
>    #ifndef __kernel_ino_t
>    typedef __kernel_ulong_t __kernel_ino_t;
>    #endif
>
> in the GNU libc headers I have, but then I don't find any actual use
> of that, so it looks like it may be jyst a "we copied things for other
> reasons".

I checked debian codesearch to see if there are any users in
distro source code and found exactly one instance that will
definitely break at compile time:

https://sources.debian.org/src/nfs-utils/1:1.3.4-4/support/include/nfs/nfs.h/?hl=99#L99

This is a copy of a kernel header that was removed ten years ago
with commit c152292f9ee7 ("nfsd: remove include/linux/nfsd/syscall.h").

The mainline version of that package removed the contents in 2016 in
the following release (2.1.1), but debian is still on the previous
version (1.3.4)
http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=commitdiff;h=fc1127d754578cd1

Someone will have to update the package for Debian, but it seems
that would be a good idea anyway.

      Arnd
