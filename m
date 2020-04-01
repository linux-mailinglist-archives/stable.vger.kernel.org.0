Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834C919AE89
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732557AbgDAPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:07:50 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46624 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732623AbgDAPHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 11:07:49 -0400
Received: by mail-lj1-f194.google.com with SMTP id r7so18417130ljg.13
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 08:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WedDbKscds1ScdlD9Vgo8BPtCth3GHq3H8QxE59GeR0=;
        b=Vis5kbVhSKwdnTHbh23flW5MVbI/z6DrT9FnkVi7g7tdVv75rRUaDVBOfa3kleOMMc
         d2o0Mh3II9WvRbLDYg7UoJ/yj6wn7CMM0G8PQZAFNclbBZEPTtwEYs/3Ir/p+11c/mIS
         HK2wwZoCUdbIISE63nN1tKpkmDutDW9iq0SIuUPh4Fi0hyzEporbrUd71ACnROY8MF5A
         KvmCDwzArkRjLe827L0b1Emw1DZfceNJM0NOxLYrUtm9D8gGB2oDVz6N347ysAiomGtv
         sJJvbzfXfuZ4y070hR6dq9mtchy/vI83/jQHBXDKCPtJWObGwqoxMtu+sGl2NoPx/zkp
         f/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WedDbKscds1ScdlD9Vgo8BPtCth3GHq3H8QxE59GeR0=;
        b=a1LbUe9Gh5UTI9alw7QcLV/vza3vdqXTonnND5kSAFAe7/xIoJBs0Z8UD+0yeUVHn0
         4Jeq+fMuRBof5vCIMYeZ1neYJCJDpFg83UNuSBep31h7ohB/mezanGtESinireZXuK7A
         NnWqe5fDIreXKbbmsxxnO1C8NOU8UN83ccVuPUZ+RpdD1SfmbqcpRNDlafZckqSwBWpX
         rynJ/fLAbOvPbGlqH7Pl8/C0vnds/GvfwwdyiJ4RibjVFFs/P42Ay+Vn5wrDChrs6IQH
         L24+0sSORIFVvuBG95UFGWJK31KrNNDU2BNokC5awDVy+9ewycYaek1P4Ks0PxMOthi6
         gqGw==
X-Gm-Message-State: AGi0PuZCwEfvxTu0WCSx3T96zcr+CCTGeGhcrvSspZHdrd5KBZArAhzN
        PpWB+7sETg8Ui3S9W8Ie8NugB223MJy/lqW226vTNQ==
X-Google-Smtp-Source: APiQypI7DWIapsgX2mpmJ7dyihC8+otTy79jKFraWuScfSK4kCBWYFwG/YLyjIrnGq2ISWt8eTduQN1mYdpFNsX9RRs=
X-Received: by 2002:a2e:89c5:: with SMTP id c5mr1025906ljk.48.1585753667081;
 Wed, 01 Apr 2020 08:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200331085308.098696461@linuxfoundation.org> <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
 <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
 <20200331192949.GN9917@kernel.org> <CAEUSe7_f8m0dLQT1jdU+87fNThnxMKuoGJkFuGpbT4OmpmE4iA@mail.gmail.com>
 <20200401124037.GA12534@kernel.org> <CAEUSe7-ercqbofx93m-d0RNW_dQqr1U7F7JYQ5X81CHSkq4KDw@mail.gmail.com>
 <20200401143427.GB12534@kernel.org>
In-Reply-To: <20200401143427.GB12534@kernel.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 1 Apr 2020 09:07:34 -0600
Message-ID: <CAEUSe7-eJrWWH=L+mfj80sMU1S16_yuE4fbeodpvQG0jRU9b5A@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Wed, 1 Apr 2020 at 08:34, Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Wed, Apr 01, 2020 at 07:45:53AM -0600, Daniel D=C3=ADaz escreveu:
> > This worked on top of torvalds/master and linux-stable-rc/linux-5.6.y.
> >
> > Thanks and greetings!
>
> Thanks, I'm taking this as a:
>
> Tested-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
>
> Ok?

Yes, I  build-tested those.

Thanks and greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
