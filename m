Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17B5D2535A
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfEUPC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 11:02:57 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:37507 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbfEUPC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 11:02:56 -0400
Received: by mail-it1-f196.google.com with SMTP id m140so5188204itg.2
        for <stable@vger.kernel.org>; Tue, 21 May 2019 08:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aXGZlwZ2utpr5fuCxQ1nwKS/KyyL22WxIEG+biDA5Fk=;
        b=zKFYFWcdGJPTep5yVlaByZqDz4Dsi4C/RTBpJ6d1qCT6RerXGP7iqtkdCSKuShpi8C
         cqoPPmd3f9grUiCdU0hFlwOQuRVmBcn7e/aiyQ/7dDY6OZzhNDB3JL1K+zWrhxTczlgk
         Jvi08OoVhDB+4FJ44GU5yEqXDtUqpg5cUFURDKzIFpT7saDPae54WUN3W2wZqoUQGZq6
         h6G+4M5TsWO0z0VFjOqswy6E5c3+pgKVf69Mne5Py+K33rqSG1p5y3CLRYnpX9zfK/XO
         NU4SSuAOF+pwIOpj8fgPqHOziw91Zbo62fN8irBpktjZqobbdNLwZLIvltCSYg9durzA
         G8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=aXGZlwZ2utpr5fuCxQ1nwKS/KyyL22WxIEG+biDA5Fk=;
        b=IyzIzzWxLUsvDiznzyZIsVyPs+jWF4KiKJb6k6ALRYC/r0Y6UdPjRo9bDyeOQEszL3
         tGauG08E44pdR/gZ/V865hjOt4HaXB84zFhB/gd+3tegAWjwBAlYG2gU5W5lZgexHe4e
         0aYOrX+y+iCbMt/clF1oDj71FvEsx3hTOSiZr/YcvNa8ZAII0MrL9PmiLSZqiRjf+Ca1
         WwYIkz0BVH0chDPNRCSFozZGBlXG2Nl5Ns6jQtHegJir/8MjdUxOIOPU2eMtNtAyKWfH
         bdjSF61lFRXYbSpwur5pRpePJmzoEWXW8PhHKNi1mZ7ekwWdmO+9u3RV4QdXuRAWATwd
         F9Sg==
X-Gm-Message-State: APjAAAUxcvK28keoFetLbPdBowMZpl7PNFswJJd5s0bHzPKx7eSPzIcn
        x+30QuOCn2ZDnog2bzTjxnDVqQ==
X-Google-Smtp-Source: APXvYqybOSduGZ+saGdI5xBZLJnD+XEmDMa3Dfrrjt4EW/+/wagQX/n2F5nZHSso4dIPO8EzjTnxzg==
X-Received: by 2002:a24:aa42:: with SMTP id y2mr4458662iti.23.1558450975703;
        Tue, 21 May 2019 08:02:55 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id z18sm6983012ioi.33.2019.05.21.08.02.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 08:02:54 -0700 (PDT)
Date:   Tue, 21 May 2019 10:02:53 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable
 review)
Message-ID: <20190521150253.coawunplbqjqf4n3@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Shuah Khan <shuah@kernel.org>,
        patches@kernelci.org, Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com>
 <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
 <20190521093849.GA9806@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521093849.GA9806@kroah.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 11:38:49AM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 21, 2019 at 02:58:58PM +0530, Naresh Kamboju wrote:
> > On Tue, 21 May 2019 at 14:30, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, May 20, 2019 at 05:23:42PM -0500, Dan Rue wrote:
> > > > On Mon, May 20, 2019 at 02:13:06PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.19.45 release.
> > > > > There are 105 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> > > > > Anything received after that time might be too late.
> > > >
> > > > We're seeing an ext4 issue previously reported at
> > > > https://lore.kernel.org/lkml/20190514092054.GA6949@osiris.
> > > >
> > > > [ 1916.032087] EXT4-fs error (device sda): ext4_find_extent:909: inode #8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
> > > > [ 1916.073840] jbd2_journal_bmap: journal block not found at offset 4455 on sda-8
> > > > [ 1916.081071] Aborting journal on device sda-8.
> > > > [ 1916.348652] EXT4-fs error (device sda): ext4_journal_check_start:61: Detected aborted journal
> > > > [ 1916.357222] EXT4-fs (sda): Remounting filesystem read-only
> > > >
> > > > This is seen on 4.19-rc, 5.0-rc, mainline, and next. We don't have data
> > > > for 5.1-rc yet, which is presumably also affected in this RC round.
> > > >
> > > > We only see this on x86_64 and i386 devices - though our hardware setups
> > > > vary so it could be coincidence.
> > > >
> > > > I have to run out now, but I'll come back and work on a reproducer and
> > > > bisection later tonight and tomorrow.
> > > >
> > > > Here is an example test run; link goes to the spot in the ltp syscalls
> > > > test where the disk goes into read-only mode.
> > > > https://lkft.validation.linaro.org/scheduler/job/735468#L8081
> > >
> > > Odd, I keep hearing rumors of ext4 issues right now, but nothing
> > > actually solid that I can point to.  Any help you can provide here would
> > > be great.
> > >
> > 
> > git bisect helped me to land on this commit,
> > 
> > # git bisect bad
> > e8fd3c9a5415f9199e3fc5279e0f1dfcc0a80ab2 is the first bad commit
> > commit e8fd3c9a5415f9199e3fc5279e0f1dfcc0a80ab2
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Tue Apr 9 23:37:08 2019 -0400
> > 
> >     ext4: protect journal inode's blocks using block_validity
> > 
> >     commit 345c0dbf3a30872d9b204db96b5857cd00808cae upstream.
> > 
> >     Add the blocks which belong to the journal inode to block_validity's
> >     system zone so attempts to deallocate or overwrite the journal due a
> >     corrupted file system where the journal blocks are also claimed by
> >     another inode.
> > 
> >     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
> >     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> >     Cc: stable@kernel.org
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > :040000 040000 b8b6ce2577d60c65021e5cc1c3a38b32e0cbb2ff
> > 747c67b159b33e4e1da414b1d33567a5da9ae125 M fs
> 
> Ah, many thanks for this bisection.
> 
> Ted, any ideas here?  Should I drop this from the stable trees, and you
> revert it from Linus's?  Or something else?
> 
> Note, I do also have 170417c8c7bb ("ext4: fix block validity checks for
> journal inodes using indirect blocks") in the trees, which was supposed
> to fix the problem with this patch, am I missing another one as well?
> 
> (side note, it was mean not to mark 170417c8c7bb for stable, when the
> patch it was fixing was marked for stable, I'm lucky I caught it...)

My independent bisection agrees that e8fd3c9a5415 ("ext4: protect
journal inode's blocks using block_validity") is the root cause. I was
able to revert it along with 18b3c1c2827c ("ext4: unsigned int compared
against zero") on 4.19 and then the issue went away.

I tested the same revert on mainline v5.2-rc1 and it fixed the issue
there as well (git revert fbbbbd2f28ae 345c0dbf3a30).

The problem reproduces in our environment 100% of the time, but creating
a reproducer is troublesome; it happens while running LTP syscalls, and
requires some combination of syscall tests to happen. So far, we've been
able to reduce it to the following ltp runfile:
https://gist.github.com/danrue/61c663e1dc50dc7c13a232f0a062bdc6

LTP is run using '/opt/ltp/runltp -d /scratch -f syscalls', where the
syscalls file has been replaced with the version in the gist, and
/scratch is an ext4 SATA drive. /scratch is created using 'mkfs -t ext4
/dev/disk/by-id/ata-TOSHIBA_MG03ACA100_37O9KGKWF' and mounted to
/scratch.

I'll update the gist as we reduce it further.

Dan

-- 
Linaro - Kernel Validation
