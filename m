Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5516E6880
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 17:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjDRPqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 11:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjDRPp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 11:45:59 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E5BCC36
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:45:22 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id y21so10717568ual.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681832721; x=1684424721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L4xuHYnJcIADbZVCzqNAa7tRE/8fKfDvfp8oWIUoQkA=;
        b=vVrNiKKrFvSjmYjIYlffX2yP80cNVa3eT1BEDGMSrZdkz8HmxfzQCdlfmAjQA6zTiX
         XjIhliOPyuCLMWmXY0ASaWCusMWydjVVSZa+y+UBpfMSs//0q+JSQIbAnpmI4vPhNRkM
         qbD/0TKOIncXTZRcr2oLDLWyYCzS4WSMjwTChiT9qzXfi0hxzRY93BTsW0Qb3EHZLfVd
         hgDGyMHpUItvwfkauS3kE0bOJholTpusKn9eft0WharB0k8vXuQz6hNrcXJG5uwkJa7U
         YKj0mIDCLEKhCrsoXqmzkZ0IwrXOLROTJvlxTEpAT4M9ItB8j8jWU8gCGGfFJ9Cs8M9M
         w4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832721; x=1684424721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4xuHYnJcIADbZVCzqNAa7tRE/8fKfDvfp8oWIUoQkA=;
        b=VvOY0sMzVJe/1FAOCDFij6qEzEEFLX2nKLngcOYRDZzPAcB3QqugkmXWc5nSrS37VQ
         JrGNVajbCCezmvmXOa0k5kDBl3daVMKMH1E/Vty0GNDyX1JgTeS6t055vEPqmjvSouf0
         U5wjwUFPzWDRZGAsJCT9BCUF332Z0G92vYBJuShLic4Gk2pBoCxYJZnMjq6GZ4WOLEzh
         KjRGCm3wrHzGbbU21oE4c0CCemRs4cETxNV5i88na9m+uhQqI+Uh/mbFd3UlDNDdvcBL
         tUS7x6p2Ig7u+uTBdV/ASPrjbFwBmF9nD3bqVQ6K8tNrD29mxx/1gM0l3aO9nY/41ZoU
         IWBQ==
X-Gm-Message-State: AAQBX9eSo3kqqTdWBROgmwpgQZ2NHgOjF9I0f88lFzQxMIr+RWbcdNGk
        rp+D9V+tKDCmN++wbWKoK01L1b2C4QLrzwFC7IoM9KkLAMHWHawy16o=
X-Google-Smtp-Source: AKy350bueRFhEfd8rpuE8PRIsAQFBVm9kpzb9vt+uVxvuzLomJF9oo3kckUH3tqFEAz3Iej1mogFesld2Lb7iWxbRKY=
X-Received: by 2002:a1f:5f81:0:b0:43c:ac58:3020 with SMTP id
 t123-20020a1f5f81000000b0043cac583020mr5990756vkb.3.1681832721233; Tue, 18
 Apr 2023 08:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120309.539243408@linuxfoundation.org> <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <2023041819-canyon-unarmored-38c6@gregkh>
In-Reply-To: <2023041819-canyon-unarmored-38c6@gregkh>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Apr 2023 21:15:09 +0530
Message-ID: <CA+G9fYuSwpBW-_PubGFYsKi08=KrmsR=g9D4HDOvZP5pd4t0MQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 21:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
> > On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.178 release.
> > > There are 124 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Following build errors noticed on 5.15 and 5.10.,
> >
> >
> > > Waiman Long <longman@redhat.com>
> > >     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
> >
>
> That's a documentation patch, it can not:

Sorry for my mistake in trimming the email at the wrong place.

I have pasted down of the email as this suspected patch,

cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.


> > kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> > kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> > (first use in this function); did you mean 'cgroup_put'?
> >  2941 |         lockdep_assert_held(&cgroup_mutex);
>
> Cause this.
>
> What arch is failing here?  This builds for x86.

Not for me.

List of regression builds.

Regressions found on x86_64:
 - build/gcc-12-defconfig

Regressions found on i386:
 - build/gcc-12-defconfig
 - build/gcc-11-lkftconfig

Regressions found on arm64:
 - build/gcc-11-lkftconfig

Regressions found on arm:
 - build/gcc-12-vexpress_defconfig
 - build/gcc-8-vexpress_defconfig

Regressions found on mips:
 - build/gcc-8-defconfig
 - build/gcc-12-defconfig


For 5.10 defconfigs failed,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.176-298-g19b9d9b9f62e/testrun/16291316/suite/build/test/gcc-12-defconfig/history/


For 5.15 defconfigs failed,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.105-280-g0b6a5617247c/testrun/16291199/suite/build/test/gcc-12-defconfig/history/


- Naresh
