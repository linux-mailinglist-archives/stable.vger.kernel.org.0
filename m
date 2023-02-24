Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083D86A233A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 21:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBXUnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 15:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBXUnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 15:43:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9BE1042C
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:43:23 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cq23so2268034edb.1
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wh95Rgg4YcfKm/rGes24KRLFGSCx31GDq9PEvrBLE2w=;
        b=HDl3QpnsHSrQh99PiNmsE/a34XldQI4WWD78I7BQjyE9b9z647fzjLVaDgFu1bKMnU
         CiPshUbbkFbN4oWWR4oxeir5QCWQhI+SyuVY66c4rsVlx08kt1P6eeNP3HR4yAy33qpy
         ko5w9buE6lBG4AzV6whLaV0OnBOseRCGdf1YM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wh95Rgg4YcfKm/rGes24KRLFGSCx31GDq9PEvrBLE2w=;
        b=EYpgfBt9P/rRD92YsFpoHsdjPhQHu19pu8Yg/cocL1Adw8KhBUTjBtH4en5nlDaJuQ
         rRhL//QSQlv4zUFIzUMWkJow2kqRR96EyZ0O1PVx+0NHsaDFwPSAHs1qLVGKE/lHs8Go
         ho2HNhHi/bmJtgKYFmDRIQWGqe0Zo92rJJGJbJ7v8m0CCGC7vzXVi80L1zGNEXu5Qq7E
         WQ/h64fSYPvVE18NEqXgYabUktBQi6D3qaWb5k6AXhb6MDyEIhNgFQHgXWVOmCpURNWt
         4SRYT6k4Z4TH4LhEr/RxScES6zmufqZWfhSNyJ5/H9kXsLL5Rn7w1l9ni0z47t6Tgzp4
         7ueA==
X-Gm-Message-State: AO0yUKXqiJSI2ui3iFc+B+AEdCr2rI6+s3ZVcGHRu2gAl735DfTBwwhd
        N7NtG4G6YxB+D182tZcwEE6WAmO0mi8CcjptTofASw==
X-Google-Smtp-Source: AK7set8AT8cHWCTHOXSbKmOoIqVwoPYRhtP30UhmFi6py7ZxcDnMUeFPwhFxZUdZdzJEbKs+5dAdNA==
X-Received: by 2002:a05:6402:614:b0:4af:593c:bf77 with SMTP id n20-20020a056402061400b004af593cbf77mr12704270edv.33.1677271401913;
        Fri, 24 Feb 2023 12:43:21 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id d8-20020a50f688000000b004a0e2fe619esm134099edn.39.2023.02.24.12.43.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 12:43:21 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id eg37so2022334edb.12
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:43:21 -0800 (PST)
X-Received: by 2002:a17:906:40cc:b0:877:747d:4a82 with SMTP id
 a12-20020a17090640cc00b00877747d4a82mr11917828ejk.0.1677271088924; Fri, 24
 Feb 2023 12:38:08 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
In-Reply-To: <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 12:37:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=whwDyVKYtv+65N=ixfHR82Hxn2gm+VLqNR-PY-de3wXnA@mail.gmail.com>
Message-ID: <CAHk-=whwDyVKYtv+65N=ixfHR82Hxn2gm+VLqNR-PY-de3wXnA@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To:     Paul Eggert <eggert@cs.ucla.edu>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Meyering <meyering@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 12:20 PM Paul Eggert <eggert@cs.ucla.edu> wrote:
>
> Thanks for pointing this out. I added this to our list of things to do,
> by installing the attached patch to the GNU diffutils TODO file. If this
> patch's wording isn't right, please let me know, as I haven't read this
> whole email thread, just the three emails sent directly to me.

Looks good to me.

The whole thread isn't actually any more interesting, it was mainly a
lot of "how did the bits get lost" confusion because it wasn't clear
whether it was some local script or quilt or whatever that lost sight
of the executable bit.

It starts with a report about how the lost bit results in a build error at

   https://lore.kernel.org/lkml/adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net/

and there's discussion about how this has happened before and how our
kernel Makefiles generally should try to not execute scripts directly
exactly because our ancient "tarballs and patches" model never
supported the executable bit etc.

So none of it is very relevant, except in the sense that it would be
convenient if diffutils did support the executable bit changes and we
wouldn't have these kinds of things happening every once in a blue
moon.

Again - there are multiple different workarounds, ranging from "we
shouldn't do that then in our makefiles" to "you can use 'git diff'
instead in the quilt scripts".

So not a huge deal - but it would just be nice if diffutils just
supported the extended format.

           Linus
