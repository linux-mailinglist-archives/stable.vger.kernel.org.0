Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0A16E7481
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDSH5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDSH5F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:57:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6A2A8;
        Wed, 19 Apr 2023 00:57:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EDD5021905;
        Wed, 19 Apr 2023 07:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681891022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cD0t6NezfCDx0oKUGN4T+tmhx6pXCtbhV9oaU4kpHdY=;
        b=EPo0mk3BYne87vJI2zTBTtu9HzS4K8UbNwODrdDrEwQJGbnYjH3YQTJx4RWm4FFRnOCoww
        a9QvMkMj7anBtRkY0XyvEgzQZSjaaA6G9nFXIvmFRp2KtO3dTF9nt6Cc2dmQWxTbNQCmIs
        K1rSdWq9+rcLTqbeZcDXns+lwZ/YlOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681891022;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cD0t6NezfCDx0oKUGN4T+tmhx6pXCtbhV9oaU4kpHdY=;
        b=+gYItwCqq24saD8UfWri5YBsxgw894Q6hcBVfdc0fyTmvyoLsJxZ4eF2YY54L5w+xyvX2q
        EyI2j8KhVW4BrrAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8357B1390E;
        Wed, 19 Apr 2023 07:57:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UooJIM6eP2QlVAAAMHmgww
        (envelope-from <chrubis@suse.cz>); Wed, 19 Apr 2023 07:57:02 +0000
Date:   Wed, 19 Apr 2023 09:58:05 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        LTP List <ltp@lists.linux.it>, Petr Vorel <pvorel@suse.cz>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Message-ID: <ZD+fDeWVOXklD01f@yuki>
References: <20230418120304.658273364@linuxfoundation.org>
 <CA+G9fYuT3N0LFaJGzQW2SYPJxEbEWLONDZO2OfBbeHNrsowy2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuT3N0LFaJGzQW2SYPJxEbEWLONDZO2OfBbeHNrsowy2w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!
> > This is the start of the stable review cycle for the 5.4.241 release.
> > There are 92 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Recently we have upgraded the LTP test suite version and started noticing
> these test failures on 5.4.
> Test getting skipped on 4.19 and 4.14 as not supported features.
> 
> Need to investigate test case issues or kernel issues.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> 
> ---
> creat09.c:73: TINFO: User nobody: uid = 65534, gid = 65534
> creat09.c:75: TINFO: Found unused GID 11: SUCCESS (0)
> creat09.c:120: TINFO: File created with umask(0)
> creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
> creat09.c:112: TPASS: mntpoint/testdir/creat.tmp: Setgid bit not set
> creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
> creat09.c:112: TPASS: mntpoint/testdir/open.tmp: Setgid bit not set
> creat09.c:120: TINFO: File created with umask(S_IXGRP)
> creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
> creat09.c:110: TFAIL: mntpoint/testdir/creat.tmp: Setgid bit is set
> creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
> creat09.c:110: TFAIL: mntpoint/testdir/open.tmp: Setgid bit is set
> 
> Test history links,
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16338751/suite/ltp-syscalls/test/creat09/history/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16337895/suite/ltp-cve/test/cve-2018-13405/history/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.238-199-g230f1bde44b6/testrun/16338751/suite/ltp-syscalls/test/creat09/log

That's likely a missing kernel patch, as this is a regression test there
should have been links to the patches and CVE referencies in the test
output as the test is tagged with kernel commits and CVE numbers:

        .tags = (const struct tst_tag[]) {
                {"linux-git", "0fa3ecd87848"},
                {"CVE", "2018-13405"},
                {"CVE", "2021-4037"},
                {"linux-git", "01ea173e103e"},
                {"linux-git", "1639a49ccdce"},
                {"linux-git", "426b4ca2d6a5"},
                {}
        },

> ---
> 
> fanotify14.c:161: TCONF: FAN_REPORT_TARGET_FID not supported in kernel?
> fanotify14.c:157: TINFO: Test case 7: fanotify_init(FAN_CLASS_NOTIF |
> FAN_REPORT_TARGET_FID | FAN_REPORT_DFID_FID, O_RDONLY)
> fanotify14.c:161: TCONF: FAN_REPORT_TARGET_FID not supported in kernel?
> [  377.081993] EXT4-fs (loop0): mounting ext3 file system using the
> ext4 subsystem
> fanotify14.c:157: TINFO: Test case 8: fanotify_init(FAN_CLASS_NOTIF |
> FAN_REPORT_DFID_FID, O_RDONLY)
> [  377.099137] EXT4-fs (loop0): mounted filesystem with ordered data
> mode. Opts: (null)
> fanotify14.c:175: TFAIL: fanotify_init(tc->init.flags, O_RDONLY)
> failed: EINVAL (22)

Possibly like the test may be missing check for a FAN_REPORT_DFID_FID
support.

-- 
Cyril Hrubis
chrubis@suse.cz
