Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3FF452EC6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhKPKQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:16:05 -0500
Received: from mail-ua1-f45.google.com ([209.85.222.45]:41775 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbhKPKPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:15:34 -0500
Received: by mail-ua1-f45.google.com with SMTP id p37so39534907uae.8;
        Tue, 16 Nov 2021 02:12:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1nds6uFGqbyvPuDVHazG3SNcBfSR72giETk/vmz+pug=;
        b=RriKkQWzi0EBTz0xvH9Ni30eaFUiTpNrgalTGM0JifrEo75OfiJ8vfhZNITor+zqGl
         siWdxT5/OGb9oUfe9CwvcXACzAsC6xwaX+aCugF0wMUgYRFDOUicjCns3m2Fu2tVjj2Q
         /MttW0GQ3xiVYr6P6q/rY8ylS2qisl7bNBBky40a3QMmbVnlZb4Vlh0El692HOxbfzxq
         QB6ua94+xawuEpEKyakb2W2itZfsbawXm1nK9e7iS1pg+LeYMVFa3Edc/ZfBXEtps6qe
         N0+OaFWpO3dgs82am4C6BdrYMfz6LibAHoe11wLhJYdup+8Sd2vR6xj9PmYYa2FJQKD3
         HIMg==
X-Gm-Message-State: AOAM533IlQmnVtpI2Y09bbT2gqPPUjkK/wTnpl3P8bG3tBn8z6gdAO3r
        Nv9LCFzJZUSq+UTM7vPg+QeVYPBkgEE9TQ==
X-Google-Smtp-Source: ABdhPJwAG93rfedsTIAAzZWhezNyGxWGUMIOvObdjtJl49PzNS5ybwfim+Q1dcTdlhXbj+9tMa6ukQ==
X-Received: by 2002:a67:ee88:: with SMTP id n8mr53242798vsp.58.1637057556636;
        Tue, 16 Nov 2021 02:12:36 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id d128sm10313957vsd.20.2021.11.16.02.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:12:35 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id n6so24630571uak.1;
        Tue, 16 Nov 2021 02:12:35 -0800 (PST)
X-Received: by 2002:a05:6102:1354:: with SMTP id j20mr53829461vsl.41.1637057554823;
 Tue, 16 Nov 2021 02:12:34 -0800 (PST)
MIME-Version: 1.0
References: <20211115165428.722074685@linuxfoundation.org> <CA+G9fYtFOnKQ4=3-4rUTfVM-fPno1KyTga1ZAFA2OoqNvcnAUg@mail.gmail.com>
 <CA+G9fYuF1F-9TAwgR9ik_qjFqQvp324FJwFJbYForA_iRexZjg@mail.gmail.com>
 <YZNwcylQcKVlZDlO@kroah.com> <dabc323f-b0e1-8c9f-1035-c48349a0eff4@nvidia.com>
In-Reply-To: <dabc323f-b0e1-8c9f-1035-c48349a0eff4@nvidia.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 16 Nov 2021 11:12:23 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXG2Y-rwPtBw1PsGckk3MLRQvn6Xht6ts2RkW7Zkx=w2w@mail.gmail.com>
Message-ID: <CAMuHMdXG2Y-rwPtBw1PsGckk3MLRQvn6Xht6ts2RkW7Zkx=w2w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/917] 5.15.3-rc1 review
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anders Roxell <anders.roxell@linaro.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jon,

On Tue, Nov 16, 2021 at 10:23 AM Jon Hunter <jonathanh@nvidia.com> wrote:
> On 16/11/2021 08:48, Greg Kroah-Hartman wrote:
> > On Tue, Nov 16, 2021 at 02:09:44PM +0530, Naresh Kamboju wrote:
> >> On Tue, 16 Nov 2021 at 12:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >>>
> >>> On Tue, 16 Nov 2021 at 00:03, Greg Kroah-Hartman
> >>> <gregkh@linuxfoundation.org> wrote:
> >>>>
> >>>> This is the start of the stable review cycle for the 5.15.3 release.
> >>>> There are 917 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> >>>> or in the git tree and branch at:
> >>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>
> >>>
> >>
> >> Regression found on arm64 juno-r2 / qemu.
> >> Following kernel crash reported on stable-rc 5.15.
> >>
> >> Anders bisected this kernel crash and found the first bad commit,
> >>
> >> Herbert Xu <herbert@gondor.apana.org.au>
> >>     crypto: api - Fix built-in testing dependency failures

That's commit adad556efcdd ("crypto: api - Fix built-in testing
dependency failures")

> I am seeing the same for Tegra as well and bisect is pointing to the
> above for me too.
> > Is this also an issue on 5.16-rc1?
>
> I have not observed the same issue for 5.16-rc1.

Following the "Fixes: adad556efcdd" chain:

cad439fc040efe5f ("crypto: api - Do not create test larvals if manager
is disabled")
beaaaa37c664e9af ("crypto: api - Fix boot-up crash when crypto manager
is disabled")

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
