Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E949AA5F
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392864AbfHWIbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 04:31:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42986 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388643AbfHWIbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 04:31:33 -0400
Received: by mail-lj1-f194.google.com with SMTP id l14so8078133ljj.9
        for <stable@vger.kernel.org>; Fri, 23 Aug 2019 01:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5AnS6xONtZSg0n044xztbp8MV+q3yy1c6MuO7jBdt0=;
        b=q2rgTt2+JwxyqkHUI8k9gyxaw52BL6lnwtAnZN2wj84wLbc8vNc5C9tC8FQdtu2lBH
         wA5h9OUFw13miLjxDtR4EQGuj+sgKLC+TTRqoxb/r5BGyy4WAk6W53tYFxvEzRq/pJkW
         mrEaoNazfN/ySGDk1Il1zoo29yQLq5S8tBAqWpu0n0FR46SbfygKRW5epA6DNQvyttT1
         o865e9Nd3DXru2EUSkDVOO/XAzp+mY2SwgzTnhUSdsm83u6HdngIM55pXZJayijl1A8z
         taKruxFJiaa4jwA3kPqZ85bi9thCfYolM0SeN8JHrEth8lgyutfkMrkKLSCJkTBNHTNA
         9EqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5AnS6xONtZSg0n044xztbp8MV+q3yy1c6MuO7jBdt0=;
        b=Po2LLJxXP+xzSdC3nHHCR00N2H90dYFDvdQh/Ty+8y0x/LmXTFysfT2xiwrBa2aUyq
         k/75cbLJPimrAxJqb/ycV9/3Ki51QqkODFP480m7FvgMlp8MlCYh5mgku9aMj/NtdrRv
         /jhYBS92Nq8CVhvZdEOV494nAYKkMV8NdjcNDwmqT2ECsfT74zLuS0yKNBVKi58GAsrf
         GY1fMDBfil2eA2qevvnFTGcTo8KoKEIHQTnjNqeQpJZrOETSKtjUsJEN9SRnsZJX+fKa
         n7mA4cTQT67pMMfWBDNJC8Ss1F6fdT9z82kJ31+MhZzw9ucF6x8OQGbCLWikt543UTt0
         sVQw==
X-Gm-Message-State: APjAAAUlZnlWo3jEpgZB5DfwKN7a3kyLE3xsInbQcFkxRuRVOUeRHVh3
        HleZvGTyj6VEAesdxh98OqivCUjeg6iLaF84vygtfg==
X-Google-Smtp-Source: APXvYqyZEGuVM61Kmu8odciqAarFP4zoWXuiMiGF4dFVyilKbHpAoer0CvuLHJ/1+Uc8Sc3NTnFuXo9WJiVs+5alIao=
X-Received: by 2002:a2e:5bc6:: with SMTP id m67mr2221145lje.53.1566549091401;
 Fri, 23 Aug 2019 01:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190822171832.012773482@linuxfoundation.org> <5d5f064c.1c69fb81.e96ef.73f5@mx.google.com>
 <7himqo259z.fsf@baylibre.com>
In-Reply-To: <7himqo259z.fsf@baylibre.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 23 Aug 2019 14:01:20 +0530
Message-ID: <CA+G9fYtUaa7cdpJWLDDywotF0JWDf3XtcFXOweATUXam_99N8Q@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/78] 4.4.190-stable review
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, gtucker@collabora.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 23 Aug 2019 at 04:10, Kevin Hilman <khilman@baylibre.com> wrote:
>
> "kernelci.org bot" <bot@kernelci.org> writes:
>
> > stable-rc/linux-4.4.y boot: 101 boots: 2 failed, 84 passed with 12 offline, 2 untried/unknown, 1 conflict (v4.4.189-79-gf18b2d12bf91)
>
> TL;DR;  All is well.
>
> > Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
> > Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y/kernel/v4.4.189-79-gf18b2d12bf91/
> >
> > Tree: stable-rc
> > Branch: linux-4.4.y
> > Git Describe: v4.4.189-79-gf18b2d12bf91
> > Git Commit: f18b2d12bf9162bef0b051e6300b389a674f68e1
> > Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > Tested: 47 unique boards, 19 SoC families, 14 builds out of 190
...
> > Boot Failures Detected:
> >
> > arm64:
> >     defconfig:
> >         gcc-8:
> >             qcom-qdf2400: 1 failed lab
>
> This one looks like the boot firmware is not even starting the kernel.
> The Linaro/LKFT lab folks will need to have a look.

At LKFT lab arm64 juno-r2 is only the device for 4.4 upstream kernel testing.

- Naresh
