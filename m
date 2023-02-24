Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223466A234A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 21:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjBXUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 15:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBXUwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 15:52:05 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0156E5DCF6
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:52:03 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gi3-20020a17090b110300b0023762f642dcso496050pjb.4
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 12:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=55mt+kuo5dWkNyekw++UMrCQ9c2eDryyoLQGraQZpU8=;
        b=PQ3//o9BqF/cCeFQ3Q1Xv/rY74hCW/eRKF38tLjFgGOCR99BqrWq0Z1TmDTmssrMtw
         KRsVOpJ9a+/eAyMeQAoEOu751ZJEZA0gMoES3cjoTU7FtwEeDlLdH5ex99hv3OBGxZM/
         Ww+f/8B/pGoMda4TM+YyDvLNPyGEe1cY8hiLLpcvyFB30w3Oa4txe99onuCvANlX9zkp
         GhdR7L1rwM6PQ59DvdRHq3URtyV2+A+jf30pFRrpM98vbViML4r7tz54JNrViqzhQV6l
         o2wvooKm2S3ozFKY2MzzjS7CVFlm1ZKR7jXKqPop9Cx1PRni7UE3dnNcqGsmchSjvdOm
         acJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55mt+kuo5dWkNyekw++UMrCQ9c2eDryyoLQGraQZpU8=;
        b=SGy7J8s3M+Y/3V3L+cGJMQCsRkv02G30OjjjUUprNYzgwFU+XeNuStPQZnCP5n8yCV
         nAwWW3tgoNoBoWUeIlMqMeKwqJtAOBIf1vaiR9kjOYXuFDgsh8igGaYZrL4JJeQxJsxK
         UDqn/rsl93ls1XUm+AAK/rBU0gUu6hgROFAcFBTrstC5cfQm7UFPm4qMJakWQZFzzdOY
         C3gYhdQ21pGRVf1ZKcqENd1E0WYsXVe1vXiF9e0rVIrVOiIGwyxIjbrU1dIww4R5vbTr
         w5MK02+R9yTuEfaT5gPSW0fcqrKsFOATrQhKsPlOe5UvUBxXXY3KRwXN+wboxLuyJQrh
         WJMg==
X-Gm-Message-State: AO0yUKWNCkSaXbeilRwzW1A5gSNwkI4GLamjZ5EEDLYvW3FCMTSUCRzC
        fthPSF5wH878e25c5qZHUxk3NQUqgsBI4Ih2+ji41MvGqLdMOpJFUiM=
X-Google-Smtp-Source: AK7set9jwyl5cVUNpA1/XKIW8Cs28uP4ayT0pKHGrhJEcpKF3dfiREuG6JLl2PYLQ5lISV33j6Q9QZmQVEAdjse1W7k=
X-Received: by 2002:a17:902:b410:b0:19c:b7da:d41f with SMTP id
 x16-20020a170902b41000b0019cb7dad41fmr2274382plr.11.1677271923389; Fri, 24
 Feb 2023 12:52:03 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiZ9vaM23eW2k4R-ovtcWLyL8PWvnCG=RyeY4XXgZ6BCg@mail.gmail.com>
 <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
In-Reply-To: <03dac14b-ed62-3e2b-878f-b145383ea9f8@cs.ucla.edu>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 24 Feb 2023 15:51:51 -0500
Message-ID: <CA+pv=HPfatoLpQj77HWkzsg+tHK6AVRoR7h-eSY4=EyAFuocrA@mail.gmail.com>
Subject: Re: diffutils file mode (was Re: [PATCH 5.15 00/37] 5.15.96-rc2 review)
To:     Paul Eggert <eggert@cs.ucla.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        stable <stable@vger.kernel.org>, patches@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>, rwarsow@gmx.de,
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

On Fri, Feb 24, 2023 at 3:20 PM Paul Eggert <eggert@cs.ucla.edu> wrote:
>
> On 2023-02-24 11:16, Linus Torvalds wrote:
> >   GNU diffutils have never actually grown the
> > ability to generate those extensions
>
> Thanks for pointing this out. I added this to our list of things to do,
> by installing the attached patch to the GNU diffutils TODO file. If this
> patch's wording isn't right, please let me know, as I haven't read this
> whole email thread, just the three emails sent directly to me.

For what it's worth, this looks good to me.

Thank you,
-- Slade
