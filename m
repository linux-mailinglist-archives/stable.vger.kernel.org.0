Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7745132DBA7
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 22:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbhCDVQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 16:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbhCDVPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 16:15:52 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A7C061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 13:15:12 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id n16so181548lfb.4
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 13:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C4GiH7OsFqBXNgPH9lEXvnAS/VBedlFXUn708GSVLWs=;
        b=HNy3dt+f1rBLexxgKM508D0xHwg6OpIpHIGpOed+5RHLqIKoVYGKTjERUIERsyQCur
         RghFiw+842AbLBDt4WeumgW2bbCFFuIa9qbNGLWZ+j3f6wOegcZa4SwhZWdWbN0gkWuQ
         Lq5DV+yjKFHmzW8AkALe9YvH9OYxFPaunwJPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C4GiH7OsFqBXNgPH9lEXvnAS/VBedlFXUn708GSVLWs=;
        b=Q2LlmkVEWPhfmF6co3BesXAWR+Hra3dQ2rSOmTAnaCezMwAwQWGWWZVyKBDY4ixO6h
         JQ2O5wSSgs5svQ0EdELmOhTGb9xOYzlKmiZtQwMa0Rnu87jNaZ981B6epjd3hn+5Nqbl
         QXXeUSAgdmx6fpOyEDeBB7zJsoA8pm8lHjDW0Fnp30qopvwwQp+fPwKv3DpXMJ/2aCyq
         7cAn3uBMUPIKjp68fnGZa28ZCorWwbzI0j/4KOAss5ZtB5TnBZIk0PypbQLMAkVwm29P
         G2lD4kj2I1xdKFY2R3gDP1DPmC5+yID16z2eBtPIxIhHvfPcWCuTVWoABgS2Jq2alTB6
         4LXQ==
X-Gm-Message-State: AOAM530CJ9jriQ2rMQabfrJNWsMUK/Nck1mAS1uIi0kQrFreDfqGGu52
        x7AqcejjcmhopzqiTow9+t0wfBSVgfOEpg==
X-Google-Smtp-Source: ABdhPJyyCZaMi5+phPHBakOk6Gdomwk79Pjz79Q+5CIDeA70Eie5z016f0BdVXv6Gie5h/I8dTc0/A==
X-Received: by 2002:ac2:41d6:: with SMTP id d22mr3423537lfi.496.1614892510173;
        Thu, 04 Mar 2021 13:15:10 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id 124sm55829lfh.252.2021.03.04.13.15.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 13:15:09 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id p15so26223056ljc.13
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 13:15:08 -0800 (PST)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr3223231ljj.465.1614892508416;
 Thu, 04 Mar 2021 13:15:08 -0800 (PST)
MIME-Version: 1.0
References: <20210302192700.399054668@linuxfoundation.org> <CA+G9fYsA7U7rzd=yGYQ=uWViY3_dXc4iY_pC-DM1K3R+gac19g@mail.gmail.com>
 <175fac9c-ac3f-bd82-9e5d-2c2970cfc519@roeck-us.net> <CA+G9fYtkrAs=ASaVVu6-Lnck8A6Pt_LGODxnpTYouvppbw_rbQ@mail.gmail.com>
In-Reply-To: <CA+G9fYtkrAs=ASaVVu6-Lnck8A6Pt_LGODxnpTYouvppbw_rbQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Mar 2021 13:14:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgxLTur2G5mvYKCXE4DkUo90T2Dy3X526sqJgOCm0gzNA@mail.gmail.com>
Message-ID: <CAHk-=wgxLTur2G5mvYKCXE4DkUo90T2Dy3X526sqJgOCm0gzNA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/657] 5.10.20-rc4 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 4, 2021 at 9:56 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 4 Mar 2021 at 01:34, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Upstream has:
> >
> > e71a8d5cf4b4 tty: fix up iterate_tty_read() EOVERFLOW handling
> > ddc5fda74561 tty: fix up hung_up_tty_read() conversion
>
> I have applied these two patches and the reported problem did not solve.

Hmm. Upstream has:

*  3342ff2698e9 ("tty: protect tty_write from odd low-level tty disciplines")
*  a9cbbb80e3e7 ("tty: avoid using vfs_iocb_iter_write() for
redirected console writes")
*  17749851eb9c ("tty: fix up hung_up_tty_write() conversion")
G  e71a8d5cf4b4 ("tty: fix up iterate_tty_read() EOVERFLOW handling")
G  ddc5fda74561 ("tty: fix up hung_up_tty_read() conversion")
 * c7135bbe5af2 ("tty: fix up hung_up_tty_write() conversion")
  d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
"cookie continuations" too")
  15ea8ae8e03f ("tty: teach n_tty line discipline about the new
"cookie continuations"")
  64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")
*  9bb48c82aced ("tty: implement write_iter")
*  dd78b0c483e3 ("tty: implement read_iter")
*  3b830a9c34d5 ("tty: convert tty_ldisc_ops 'read()' function to take
a kernel pointer")

Where those ones marked with '*' seem to be in v5.10.y, and the one
prefixed with 'G' are the ones Guenter mentioned.

(We seem to have the "tty: fix up hung_up_tty_write() conversion"
commit twice. I'm not sure how that happened, but whatever).

But that still leaves three commits that don't seem to be in 5.10.y:

  d7fe75cbc23c ("tty: teach the n_tty ICANON case about the new
"cookie continuations" too")
  15ea8ae8e03f ("tty: teach n_tty line discipline about the new
"cookie continuations"")
  64a69892afad ("tty: clean up legacy leftovers from n_tty line discipline")

and they might fix what are otherwise short reads. Which is allowed by
POSIX, afaik, but ..

Do those three commits fix your test-case?

(And maybe my filtering and trying to figure out what is upstream and
what is in 5.10.y is broken, and there's something else there too).

                Linus
