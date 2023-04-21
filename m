Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83616EA588
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 10:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjDUIFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 04:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjDUIE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 04:04:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38869903B;
        Fri, 21 Apr 2023 01:04:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 963E721A36;
        Fri, 21 Apr 2023 08:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682064290;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5StWWj+w1KUl4+HyVtWVGj32yDGQYLskTdzziZvHcn0=;
        b=tBma7/5H8UACRRP4uhvJ1XFPn0cH5j87T3qGW5EBO+mjIS+UpgC6Kp9CbIvkuVFxcv3HmV
        mpHfUxgxr0jYLovLDfdbyF2fd6WThEelBW3YH29mk338JQ93PhOwS/7vjbaOXtNMkUr/ay
        TaVk9Jd3URPZ+G/Nd/RK5XnhqPwimCY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682064290;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5StWWj+w1KUl4+HyVtWVGj32yDGQYLskTdzziZvHcn0=;
        b=pGOhMt1TaBvJ2SFwx/cL7Fyxn0YXubuwyXUcqKRDAcHN9jWU1b/vMviKlXpPOJNcY8f2Gm
        gzSYk5p9bYsSTACQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F09DB1390E;
        Fri, 21 Apr 2023 08:04:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FPpMOaFDQmQUJAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Fri, 21 Apr 2023 08:04:49 +0000
Date:   Fri, 21 Apr 2023 10:04:55 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        LTP List <ltp@lists.linux.it>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Yang Xu <xuyang2018.jy@fujitsu.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Message-ID: <20230421080455.GB2747101@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20230418120304.658273364@linuxfoundation.org>
 <CA+G9fYuT3N0LFaJGzQW2SYPJxEbEWLONDZO2OfBbeHNrsowy2w@mail.gmail.com>
 <ZD+fDeWVOXklD01f@yuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD+fDeWVOXklD01f@yuki>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Hi!
> > > This is the start of the stable review cycle for the 5.4.241 release.
> > > There are 92 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.

> > > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > > Anything received after that time might be too late.

> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.

> > > thanks,

> > > greg k-h


> > Recently we have upgraded the LTP test suite version and started noticing
> > these test failures on 5.4.
> > Test getting skipped on 4.19 and 4.14 as not supported features.

> > Need to investigate test case issues or kernel issues.

> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> > NOTE:

> > ---
> > creat09.c:73: TINFO: User nobody: uid = 65534, gid = 65534
> > creat09.c:75: TINFO: Found unused GID 11: SUCCESS (0)
> > creat09.c:120: TINFO: File created with umask(0)
> > creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
> > creat09.c:112: TPASS: mntpoint/testdir/creat.tmp: Setgid bit not set
> > creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
> > creat09.c:112: TPASS: mntpoint/testdir/open.tmp: Setgid bit not set
> > creat09.c:120: TINFO: File created with umask(S_IXGRP)
> > creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
> > creat09.c:110: TFAIL: mntpoint/testdir/creat.tmp: Setgid bit is set
> > creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
> > creat09.c:110: TFAIL: mntpoint/testdir/open.tmp: Setgid bit is set

> > Test history links,
> >  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16338751/suite/ltp-syscalls/test/creat09/history/
> >  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16337895/suite/ltp-cve/test/cve-2018-13405/history/
> >  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16338751/suite/ltp-syscalls/test/creat09/log

> That's likely a missing kernel patch, as this is a regression test there
> should have been links to the patches and CVE referencies in the test
> output as the test is tagged with kernel commits and CVE numbers:

>         .tags = (const struct tst_tag[]) {
>                 {"linux-git", "0fa3ecd87848"},
>                 {"CVE", "2018-13405"},
>                 {"CVE", "2021-4037"},
>                 {"linux-git", "01ea173e103e"},
Only this one has been backported (as
e76bd6da51235ce86f5a8017dd6c056c76da64f9), the other two are missing.
>                 {"linux-git", "1639a49ccdce"},
>                 {"linux-git", "426b4ca2d6a5"},
The last one is merge tag, I wonder if it's correct:
426b4ca2d6a5 ("Merge tag 'fs.setgid.v6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux")
Maybe just 1639a49ccdce would be ok.

@Yang Xu
1) why 1639a49ccdce has not been merged to stable tree? It does not apply now,
was that the only reason? Or is it not applicable?

@Yang Xu is really 426b4ca2d6a5 needed? Was it easier to list merge commit than
particular fixes? Merge commit contains:

5fadbd992996 ("ceph: rely on vfs for setgid stripping")
1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
ac6800e279a2 ("fs: Add missing umask strip in vfs_tmpfile")
2b3416ceff5e ("fs: add mode_strip_sgid() helper")

They have not been backported to 5.4 stable, nor to the older releases.
Again, they don't apply.


>                 {}
>         },

> > ---

> > fanotify14.c:161: TCONF: FAN_REPORT_TARGET_FID not supported in kernel?
> > fanotify14.c:157: TINFO: Test case 7: fanotify_init(FAN_CLASS_NOTIF |
> > FAN_REPORT_TARGET_FID | FAN_REPORT_DFID_FID, O_RDONLY)
> > fanotify14.c:161: TCONF: FAN_REPORT_TARGET_FID not supported in kernel?
> > [  377.081993] EXT4-fs (loop0): mounting ext3 file system using the
> > ext4 subsystem
> > fanotify14.c:157: TINFO: Test case 8: fanotify_init(FAN_CLASS_NOTIF |
> > FAN_REPORT_DFID_FID, O_RDONLY)
> > [  377.099137] EXT4-fs (loop0): mounted filesystem with ordered data
> > mode. Opts: (null)
> > fanotify14.c:175: TFAIL: fanotify_init(tc->init.flags, O_RDONLY)
> > failed: EINVAL (22)

> Possibly like the test may be missing check for a FAN_REPORT_DFID_FID
> support.

@Amir could you please look at this fanotify14.c failure on 5.4.241-rc1?

Kind regards,
Petr
