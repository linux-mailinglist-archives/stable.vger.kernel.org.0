Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FC223B50B
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 08:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgHDGeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 02:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgHDGd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 02:33:59 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA12C061756
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 23:33:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w25so6835326ljo.12
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 23:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bOw1vNO+rBAdfNfXbQHgCWtEAvgqAeThDHj8plQEESM=;
        b=EUL5ylNHBLe44agjMa/72UTje/FpJoetElyd/AsVw8fo8LyPg4TcMM2GNtk5RBJI8x
         90zB0xpK0FBsZ2oEQI5oO5LBCyeE6aTvIuJ4skQNVAsL3gVbH4ntEBkAVWbQyZ5JJ2TD
         dO8NEgOz1WDVOYeDHhhuCXPk49mEL5WyoSl8M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bOw1vNO+rBAdfNfXbQHgCWtEAvgqAeThDHj8plQEESM=;
        b=TfoyvUM0dMt/OJXcpvI89mKL+7nZOMRtYDa6COkYXV1c21JWqRbV1HELp83ZGZaVF2
         HZEE1bPUjPfKKdy6Bl9ypV68fZBKO/N/HIfdKHyfO88wzf2GB76KqXzJ3gI7QK0sDz4s
         DVcbYULNLZdUbmlfcP6OgbYgzjZQGLh2qo0io2WBx1kSg2pRLezQLK/zfBzpJaCyxAGR
         5TrUlErPjfYpBShyOcp9geZiedziZ2ChTAqVqKwh03VzmYOeHKtR2yd9v94/da1oI2E4
         4zW0zv8gtefwAv6Fb62UdtjSt+c877PTJj/2vAH0uXPab4veUE46unE6XSLTVjlFRjPO
         M8cw==
X-Gm-Message-State: AOAM532KcbdV4qoCvhkZNrXEhNL8V52Z8Xt1M3Ud5dkXty5q+oGLDf3j
        QOT9JWrE1rqL9Cczs/9L28vEqsL8fqc=
X-Google-Smtp-Source: ABdhPJwPAuDCqU3zC+c6S3VnZNRjiZjbok0Ok4N5LwGsrCmcALMpuMzb6H6F0VKYR6r7k3zs0pEtaA==
X-Received: by 2002:a2e:9905:: with SMTP id v5mr5246852lji.42.1596522837524;
        Mon, 03 Aug 2020 23:33:57 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id w7sm5845977lfe.41.2020.08.03.23.33.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 23:33:56 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 185so32062002ljj.7
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 23:33:56 -0700 (PDT)
X-Received: by 2002:a2e:9252:: with SMTP id v18mr5717733ljg.70.1596522835731;
 Mon, 03 Aug 2020 23:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200803121902.860751811@linuxfoundation.org> <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com> <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
 <20200804030107.GA220454@roeck-us.net> <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
 <20200804055855.GA114969@roeck-us.net>
In-Reply-To: <20200804055855.GA114969@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 23:33:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wguY19e6_=c3tGSajC6zxivJ6vH+MsbGDUzSMe5NFkJeA@mail.gmail.com>
Message-ID: <CAHk-=wguY19e6_=c3tGSajC6zxivJ6vH+MsbGDUzSMe5NFkJeA@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 3, 2020 at 10:59 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks.

Greg, I updated my internal commit with Guenter's tested-by and some
more commentary (I had tried to break out that file entirely, it gets
ugly).

So it's now commit c0842fbc1b18 ("random32: move the pseudo-random
32-bit definitions to prandom.h") in my tree, and I've pushed it out.

               Linus
