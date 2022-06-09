Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15739544C9C
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiFIMvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 08:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343534AbiFIMvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 08:51:53 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5758BD572E
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 05:51:50 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-30ec2aa3b6cso239511417b3.11
        for <stable@vger.kernel.org>; Thu, 09 Jun 2022 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4afj7Puirir/0/e//ltntSfmYEZ3ENBCv+Yk5IK4kr4=;
        b=RqNdubTcUIgzg7tBBUlmM3DuzMa0s5W+x/LPK3GQU9I28/1sGXWkz3Pg2H7yxQmpBl
         OamtGhtcH13Cg6qikfTFZG5Zpm5Mt6/5SVb3QQhHU3ifKNJ6XmGoDYF21TOnF49T2TjL
         aiS2sX0zwVkoeVxCncruKCSU4hjnZJTjAvFt7WWuSjbJoG2pXzGSAOFcZb4dy5e+1kAU
         geh83B2fBIJdjpJBdo1rl0pdZFMnHbBnnSuqt0wJKTLmKYHUiIhWScUZJIcajXK5q49y
         a/jpQac4uplgaHbV0B4sa9Ia0ZqGDjxqYvW0Ooq3OtORklug/pYhMgSjUzSW9bM0nOcI
         D8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4afj7Puirir/0/e//ltntSfmYEZ3ENBCv+Yk5IK4kr4=;
        b=hibqd9VTuAj+6o43Yxpj9/KFm8Y08bhn/Jncjo87uDX2GMR6mh7u/7M6dQJaoJV7T6
         fWeposP8TY7ok9dxAEG1zc5WwOv5llxoDvrmqzEWWKQrlaQwxB+/R00JMrOEaLiT+5BA
         zp25a1pGAwkQFURYUkKDJK0IUMwnKl4apYNCBVdUsL2UiLULQGf8+oKwohkG0xjtxNHp
         73r3TAAGXiivw50++hpOUeove2r1tDBE8jXu+uUmH69WUlR87qmES+F+yMB+7dqMXEFK
         XDTcc+W72PPcz+O+ELvPuDr1+F2sk/G9hJFFEcPgTdg3cX6HFCm1IAJs2tEbMcpggywm
         y3Bg==
X-Gm-Message-State: AOAM531/CadwFbXJMQeoINmTyN7uA3QwQs0KfQffSxhrIi50TPAb28rR
        Id/tXpjjdCPcpU6c5oOgLIhwIRc5ORxZ4xbfEeNlbA==
X-Google-Smtp-Source: ABdhPJy8nNzH3FGt6T2lPVdz5Vpj4GhKa37WfdGfdFim8BKk6GF6dUpwGX5W8SUsbHDiE+7bYRplRpdRWmido6CIpEw=
X-Received: by 2002:a81:b343:0:b0:300:4822:e12 with SMTP id
 r64-20020a81b343000000b0030048220e12mr43195108ywh.376.1654779109344; Thu, 09
 Jun 2022 05:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220607164948.980838585@linuxfoundation.org> <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
In-Reply-To: <CA+G9fYui20CoDeqa6OrCYB+CGpgoFkhXtkdMDFJd1H55efCm6Q@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 9 Jun 2022 18:21:37 +0530
Message-ID: <CA+G9fYt47PBfbOK77eiH3qP2QH0iWQ=p12NELpL+R_k7O678=g@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/772] 5.17.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        kunit-dev@googlegroups.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jun 2022 at 19:24, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> On Tue, 7 Jun 2022 at 23:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.17.14 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.17.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.17.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
>
> Regressions found on qemu_x86_64:
>   - kunit/kasan [1]
>
> Regressions found on qemu_i386:
>   - kunit/kfence [2]
>   - kunit/test_out_of_bounds_read
>
> We will bisect and let you know more details about this reported problem.

The bisect script pointed me to this commit and  reverted and tested and
confirmed.

commit 1883088ed4a0d5cc9cea500ca4e89a354ab32c11
Author: Jia-Ju Bai <baijiaju1990@gmail.com>
Date:   Fri May 27 23:28:18 2022 +0800

    md: bcache: check the return value of kzalloc() in detached_dev_do_requ=
est()

    commit 40f567bbb3b0639d2ec7d1c6ad4b1b018f80cf19 upstream.

    The function kzalloc() in detached_dev_do_request() can fail, so its
    return value should be checked.

    Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached
bcache devices")
    Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
    Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
    Signed-off-by: Coly Li <colyli@suse.de>
    Link: https://lore.kernel.org/r/20220527152818.27545-4-colyli@suse.de
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c1..673a680240a9 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct
bcache_device *d, struct bio *bio,
         * which would call closure_get(&dc->disk.cl)
         */
        ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+       if (!ddip) {
+               bio->bi_status =3D BLK_STS_RESOURCE;
+               bio->bi_end_io(bio);
+               return;
+       }
+
        ddip->d =3D d;
        /* Count on the bcache device */
        ddip->orig_bdev =3D orig_bdev;



> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build=
/v5.17.13-773-gd0f9b2818e1e/testrun/10038101/suite/kunit/test/kasan/details=
/
> [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build=
/v5.17.13-773-gd0f9b2818e1e/testrun/10038215/suite/kunit/test/kfence/detail=
s/
>
> ## Build
> * kernel: 5.17.14-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-5.17.y
> * git commit: d0f9b2818e1e4d43847e10d6e5310a0c653cb18f
> * git describe: v5.17.13-773-gd0f9b2818e1e
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.17.y/build/v5.=
17.13-773-gd0f9b2818e1e
>
> ## Test Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
> Regressions found on qemu_x86_64:
>   - kunit/kasan [1]
>
> Regressions found on qemu_i386:
>   - kunit/kfence [2]
>   - kunit/test_out_of_bounds_read
>
> ## Metric Regressions (compared to v5.17.11-188-g8eb69e8f0d45)
> No metric regressions found.
>
> ## Test Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
> No test fixes found.
>
> ## Metric Fixes (compared to v5.17.11-188-g8eb69e8f0d45)
> No metric fixes found.
>
> ## Test result summary
> total: 134591, pass: 121555, fail: 447, skip: 11730, xfail: 859
>
> ## Build Summary
> * arm: 17 total, 14 passed, 3 failed
> * arm64: 20 total, 20 passed, 0 failed
> * i386: 17 total, 12 passed, 5 failed
> * mips: 4 total, 1 passed, 3 failed
> * parisc: 2 total, 2 passed, 0 failed
> * powerpc: 5 total, 2 passed, 3 failed
> * riscv: 5 total, 5 passed, 0 failed
> * s390: 5 total, 2 passed, 3 failed
> * sh: 2 total, 0 passed, 2 failed
> * sparc: 2 total, 2 passed, 0 failed
> * x86_64: 20 total, 20 passed, 0 failed
>
> ## Test suites summary
> * fwts
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-cap_bounds-tests
> * ltp-commands
> * ltp-commands-tests
> * ltp-containers
> * ltp-containers-tests
> * ltp-controllers-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto
> * ltp-crypto-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps
> * ltp-filecaps-tests
> * ltp-fs
> * ltp-fs-tests
> * ltp-fs_bind
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple
> * ltp-fs_perms_simple-tests
> * ltp-fsx
> * ltp-fsx-tests
> * ltp-hugetlb
> * ltp-hugetlb-tests
> * ltp-io
> * ltp-io-tests
> * ltp-ipc
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-nptl
> * ltp-nptl-tests
> * ltp-open-posix-tests
> * ltp-pty
> * ltp-pty-tests
> * ltp-sched-tests
> * ltp-securebits
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * ltp-tracing-tests
> * network-basic-tests
> * packetdrill
> * perf
> * rcutorture
> * ssuite
> * v4l2-compliance
> * vdso
>
> --
> Linaro LKFT
> https://lkft.linaro.org
