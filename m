Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5619C25722
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 19:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfEUR5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 13:57:36 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45024 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729156AbfEUR5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 13:57:35 -0400
Received: by mail-lj1-f195.google.com with SMTP id e13so16647226ljl.11
        for <stable@vger.kernel.org>; Tue, 21 May 2019 10:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=13iR66s35EeUhXp2Ectoi0OYdgpCcLBjgrRmPgISBoM=;
        b=uH9I6b0JCQbUYvD1LQ/glpe/cwjIy5fEvVhCo7mSI3nnWN8qaC32ctzL3bx4y9FHx1
         8b6JffttjvceV7oO33hEAchiQ141RYZOda/yElKfLKngnwq7bfAIT8x1KuEn9d8sZAYm
         ArSJM9+nF6Zm+FJdKPJtCR4kBp/zvoi/e2Rqc+DZAlxoQLLHBSA18HY6yUjTMAWRUX38
         WyPhja20hFXrXImDxpdjqmJTjoSwPIR54QrpmJE3SYs488Csl26LxlYhI5g8PNBDAVuw
         RSQ6ZxhJJqT0VbQ1ZfvEeaXUdXasb0L1jbiXU11exgVIx0Lv+whO/t376N1UiGC9ID/i
         S4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=13iR66s35EeUhXp2Ectoi0OYdgpCcLBjgrRmPgISBoM=;
        b=gckBFhrhYB2Nnhoh0tvAm8kg0cPYD1Tx+Aqjsy0sDVlJmODn7pfhKuoVejh++exgky
         HcwwFh7NtXOo7TkmNpb/2OaOP+pMQPv0Y7Rlms3+byCKIs/SeXVYLW5dEDoLuBDbq31l
         ig6CNTyRYN7/88+1FovQShi/04qDHzpiSDaOBKlAvbEPBaragFc8eTfhnJVZgTyvFz50
         ydjsoyWiOc28YekfW5Mq1wHXAmSF16EBKJcuXbFECUHcPBqw68G7guoqv+raPZN65iZD
         ZlwzJw9leZQ8Iez7fWwzCToOhoJxdisJW0eaDASeyA32h8hzjuHG6C/jGdVEMEgefciL
         3JSg==
X-Gm-Message-State: APjAAAUcasFYxkbAyi4tdOUjMvVk0DaqfnJuivhz0FFeBZk3guMDTrpq
        i8aq2iIuw4mtKWz4nU58oq4pEbeAyxfrPNyYQnp/dA==
X-Google-Smtp-Source: APXvYqxoVhtW6+H2OrjfsFNbhD7UYzdFtNxwmWLYrzO83Xt+JIlW+jv9qAzgJgpe0LduUYpYcryZKFWuLW7FD/A8aw8=
X-Received: by 2002:a2e:7411:: with SMTP id p17mr26016219ljc.24.1558461453024;
 Tue, 21 May 2019 10:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115247.060821231@linuxfoundation.org> <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
 <20190521085956.GC31445@kroah.com> <CA+G9fYvHmUimtwszwo=9fDQLn+MNh8Vq3UGPaPUdhH=dEKzqxg@mail.gmail.com>
 <20190521093849.GA9806@kroah.com> <CA+G9fYveeg_FMsL31aunJ2A9XLYk908Y1nSFw4kwkFk3h3uEiA@mail.gmail.com>
 <20190521162142.GA2591@mit.edu>
In-Reply-To: <20190521162142.GA2591@mit.edu>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 May 2019 23:27:21 +0530
Message-ID: <CA+G9fYunxonkqmkhz+zmZYuMTfyRMVBxn6PkTFfjd8tTT+bzHQ@mail.gmail.com>
Subject: Re: ext4 regression (was Re: [PATCH 4.19 000/105] 4.19.45-stable review)
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Cc:     ltp@lists.linux.it, Jan Stancek <jstancek@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 21 May 2019 at 21:52, Theodore Ts'o <tytso@mit.edu> wrote:
>
> On Tue, May 21, 2019 at 03:58:15PM +0530, Naresh Kamboju wrote:
> > > Ted, any ideas here?  Should I drop this from the stable trees, and you
> > > revert it from Linus's?  Or something else?
>
> It's safe to drop this from the stable trees while we investigate.  It
> was always borderline for stable anyway.  (See below).
>
> > >
> > > Note, I do also have 170417c8c7bb ("ext4: fix block validity checks for
> > > journal inodes using indirect blocks") in the trees, which was supposed
> > > to fix the problem with this patch, am I missing another one as well?
> >
> > FYI,
> > I have applied fix patch 170417c8c7bb ("ext4: fix block validity checks for
> >  journal inodes using indirect blocks") but did not fix this problem.
>
> Hmm... are you _sure_?  This bug was reported to me versus the
> mainline, and the person who reported it confirmed that it did fix the
> problem, he was seeing, and the symptoms are identical to yours.  Can
> you double check, please?  I can't reproduce it either with that patch applied.

This bug is specific to x86_64 and i386.

Steps to reproduce is,
running LTP three test cases in sequence on x86 device.
# cd ltp/runtest
# cat syscalls ( only three test case)
open12 open12
madvise06 madvise06
poll02 poll02
#

as Dan referring to,

LTP is run using '/opt/ltp/runltp -d /scratch -f syscalls', where the
syscalls file has been replaced with three test case names, and
/scratch is an ext4 SATA drive. /scratch is created using 'mkfs -t ext4
/dev/disk/by-id/ata-TOSHIBA_MG03ACA100_37O9KGKWF' and mounted to
/scratch.

Please find full test log,
https://lkft.validation.linaro.org/scheduler/job/738661#L1356

And you notice dmesg log,
[   53.897001] EXT4-fs error (device sda): ext4_find_extent:909: inode
#8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent
entries - magic f30a, entries 8, max 340(340), depth 0(0)
[   53.931430] jbd2_journal_bmap: journal block not found at offset 49 on sda-8
[   53.938480] Aborting journal on device sda-8.
[   55.431382] EXT4-fs error (device sda):
ext4_journal_check_start:61: Detected aborted journal
[   55.439947] EXT4-fs (sda): Remounting filesystem read-only

- Naresh
