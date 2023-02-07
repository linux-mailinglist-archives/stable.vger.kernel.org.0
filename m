Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F062568DE74
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 18:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjBGRFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 12:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGRFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 12:05:33 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B492703
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:05:31 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id m1so15101708vst.7
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy30Q5CoBNY/fYhc8eo/JNrKPpHvqjYzbsThzSZQ05U=;
        b=Y31FS5ez5mYuEOMGf2wYCnFBEFEciLaVqR+RLWmFlbxCWqOcmkY14QtUZ7dkFhmC+O
         PDMSq5yzcXI0T51xRc/2s/UUFykhNMSyTQzICJHHIJRU2izA1t4KSHk8yktXRxJNxVrT
         ZiT8DXZJ5smC06drjvdCOyyl7mjXb42jQEBBKggsQI+/+KFu841IuGjrTVshxJ6Av/0+
         QqaZKhEPbLglpIHV8DjD3RJiOR8xMrEwyxhEQXoO2NuEEafSRYCBlBMshBy1jA1qpsOp
         MO2V3JVupMw82IwwE7ysHQm4YaNsvaLHusal1GRsGQQM4P5uH6J3KdukdTJeqkJVjalb
         Xqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jy30Q5CoBNY/fYhc8eo/JNrKPpHvqjYzbsThzSZQ05U=;
        b=RUkToxiL1qimky3aEPVBBReccR9vCkfnLyQPX/NAwmYfMy3IZug0LHqzZAA+PZNX1E
         dTh0624A/wCl1Otnk9FKG7X5rvzE4ZWd6fhEQaxdDBAGiXPlahR5OdGqrsgjqscn1yux
         JGKeytAOXZ9cCk6abZKan6wucdy4NmWhS6+mxRYAe2VyqixGKbHWBWfcwBBqYdGrdumE
         QloGypoH705Mr3g67qzHZrTyvcIxLp77hrXJQpIEqmur/Cp27H3PA56ha2ByYSSrAGpI
         cJNpHOrAqN0ZmYXSCOIUSbUpNCjKZohLHxTSsJh7XKHEMKOREtoRqHk+uTC0e74ktNoo
         Urug==
X-Gm-Message-State: AO0yUKV+lDp7FMgfzh6AhQulIV4fYpx2Icz9oQMS8FsAhTjGK+6wX4Ze
        K3NWNqBIrspP/j6OAUg0ylO1SoxiMb8PZ5oz/at0Sg==
X-Google-Smtp-Source: AK7set9uk3OElOHb0yhkRGf2onss+eUAKY+U2mMVPjOU31IcxZDvidX54UErqpO3uYDm9FSXb5UH8kR/BztMfS422qM=
X-Received: by 2002:a05:6102:3c4:b0:3ed:7a8f:d181 with SMTP id
 n4-20020a05610203c400b003ed7a8fd181mr794571vsq.3.1675789530500; Tue, 07 Feb
 2023 09:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20230207125634.292109991@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 7 Feb 2023 22:35:19 +0530
Message-ID: <CA+G9fYtgJX507GJ3fG7-G+vGhG4BnU=kzu3fOH_a-_aMU0S_0w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Peter Xu <peterx@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Jann Horn <jannh@google.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Feb 2023 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Following build regressions noticed while building
selftests/vm/hugetlb-madvise.c
with kselftest-merge configs.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build errors:
----------
hugetlb-madvise.c:242:13: warning: implicit declaration of function
'fallocate'; did you mean 'alloca'? [-Wimplicit-function-declaration]
  242 |         if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
      |             ^~~~~~~~~
      |             alloca
hugetlb-madvise.c:289:27: error: 'FALLOC_FL_PUNCH_HOLE' undeclared
(first use in this function)
  289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZ=
E,
      |                           ^~~~~~~~~~~~~~~~~~~~
hugetlb-madvise.c:289:27: note: each undeclared identifier is reported
only once for each function it appears in
hugetlb-madvise.c:289:50: error: 'FALLOC_FL_KEEP_SIZE' undeclared
(first use in this function)
  289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZ=
E,
      |                                                  ^~~~~~~~~~~~~~~~~~=
~
make[3]: *** [../lib.mk:145:
/home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/vm/hugetlb-madvise]
Error 1

Build log:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/372819=
8425#L1676
https://storage.tuxsuite.com/public/linaro/lkft/builds/2LPeQeCIu0YEfltwqAFC=
vDaj29A/

--
Linaro LKFT
https://lkft.linaro.org
