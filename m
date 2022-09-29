Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C030E5EF95E
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiI2PpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 11:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbiI2Poi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 11:44:38 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8337E78588
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 08:43:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id m15so2494971edb.13
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=A0NjTGEuE29trCtKX2eLnjxa8Mm0a3CsC5jYLBIM+dc=;
        b=o6H/zz7ovjMpa0D51Tl8P7yeScD7KTQNIJbUYN/ynwtP0u4zISrWCvrT0OqrmvPeNR
         0srCIBh900R+inQdU2H+7KA7Fe95bBSXUTg6jjnnEGLMfuRTZfToppTRk6OhzqUyg1cJ
         qIMCibx6KjlmbXEMo8X1oYuadUkSE8TvPTrFL5l1s53HWOlqcZuCVgNeEe1auMSB5/oM
         DSVGpSbeLL0TXDXCeRIYWrueEZaHjLXJoFEz4FDrRgi3uca521AkjSHb51QjhZYT3UWx
         yz79J0JpNaULr3tbwbwiOeSHpi5zBt2wqaL0t2aOO7xxpGnZ0LZgZz/zCOySIcWypS5X
         WlSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=A0NjTGEuE29trCtKX2eLnjxa8Mm0a3CsC5jYLBIM+dc=;
        b=bvgGVqPrFa6T8l45j603UufjDxQPTt6KQno2rssEmsTOQO/HvnU8NsBZkZASnKlvxG
         hwMj2JNra2nL6HusL8ZzLhMJ5hm2f316p4ihNwNrAJjZ9JS1gjVC4FafOYygWDRFWV/5
         yCd/BdnrPWEwoL+7QH6F2LqholvsRNYDHSPUJeUEgmVL99BI8BJcW3ViYoU4XLPgs5ME
         JEaSJqtKhmdcWqeqDIfT8HUdKZKMfB64KeFhx9FpiLsQBJj+uQVzo9ak60xOoT3p4BjP
         iv2pzwqP9wRReY22vi1uajCNeiH2vfTIh5VhiiUSdUoSTL9r/cuUKqQOcsGd+vGGFcqR
         j4RQ==
X-Gm-Message-State: ACrzQf1T9RoNN3yVVl1EOhB95xd7TMj9yeZwvs6gbmAqfw0dnhxyq2T/
        vTV535QsmlySey6zfS6JhAw0xj2/8xDP+cDIUZiq6Bf2XKubBg==
X-Google-Smtp-Source: AMsMyM7Yj69V1v6CwVdslSeZ5ofFtjlDEQl0B9VtLPg+2SdG+j7DCpX4AaHJ4QrapAGXUDr4oCl4TT/pxcnOy05BPIs=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr3944162edb.110.1664466229907; Thu, 29
 Sep 2022 08:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100806.522017616@linuxfoundation.org> <CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com>
 <YzKyIfQUq9eRbomG@kroah.com>
In-Reply-To: <YzKyIfQUq9eRbomG@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 29 Sep 2022 21:13:38 +0530
Message-ID: <CA+G9fYu1L_qwCQ9x0FukJ=0J5sg5z0ttejT9BT_bPAgCEtmAnQ@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Johannes Berg <johannes.berg@intel.com>,
        Hillf Danton <hdanton@sina.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, 27 Sept 2022 at 13:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 27, 2022 at 01:25:52PM +0530, Naresh Kamboju wrote:
> > On Mon, 26 Sept 2022 at 16:13, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.19.12 release.
> > > There are 207 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Results from Linaro's test farm.
> > No regressions on arm, x86_64, and i386.
> > Following deadlock warning noticed on arm64 with kselftests Kconfigs.
>
> Is this new?  If so, what commit causes it?

Anders bisected this reported problem [1] and found this commit caused
deadlock on all arm64 devices.

> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>     workqueue: don't skip lockdep work dependency in cancel_work_sync()


[1] https://lore.kernel.org/stable/CA+G9fYtxogp--B0Em6VCL0C3wwVFXa6xW-Rq2kQk3br+FPGLgg@mail.gmail.com/

- Naresh

--
Linaro LKFT
https://lkft.linaro.org
