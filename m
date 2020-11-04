Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE3D2A631D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKDLRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgKDLRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:17:16 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66079C061A4A
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 03:17:16 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id za3so29185889ejb.5
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 03:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6YCFrWWMu1UKHsoZToq2t+6Peo1KY/H3DypdwdRdKt4=;
        b=VxonggGg3wDKgjQmN66jlD2ZiafuIncf5yP0IU3HRPFDaUcsdSicZ9tIn9bZdXk0ux
         3RjDBdEPiG2qiz0PP/ybDUa4VndeqPSWiDRbEcNXvmOAe4Fxe7Xx9Yin7JNvqmqMrH75
         Jy43DpLKDO1JOsbIoWtY6TfqAwXHG35yMSADXP1p1+gBwAeXLC0XqmL0cceLsWvhDNgB
         Fd5n6rKJ+lPqOPo+2BMmGPBSMGfmQTW39C8nDn3wW1tgCBhgAmNrWlycGn5vjY2F/5jZ
         4oU9CKroNkFaMw+QYgHIPIn5TmYn59lZgkkHCfiyxpqQDWiOIwSU5K5DmMumu0soFdUE
         AF2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6YCFrWWMu1UKHsoZToq2t+6Peo1KY/H3DypdwdRdKt4=;
        b=ahhdYANLK6UUN2kt7T8Z1a+N6n/SVmHyt3UWMn36QDZa5pfcBepMvhMxlaegAVgKby
         4W6mDukA2AVe6xk31zR29lO6VOIM7g5P3XEewVuFCeN543gL+9nBc4SHoyU3opF6RuRc
         BI0HlZefelhY1gzdVlPfuxQ6++LhYm95lm0whjr7HJ7lzD2mPvhebvZCt0zSVM90CVpu
         la9ppDXOGl5CRDe0HeIhD4JT6sa1IOkPkmRmkVYVjGYCOQNvBniskLqhl3lorStdE5hF
         tDp8xrHODGFAsHh67Sri2GDgkVzhly01LOlkw4iNddg+PYTcFcMRJNsLaCwA7AXz5HlG
         mh+A==
X-Gm-Message-State: AOAM530RJFrFHs+CPIdOYgLtWyjH5VP+sCZQYzm5Q/CEwbPB7Ilpmelu
        xfKI7mQa8Nfb1ZSTIehsbvVIbVE8NGSXhemqFkXtRw==
X-Google-Smtp-Source: ABdhPJzuE/jFvocAFDRk8dADYBHvAr+ERkQgQysVMcSIiXcGkc2yRwsQ0U6ZIvsdz1uuNY/GaO8+Sa/QHohzgjD2x94=
X-Received: by 2002:a17:906:3087:: with SMTP id 7mr24188126ejv.375.1604488634927;
 Wed, 04 Nov 2020 03:17:14 -0800 (PST)
MIME-Version: 1.0
References: <20201103203348.153465465@linuxfoundation.org> <CA+G9fYsrppNwC0S4vkrS8jGW4k2fgmbAzy=oMLV6X9=DHkznpw@mail.gmail.com>
 <87mtzxqtgm.fsf@kernel.org>
In-Reply-To: <87mtzxqtgm.fsf@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 4 Nov 2020 16:47:03 +0530
Message-ID: <CA+G9fYtJgcp5oNyRp8zY2sa0T7mRKgXB6O_csTq9oVwv-UjTFA@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
To:     Felipe Balbi <balbi@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Nov 2020 at 16:28, Felipe Balbi <balbi@kernel.org> wrote:
>
>
> Hi,
>
> Naresh Kamboju <naresh.kamboju@linaro.org> writes:
>
> > On Wed, 4 Nov 2020 at 02:07, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >>
> >> This is the start of the stable review cycle for the 5.9.4 release.
> >> There are 391 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >>
> >> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pat=
ch-5.9.4-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.9.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> >
> > Results from Linaro=E2=80=99s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> >
> > Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > NOTE:
> > The kernel warning noticed on arm64 nxp ls2088 device with KASAN config
> > enabled while booting the device. We are not considering this as regres=
sion
> > because this is the first arm64 KASAN config enabled on nxp ls2088 devi=
ce.
> >
> > [    3.301882] dwc3 3100000.usb3: Failed to get clk 'ref': -2
> > [    3.307433] ------------[ cut here ]------------
> > [    3.312048] dwc3 3100000.usb3: request value same as default, ignori=
ng
>
> fix your DTS :-)

Done.

>
> You're requesting to change a register value that shouldn't be changed
> (it should be properly set during coreConsultant
> instantiation). Whenever the requested value is the same as the reset
> value of the register we WARN to let users know that the register
> shouldn't be touched.

Thanks for looking into this.
The reported issue is a false alarm. please ignore.

- Naresh
