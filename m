Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E237B493EDC
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 18:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349340AbiASROP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 12:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243695AbiASROO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 12:14:14 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616C3C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 09:14:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id p12so15574792edq.9
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 09:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+iHHvLUDMZgd+1HatbMK7HIrN5RHH5OnH3MOXIw4cw=;
        b=XxrXFUYwqHk69eId58EKHAV/+1ItyJO3kgrO1jYYM4t+DVUhWuei9GjTK4dVkMwNTs
         /FW47fBcgABpWRiXFmEN7wX0esz6MCztSvTbNaTHgMvPo74X/9pGc4+zdAoHuZPW0aYJ
         xRssSL6vr2GmpCMTkP6UIyfYpkixJwcGnsNG8s8xkxsYt5rExBPgsZ24XFThhRK3FiCg
         HnJlkaV4KTP9Ri5o4lO/2o14fqLQI26XrBCtuZgbrD5PT4wKvdckRtHNQyfODHYiv17z
         NDrjixqKRqSW5WXH4Nxhg+jlhoWjgVMbyATUfdKF0QN3JnoTaWdKvl2oT2/JE2E4uuYX
         PLyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+iHHvLUDMZgd+1HatbMK7HIrN5RHH5OnH3MOXIw4cw=;
        b=Xa0ZIpTyCm81djGrWW8iLN3jF/SP+QFpqWD/uFJwQCHiWRzxXRuFkx2u0WiOOPL5En
         0i3l3mpbBla9MN9JdG/8Q801NnERGz1TbSy9RBtsX8Hp1THbdcDlD6ApDxtBNhuvccIT
         Lie1Ms9mbFI0bpQxzt5ImWAmGd5h9mJDi4XqaS+5ER02r/pcanLrAdyqFgkdDpfU1FwT
         9ru3W0pavV5ri5WQwYZP3ZhEklue1R5tXfo3D2mrVX/F6Z5iUCGsccpMi+PyoqPKQysI
         ucVhvPxBEk/5cLKMEuPx8gotKebDeG28bMM9SmgsV4/sofxQ+ZbBdp+chYE7uk/iZiq4
         2Vuw==
X-Gm-Message-State: AOAM533sse8QDcaEC8bHKtyrim/SThRzOTVv//kb13k9Ny4CaqK/lwQ0
        VoBkMTgHEPki36reFFFaR+2AfHc5zcvo9xHQr6x8tA==
X-Google-Smtp-Source: ABdhPJzywlARa1B+zYORVQfDUt8Ut3CB0Cd5HbELiAWKPluFSA4/9ZlXHOkf5HMDXD+QsuGfry3ur2n5Vys40ufBI7I=
X-Received: by 2002:a17:907:2d26:: with SMTP id gs38mr1736560ejc.693.1642612452855;
 Wed, 19 Jan 2022 09:14:12 -0800 (PST)
MIME-Version: 1.0
References: <20220118160452.384322748@linuxfoundation.org> <CA+G9fYvJaFVKu24oFuR1wGFRe4N2A=yxH6ksx61bunfR9Y3Ejw@mail.gmail.com>
 <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
In-Reply-To: <CAHk-=whJjHXGeVnVPmC8t_+Rie5N1tarrzsttECEh5efbXYUuA@mail.gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Wed, 19 Jan 2022 18:14:01 +0100
Message-ID: <CADYN=9Kb5CNEMfN_iKW-tBaA65GsHR6-Sp0GA1Vi6H3nVanR4Q@mail.gmail.com>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        NeilBrown <neilb@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Jan 2022 at 09:00, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Jan 19, 2022 at 9:30 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > Inconsistent kallsyms data
>
> This tends to be a "odd build environment" problem, and very very
> random. Triggered by very particular compiler versions and just some
> odd code modement details.
>
> I'd suggest doing a completely clean build and disabling ccache, and
> seeing if that makes it go away.

Clean build without ccache didn't help.

It seams that it fails randomly based on the size of the rodata section.
This could probably happen with another toolchain too, trying enough
configurations.

Diff of tmp_vmlinux.kallsyms2.symbols and
tmp_vmlinux.kallsyms3.symbols [1] show why it fails to converge, while
said that the __stop_notes address is on the page boundary, so
__end_rodata has the same value as __stop_notes.
All 3 tmp_vmlinux.kallsyms(1|2|3).symbols files can be found [2].

Inserting padding before __end_rodata [3], or blacklisting __stop_notes [4]
in kallsyms.c works around the problem, but neither of those seems like a
good fix.

The linker version I'm using are 'GNU ld (GNU Binutils for Debian) 2.35.2'.

Cheers,
Anders
[1] http://ix.io/3ML7
[2] https://people.linaro.org/~anders.roxell/kallsyms/
[3] http://ix.io/3MN2
[4] http://ix.io/3MN4
