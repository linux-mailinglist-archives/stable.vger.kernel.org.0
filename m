Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED1D37ED95
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387752AbhELUjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377929AbhELTJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 15:09:42 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB9BC0612F3
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:04:27 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id y9so30950692ljn.6
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BvsCPO/20qH/TAyTy6uJ/xOZE61JFh6apd4RBrMk2I=;
        b=HZpSV/mSx5iq9sqEetSpypgP1dEkMzZDOZFZ28yo4xsiw3DvVm0irHd9h7UZ3J4UzB
         FAUGzseLV1hiSHrJjCHfjcKqbHR0nbTfi0T7I9VIQKp75prfF9AvjQF/nlfcVPO1hdym
         rOhbb43WaPnoc9lLuTVU/HjUdNTvH8m/sUkGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BvsCPO/20qH/TAyTy6uJ/xOZE61JFh6apd4RBrMk2I=;
        b=GCaVDRVBUruaPRkXeVWDxyQOlmFqCi1GtC4GOSVvcpa83SIT++r2gbNZErr72Os4s0
         /xH5pgbtMSBPuOf9Ad9o5dAN2EVGgAbFEhAsZ0q3Vv8X4FZ+IBTvDyGO2pdyoVPA6iNe
         VMArXkNv6tYYjEFs7FZDIBiFUxNiHQrfsWXFxWGHzmybvXg3QMU/kAFcFMWCxk5cQlXb
         PcBVJew6kxXHi0XuNpSPgNT65EZIgOmST5HXI4IgXjkTKQRYIc5zuWnAHnaa9F79Xc0l
         FSa9gK0iWafr6BGKISOkLTgJ1kvK6mQDJdKWmFIoYZcPkr9tmpOhxstGVPTVKfX5fBdI
         WqWw==
X-Gm-Message-State: AOAM530G6ourCrHt912c2i1DqyjfdVuLK+K9QqJ9Y2q73BFvXE5OvZHD
        MwlYkLuogn6iY2a9wTwj7Ic/RiOXAm5tT5Ei
X-Google-Smtp-Source: ABdhPJx7kC/XogYR/K8N3GHecGJ5gXBRyb5zUlVQASG5CFTxYYKv7HSjuuHLyBMdMfDNKSmFdZlXqQ==
X-Received: by 2002:a2e:9189:: with SMTP id f9mr9697923ljg.353.1620846265544;
        Wed, 12 May 2021 12:04:25 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id q65sm98998ljb.34.2021.05.12.12.04.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 12:04:24 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id i9so28684576lfe.13
        for <stable@vger.kernel.org>; Wed, 12 May 2021 12:04:24 -0700 (PDT)
X-Received: by 2002:a19:7504:: with SMTP id y4mr24793845lfe.41.1620846264161;
 Wed, 12 May 2021 12:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144837.204217980@linuxfoundation.org> <CA+G9fYufHvM+C=39gtk5CF-r4sYYpRkQFGsmKrkdQcXj_XKFag@mail.gmail.com>
 <YJwW2bNXGZw5kmpo@kroah.com> <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
In-Reply-To: <CA+G9fYvbe9L=3uJk2+5fR_e2-fnw=UXSDRnHh+u3nMFeOjOwjg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 12 May 2021 12:04:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj8jOJtKpw-Jsd043sjdL=rPnOD8uD8Tf84_Q36iu_ewQ@mail.gmail.com>
Message-ID: <CAHk-=wj8jOJtKpw-Jsd043sjdL=rPnOD8uD8Tf84_Q36iu_ewQ@mail.gmail.com>
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:48 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Linus's tree builds MIPS clang successfully.

Note that this might just be a random effect of inlining or other
register allocation pressure details.

So it's possible that upstream builds mostly by luck.

The "couldn't allocate output register" thing really does seem more
like a compiler issue than a kernel source code issue.

             Linus
