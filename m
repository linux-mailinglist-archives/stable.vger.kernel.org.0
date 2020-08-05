Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D61623CDFE
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 20:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgHESEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 14:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729159AbgHESCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:02:03 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F967C06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 11:02:03 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x9so48760812ljc.5
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6O0Je/DALynD8xrcy5F8ovIlpP2BIIuUrwkKTqZEB0=;
        b=TwuFz2Csj8S8tUXG01UOeW7C+pBdX/X5QDikPbQzn5Kqk/HmRDlnzqmYtwm0wssMfA
         gZLb0FsZS8pej72cSFjZaCsvm3Q4AMV35e9TANq4fHh1wTeb4XYJPJxX/1tDKv8HMsyW
         A7HULq4It/ZbgyWzZA3KFCar/TC7JUMoY/Vng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6O0Je/DALynD8xrcy5F8ovIlpP2BIIuUrwkKTqZEB0=;
        b=YPcayCLMLae9Uk+hm50r8A/6YCeaSDV5TiYG8uggSQJz2fjk+zr5tWMm2HTB+a2SME
         JRK92TjnWeoUxASP2DhDQM18nzaxqxIK9cKBCjn3MW4Ixmwsqf/GffOMWbsywKL6YVJT
         5ADBYUdkeEefUr5QiSrGgnRv8SXxQ2jxF5Yf35zZ3mOSth/jY+M1Wny6JJMyMVvvJENj
         APkJ9AZ3HlTQBEc76fJgVNZfutGX3PoMXD2KvjSN1CVxOGQ4oA/1o7rcEXSYT8kbFABd
         sBq9ipg5/GHMafy2vts74TnUYjJ1S6ADhH+YBFCLGtxKeNq0OMXIw34bb2yfry/C9HgG
         jMJg==
X-Gm-Message-State: AOAM532mIMQ/+CJ2uy3o+oHe/NmkJp6a+L2eCbow9orjGvFBHxBDTrUX
        2XcMW9tlq9QZHthJAVvgTBQTyk/Nzzo=
X-Google-Smtp-Source: ABdhPJwn/iTahKO7HSdiig1LiZgblHwZ/VBmaWdptrQTC5V7OlgbiaUJ84fAjlxfLd63PxDp88KTxA==
X-Received: by 2002:a2e:9ac5:: with SMTP id p5mr2069708ljj.253.1596650519598;
        Wed, 05 Aug 2020 11:01:59 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id r19sm1408092lfi.58.2020.08.05.11.01.57
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:01:57 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id z14so11135416ljm.1
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:01:57 -0700 (PDT)
X-Received: by 2002:a2e:7615:: with SMTP id r21mr1889320ljc.371.1596650516525;
 Wed, 05 Aug 2020 11:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153506.978105994@linuxfoundation.org> <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
In-Reply-To: <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 11:01:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1bhyhuJbA5_UbqAnbjqA_hSrmZFqCQrhJ=44P--T4vQ@mail.gmail.com>
Message-ID: <CAHk-=wj1bhyhuJbA5_UbqAnbjqA_hSrmZFqCQrhJ=44P--T4vQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Willy Tarreau <w@1wt.eu>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 5, 2020 at 10:39 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> [ sorry if it is not interesting ! ]

It's a bit interesting only because it is so odd.

> While building with old gcc-7.3.0 the build breaks for arm64
> whereas build PASS on gcc-8, gcc-9 and gcc-10.

Can you double-check that your gcc-7.3 setup is actually building the same tree?

Yeah, I know that's a slightly strange thing to ask, but your build
log really looks very odd. There should be nothing in that error that
is in any way compiler version specific.

Sure, we may have some header that checks the compiler version and
does something different based on that, and I guess that could be
going on. Except I don't even find anything remotely like that
anywhere. I do find some compiler version tests, but most ofd them
would trigger for all those compiler versions

Or is there perhaps some other configuration difference?

             Linus
