Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F7F6E67D0
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 17:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjDRPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjDRPJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 11:09:01 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE510C171
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:08:59 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id s13so7608081uaq.4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 08:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681830539; x=1684422539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/Weo+bvn0zooGajGBsSKQ5BWYoFH9k7Hf0s1B3WbB4=;
        b=LpflOLy/oZ1Wgd6AgyWbtDal97yPX2e0T2ha8bGLAjsmkiw7S5c505UCFXRLYnmlHo
         TvRw8ryyaQ6gaiBoEson4u5M/DzCyKDP53ZGVYq5GxTpOHIOtKc2eU5i34BJ4deLwAFl
         vpu9l3XoEbZQlaW/Cb69p2o181LaDSPPOgK//sXMx3IX7yKXSmCnF/z/6JLKzXI9YTGu
         NqrfyLrGzMHeuiYWFkMvmRwVQsZuYzedfkYVOwrXzl+cs18tJM4i+H90j8TVuRt1kuid
         OGE8cFXbWIpL4OlG2/mfg2JR7lrMWRTjQ7MHOX2Xs/ybqgXnVnOy8ajr5IAkBt3uQVCl
         RGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830539; x=1684422539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/Weo+bvn0zooGajGBsSKQ5BWYoFH9k7Hf0s1B3WbB4=;
        b=kgiA7ZcTtKZ93QZtjQZ59VsG1Cm8HvJZui24KPJwFnxsbxQOtWfQ0x3Xr+ZBibEGUs
         9r/RNOzz4NF33OAVWNjVDEGphoOOvtwxwXBWc3cfUyRKtvxcittbYHQE+ioBO5jSR9qp
         cd7GlbK12f+o36QaTqxk0gNDXE+R0UyWC3jkdppRziVz5HavOrQYOpmKXvDtvoNnFMI/
         ntbjZkVnf58PI7osjUTdFGG64bX8DQDCykvw6fxDn9FH6xnlvBIqa4Lumi6W3sEcqKsV
         3dHnVn61oTfm7wFv0UgfxNLZCDU2aGBrRk2zWu0EcLmSwfDHlZxB0ZQdva/DA1fqAXPr
         0fcQ==
X-Gm-Message-State: AAQBX9cvzKgmuScHFObw96grhy2x1ZFVJyFABSKjPNTANCSxWzkwIsiW
        iipCKAy5wMCacbmwvhsvsaeTtlLyNECI3Hab2pTuRg==
X-Google-Smtp-Source: AKy350bGSNHdehMJISDHG7Mv19IDo2CuVhhF1lsE/6unr9f0Onv7sLFAfpSy40caB9YZV4/3KFrTGRmuEB1tHv9Nc64=
X-Received: by 2002:a1f:d084:0:b0:43c:6e7d:60b0 with SMTP id
 h126-20020a1fd084000000b0043c6e7d60b0mr5019506vkg.15.1681830538767; Tue, 18
 Apr 2023 08:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230418120309.539243408@linuxfoundation.org>
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 18 Apr 2023 20:38:47 +0530
Message-ID: <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build errors noticed on 5.15 and 5.10.,


> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem

kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
(first use in this function); did you mean 'cgroup_put'?
 2941 |         lockdep_assert_held(&cgroup_mutex);
      |                              ^~~~~~~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Suspected commit,
cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.


--
Linaro LKFT
https://lkft.linaro.org
