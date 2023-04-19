Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6969B6E73F2
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 09:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDSHY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 03:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjDSHYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 03:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C7C7297;
        Wed, 19 Apr 2023 00:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14D4363BD6;
        Wed, 19 Apr 2023 07:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE019C433EF;
        Wed, 19 Apr 2023 07:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681889069;
        bh=NtB/YaSSbFgtba63lvz2IrrEcg0B/LAISTt/boARlY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gukPGyPDjS0gQhYVPWX6QqeCDNEnfxeDNgmD68fJPort6oofFcDGyjB4Hzl74Io7X
         2XHN840fKdDWSdmOKdRzRoSmIrLWtNzfxXRfVREIQXIZXxsjt2asIGhxctLH4jAbpe
         j2+uT1E1s37vKiYtOl4wUVG2/ai+7vvWpMeu2HmE=
Date:   Wed, 19 Apr 2023 09:24:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <2023041959-ammonia-subheader-0bce@gregkh>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 08:17:12PM +0530, Naresh Kamboju wrote:
> On Tue, 18 Apr 2023 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.108 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Following patch causing build break on stable-rc 5.15
> 
> 
> > Waiman Long <longman@redhat.com>
> >     cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> 
> cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build error:
> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> kernel/cgroup/cpuset.c:2979:30: error: 'cgroup_mutex' undeclared
> (first use in this function); did you mean 'cgroup_put'?
>  2979 |         lockdep_assert_held(&cgroup_mutex);
>       |                              ^~~~~~~~~~~~
> include/linux/lockdep.h:415:61: note: in definition of macro
> 'lockdep_assert_held'
>   415 | #define lockdep_assert_held(l)                  do {
> (void)(l); } while (0)
>       |                                                             ^
> kernel/cgroup/cpuset.c:2979:30: note: each undeclared identifier is
> reported only once for each function it appears in
>  2979 |         lockdep_assert_held(&cgroup_mutex);
>       |                              ^~~~~~~~~~~~
> include/linux/lockdep.h:415:61: note: in definition of macro
> 'lockdep_assert_held'
>   415 | #define lockdep_assert_held(l)                  do {
> (void)(l); } while (0)
>       |                                                             ^
> make[3]: *** [scripts/Makefile.build:289: kernel/cgroup/cpuset.o] Error 1
> 
> 
> build log:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.105-280-g0b6a5617247c/testrun/16291026/suite/build/test/gcc-11-lkftconfig-kunit/log
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

I've now dropped the offending patches and pushed out -rc2 releases for
this, and the 5.10.y tree.

thanks,

greg k-h
