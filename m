Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7F369048F
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBIKYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBIKYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D379266EDB;
        Thu,  9 Feb 2023 02:24:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A3016195B;
        Thu,  9 Feb 2023 10:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5782CC433EF;
        Thu,  9 Feb 2023 10:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675938243;
        bh=qTSxkPD3QcM5DcX5h7N2ipkmgP1aWhs5Aq6TYFHj180=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nsXmbcx4rleMJ9bZigroeLRiTj7YHoQTL4XXqCL/duHufSN++c7/v42+Hp0ExknGW
         kA2C5ZFZuB5hYyElhHe0MsgZE1+z0oVnMPRDyBd+YEzOYvxNLWbncpayuEmllkm8DU
         Mw/7XGqONMA1m3LRpZo1POASFfs5GnMoBhALiyR0=
Date:   Thu, 9 Feb 2023 11:24:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jann Horn <jannh@google.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+TJwTVFIYBxELwo@kroah.com>
References: <20230207125634.292109991@linuxfoundation.org>
 <CA+G9fYtgJX507GJ3fG7-G+vGhG4BnU=kzu3fOH_a-_aMU0S_0w@mail.gmail.com>
 <Y+KJyTsiio0XMQJ+@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+KJyTsiio0XMQJ+@x1n>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 12:26:33PM -0500, Peter Xu wrote:
> On Tue, Feb 07, 2023 at 10:35:19PM +0530, Naresh Kamboju wrote:
> > On Tue, 7 Feb 2023 at 18:29, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.11 release.
> > > There are 208 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Results from Linaro’s test farm.
> > Following build regressions noticed while building
> > selftests/vm/hugetlb-madvise.c
> > with kselftest-merge configs.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build errors:
> > ----------
> > hugetlb-madvise.c:242:13: warning: implicit declaration of function
> > 'fallocate'; did you mean 'alloca'? [-Wimplicit-function-declaration]
> >   242 |         if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
> >       |             ^~~~~~~~~
> >       |             alloca
> > hugetlb-madvise.c:289:27: error: 'FALLOC_FL_PUNCH_HOLE' undeclared
> > (first use in this function)
> >   289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> >       |                           ^~~~~~~~~~~~~~~~~~~~
> > hugetlb-madvise.c:289:27: note: each undeclared identifier is reported
> > only once for each function it appears in
> > hugetlb-madvise.c:289:50: error: 'FALLOC_FL_KEEP_SIZE' undeclared
> > (first use in this function)
> >   289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> >       |                                                  ^~~~~~~~~~~~~~~~~~~
> > make[3]: *** [../lib.mk:145:
> > /home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/vm/hugetlb-madvise]
> > Error 1
> > 
> > Build log:
> > https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/3728198425#L1676
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2LPeQeCIu0YEfltwqAFCvDaj29A/
> 
> I think we should drop the patch "[PATCH 6.1 012/208] selftests/vm: remove
> __USE_GNU in hugetlb-madvise.c" from this merge.
> 
> That patch fixes commit 62f33fa22800 ("selftests/vm: use memfd for
> hugetlb-madvise test"), but that's only in 6.2-rc1 and it's not in 6.1.
> 
> I don't really know why it got picked for 6.1 stable backport, because the
> original patch doesn't contain "CC: stable".

Now dropped, thanks!

greg k-h
