Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DAD54C8C2
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 14:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347290AbiFOMnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 08:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242577AbiFOMnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 08:43:13 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8E812601;
        Wed, 15 Jun 2022 05:43:12 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id s1so642434vkl.3;
        Wed, 15 Jun 2022 05:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eGcDsfPOND2azz/8VIB2pDzmqEIAKrumVcy9XBn9qao=;
        b=lkLVQuIyA89DPX2/GcOGd/q4quipbwq+/lVACncdISqDdcGSN2YrhrRME7hGdbVGTs
         zQvdwErG31Ikad7BddvbE4iZD52RWfOqA5wuZ3+nJUt6htyi/re5X8OxqgMu69qFQMsX
         XnYt8s2QdOj7uuoX8NXWCIqLQvQgftN9ZOa0jgfVvixPxfpTKjtjM6sjNBMMj9K9HvWJ
         PHd5aJXkpIs40Q6q6pIrlFiiXCfjfFX8nSme8df+m0Vg653tT509DuYAIzyhcPyRSD2K
         kRADFFY7XarRQxrNehzys8ZE3dFSkNzfFYqLldf4GUzXoslSjimO+oiFTQ2Shx+NcI1l
         9FBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eGcDsfPOND2azz/8VIB2pDzmqEIAKrumVcy9XBn9qao=;
        b=zNAELJJ0U8hct+2R3VZFc2mIsiQv7Px/FIUX2ykve0AIMNlp6wOOp7TZg/cbqhvixu
         80QmW8/jlYR00NaZRlAjouXaWaanjCHapb36AbPgPuyOYPuRwFNppliF2i/gfyqSL2UW
         ZxdBhTq/2LnJ5pYcHWy1ZY98Vcq4j2plYLraIsUOECx/1lmwZfXTSFWa5xLjpe14LQIq
         3A66Z/B9ClSNiWdw7aPuiYGkY4xuoTApwclCAor4RAKGgzI0oYCcmvchrFRQ9fQ5f1Pb
         GS59jiSPWk5BThrXkyDGuCXsYQT53WUHnkKCGs3CkCPwH5XDvEnTQFZAx377dwdvxCJb
         7unw==
X-Gm-Message-State: AJIora8sjfMDxee2r9KO5A1zycLpP4B3hE+kiQQJyTA/bxpTomZqyosC
        z4T3HUFdXkvDuVbSoCFKBlyDmmRGIQ6PePB0nrw=
X-Google-Smtp-Source: AGRyM1vj+2sDoJW+kLoQ6G6lyBv4gupEzLZGTTd0iPXBgL28UOd3sDM3obOoOo7OtVvVPGvCOW743Sg4SOS39cXNeVk=
X-Received: by 2002:a1f:a30e:0:b0:368:5be3:7e1a with SMTP id
 m14-20020a1fa30e000000b003685be37e1amr4538174vke.8.1655296991362; Wed, 15 Jun
 2022 05:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220613181529.324450680@linuxfoundation.org> <CA+G9fYvUzFC9mV+xAxPjvCnGORNRS8aB0i=AFK-Kw-_Z+DTJdQ@mail.gmail.com>
In-Reply-To: <CA+G9fYvUzFC9mV+xAxPjvCnGORNRS8aB0i=AFK-Kw-_Z+DTJdQ@mail.gmail.com>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 15 Jun 2022 05:43:00 -0700
Message-ID: <CAJq+SaA8i4DVhg_opJEM85PH8UeTzV6MX5mCU7G5DbMYxbyWeg@mail.gmail.com>
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, 13 Jun 2022 at 23:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.17.15 release.
> > There are 303 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>

Compiled and booted on x86 & arm64 systems. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
