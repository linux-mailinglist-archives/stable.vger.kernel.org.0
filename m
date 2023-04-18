Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729DA6E6768
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDROr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjDROr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:47:26 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB62B448E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:47:24 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id l17so7735666uak.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681829244; x=1684421244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zxv/j8d+r2oA0vxESoxPSJz8TZknxHfxebul1vANndQ=;
        b=GqkPdIJexPqah1YPwxeOHrQQde2yvFeRgaTIYQl4NjC2zoCUuNI4wWEsRusCXz9si+
         Nk8TLeLHlq9i28pmzScHr8PdX8YQm9WqGkPfTt4agyY33LqjEhdaeCfw43+7/BlXYiew
         /eVv3ir+iNIJjPWaGTnuORJMVBRWy/6araulrSFExtpkCJizAUMa0Z4uIBHJQSg+b80Z
         gZHDJ9lfe3dlwFWs2xv2hXznOKRm2q0ZrJVH90LRJl7PenW/O6TB2XhTtv56jFq0/jUt
         Z1Sd/QmZkklJAs4ccVeFfK0a+PC3eiNSBKJ+WQvusKKF0ctk2bRxsbvPCFC9jZrJxSae
         qt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681829244; x=1684421244;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zxv/j8d+r2oA0vxESoxPSJz8TZknxHfxebul1vANndQ=;
        b=WL0eaSD5gaHKsuGWn6MuMWbfB2p24hPM/MCehjrkx/TnJA5jqFXPCtn9JhEFwYyZBm
         KEDTyoimrInaRMmcRumfzze1f14uaMHigkTLXEi3o6jpZ45KA5oQnqZxM8fKldlGUq+e
         xyK/eEA4cM05CYGnwyEcsFGXJLKwMav0YbX7bp1zHN6YwRBVm6HZWqmgCrjNjDGV08iB
         J7yzo6SzvDdnsDXgOifuazpAhtukRB2kQz9KK0apwWuGr2l1sS9ZzLS2f+Grq1IxGE+Z
         5cF6HtoyVjs/odHJkeG9mRn/hh4BwIsPGjOi4V540scjL5KU+2M+KNpb2v8IwMzNVezb
         trNA==
X-Gm-Message-State: AAQBX9eF7NTRQa0TXSqNQ8T81ktkoZB0KsL5cLCdfXAbbWx2igZ9r62D
        HoefhV6RF0T0MhaKPj9mBJgWy+2c5nvwLfe4/ZmHVw==
X-Google-Smtp-Source: AKy350aZ7U01zpkAeVgv1+aiKvjqICBYTsuqUdfkjZ0vlK/PTEx4E93SIhJFpk0Rer7y8Q3NOlUm/xmMd7alr76PngE=
X-Received: by 2002:a1f:410b:0:b0:43c:2acc:4814 with SMTP id
 o11-20020a1f410b000000b0043c2acc4814mr6492587vka.2.1681829243795; Tue, 18 Apr
 2023 07:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120305.520719816@linuxfoundation.org>
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Apr 2023 20:17:12 +0530
Message-ID: <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waiman Long <longman@redhat.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 18:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following patch causing build break on stable-rc 5.15


> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods

cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2979:30: error: 'cgroup_mutex' undeclared
(first use in this function); did you mean 'cgroup_put'?
 2979 |         lockdep_assert_held(&cgroup_mutex);
      |                              ^~~~~~~~~~~~
include/linux/lockdep.h:415:61: note: in definition of macro
'lockdep_assert_held'
  415 | #define lockdep_assert_held(l)                  do {
(void)(l); } while (0)
      |                                                             ^
kernel/cgroup/cpuset.c:2979:30: note: each undeclared identifier is
reported only once for each function it appears in
 2979 |         lockdep_assert_held(&cgroup_mutex);
      |                              ^~~~~~~~~~~~
include/linux/lockdep.h:415:61: note: in definition of macro
'lockdep_assert_held'
  415 | #define lockdep_assert_held(l)                  do {
(void)(l); } while (0)
      |                                                             ^
make[3]: *** [scripts/Makefile.build:289: kernel/cgroup/cpuset.o] Error 1


build log:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.105-280-g0b6a5617247c/testrun/16291026/suite/build/test/gcc-11-lkftconfig-kunit/log

--
Linaro LKFT
https://lkft.linaro.org
