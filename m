Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EA723BF63
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 20:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgHDSdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 14:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgHDSdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 14:33:52 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913AEC06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 11:33:52 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so44726143ljg.13
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 11:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkLmvclKDC4NH/baH9VK8NbQ5emijDFqRa7D8TVtths=;
        b=MftHbpqnXQ5Cig7YZqaj4xNohz3zWOfxYlSXieSNZmEPpG+cmx/mU1jMBDg2t+t+WR
         5wh31k/s1R9XNKJEwOcOA6jA/ffc7hdhg7ykGyZsa1eorJ6u99el2r1gDU+nW1mVMyBf
         gYOEsqSC8pHznfc5XiFRm2tag3P79YiWqQEDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkLmvclKDC4NH/baH9VK8NbQ5emijDFqRa7D8TVtths=;
        b=YZlaKhuMBaXdsktYYL4fcWDY+SZqbQfFjusHqKU4340kUAP/a2AswvyoSAf4SGLix+
         1PBaqxgLPHN9UBn0n2/idaT/+RnEHEKfRAfMa/32zmU3XIpH/4N5oUOjSiFkOWCV48IT
         nNCSi7bxMQNCHsvtRKbiaUju0JSuIOp5A8ox2Oifj84SHHauzlFw2TFo35c/yncYyoYS
         Wue8if+XvA/otMKbVCsIUlXkkuIiQiisjGLENhxKg6vXMEqqNaZJ5MyUADwrvg7EV/6e
         dkk3nvA5OYNtaR/VxU3miEcsU43jILCmhY5cYqDYq40X+WLSGDIR2C5UDxN9PnEWb6i3
         DPdw==
X-Gm-Message-State: AOAM531FNzx2Nx3++R9Trd9/s58yfOOeZlc3Onb0OMUzYLkz0GrOW9PY
        I+UrcSFQB46eBtFpgfdK6n/AUa1Wgbk=
X-Google-Smtp-Source: ABdhPJzluQI0UYKjd0+cu+HDITnEL802mfaCzAiNM5BbUwCSFcIq6tVQo0a8/7jEu5w7OgIxFspXcA==
X-Received: by 2002:a05:651c:152:: with SMTP id c18mr2982541ljd.15.1596566029097;
        Tue, 04 Aug 2020 11:33:49 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id a16sm6556029ljj.108.2020.08.04.11.33.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 11:33:48 -0700 (PDT)
Received: by mail-lj1-f176.google.com with SMTP id t6so31789789ljk.9
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 11:33:47 -0700 (PDT)
X-Received: by 2002:a2e:8008:: with SMTP id j8mr6989403ljg.312.1596566026687;
 Tue, 04 Aug 2020 11:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200804072435.385370289@linuxfoundation.org> <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
 <20200804082130.GA1768075@kroah.com>
In-Reply-To: <20200804082130.GA1768075@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Aug 2020 11:33:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
Message-ID: <CAHk-=whJ=shbf-guMGZkGvxh9fVmbrvUuiWO48+PDFG7J9A9qw@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 4, 2020 at 1:21 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> So Linus's tree is also broken here.

No, there's 835d1c3a9879 ("arm64: Drop unnecessary include from
asm/smp.h") upstream.

But as Guenther points out, I have a few other build errors, but they
are (finally!) entirely unrelated.

                Linus
