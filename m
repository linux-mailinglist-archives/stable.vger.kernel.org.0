Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D90D67A7B2
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 01:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjAYA2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 19:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbjAYA2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 19:28:42 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED54DE37
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 16:28:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id v5so20123500edc.3
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 16:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHRLF5EjAc/CnwpWPOx9gjB6ipIMS9QSUsPy/x1ic7Q=;
        b=wkijrdz6EwTaU8soo2pXMQ2KzEu7aHLRrbhyTgaR118mKcPEM82we+KReP8KmvG2T4
         vWUL9Y/pPM4tfLDbPZDNNl+OgZttDEc4Gl1HcLPJ8Ema8cHeGZNeA1x0XVdrUmJUVyof
         Q9ASb3cKz9Tagr9fmJoAxQmHFmjqNPTZ75L0125V3BFUwddp/Vxb0UWDktwhi/v35Ilv
         g5Cb6RBV+McOPBZJuHGCJrkBdZvihsN0A2+ynLzJ7WRcWdxi8UMC9EC03bueVxRHQcO3
         pjrjVtt6HHExnn5i26VuQKlMKJQ9VmA5ueBYjCf/2Z9Z30RisrHjGi6v5RQAo5s/7xVo
         yOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHRLF5EjAc/CnwpWPOx9gjB6ipIMS9QSUsPy/x1ic7Q=;
        b=VmVD3TTKq0uUW1wa5EUjUiqO9TQcTr+MGtovqdHelTEmeUJUFCKdKeZBWfdy+1LUDx
         1PWdmDF5hSyS34F0O2bmRIdXCIqQO9YSVeUCtHQ3QB9xrNneo/CpYUGiyywKqkhSgWko
         QC43o8AVx9t8awgejkP9RPmB1MYciXcqWhreO9Wbek+xjecG6faya7U8ffXzX+wqmQA4
         2vLhbZhCtlg+0b6Xwm1q+C87ep60TbV7zvhzNc5JmmA9VkOOxrJJPzbiDiOR7TPDmqvU
         Cwemolq764RBUR10gmF5CwsJYY38HiosWgMfdZIz0+kzBsbEMpSdBQ9fADa1FwGhEhh9
         83zQ==
X-Gm-Message-State: AO0yUKXK6RvQxG1WMessRM42UMi/TX1gntxqSHYR9qrLjaRunEST/qUV
        bQTHYCh35MFOMGjbxW4Rj3EojEsMuPMqLAbRMvXXZQ==
X-Google-Smtp-Source: AK7set9Ety8dkQYdxT1DoJuz0LpIakt9q9zcvX3X4HCobd9KzrFp42CRrtIAGOsqMELg5yR+MQf7dw/t1Kg2kbJLYLA=
X-Received: by 2002:a50:cc46:0:b0:4a0:902c:9da2 with SMTP id
 n6-20020a50cc46000000b004a0902c9da2mr492169edi.62.1674606487247; Tue, 24 Jan
 2023 16:28:07 -0800 (PST)
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org> <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
In-Reply-To: <CA+G9fYuH9vUTHjtByq184N2dNuquT1Z02JDRh2GYFR96weZcFA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 25 Jan 2023 05:57:55 +0530
Message-ID: <CA+G9fYtAvyFUsGEgAkeTF+=B1+MySYd605Vv94BT6=1M96bwDw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

On Tue, 24 Jan 2023 at 15:22, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Mon, 23 Jan 2023 at 15:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.90 release.
> > There are 117 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.15.90-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> Regressions found on arm64 for both 5.15.90-rc2 and 5.10.165-rc2.
>
> * qemu-arm64-mte, kselftest-arm64
>   - arm64_check_buffer_fill
>   - arm64_check_child_memory
>   - arm64_check_ksm_options
>   - arm64_check_mmap_options
>   - arm64_check_tags_inclusion
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> We are in a process to bisecting this problem and there are updates comin=
g
> from kselftest rootfs.

The above said regressions are due to the Qemu version upgrade to 7.2.

With reference to my previous emails,
This is not a kernel regression on stable-rc 6.1, 5.15, and 5.10.

- Naresh
