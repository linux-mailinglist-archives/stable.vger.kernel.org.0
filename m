Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E369E199DEA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgCaSVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 14:21:00 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39069 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCaSU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 14:20:59 -0400
Received: by mail-lj1-f196.google.com with SMTP id i20so23044121ljn.6
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 11:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uoULL4HJ/4Fp45aaQk4Hu/7pgyNJbne+Y7btBWjm98M=;
        b=CmzsV6h6bpJpOjdOqIiordG7PqBedgrJWUslQaSWFFc0PsAmoW2n9Qmm4fjP+rxipj
         KTlpTC0p6VP22xW/i/jVMikS9NwXnvvz/JiCG+nYjMhKP6k73ZUMogsKMud7bMuFkBpY
         nQrxqOrO+CKYfRRzCAFGQ+yAFURIBGhmcQJZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uoULL4HJ/4Fp45aaQk4Hu/7pgyNJbne+Y7btBWjm98M=;
        b=Dmu/IJNMqnp7wOSnNV2WHMvD6ej1TyufJkk/41xZWwDe8ksCf2uWdHkcxMYNUtlsjC
         pKG2hZMgDea9cDH/MxRdGkyY4g7LE0nfNMBbSjpFb/tULamSUe2hLVX2G7S+gGeRLPrJ
         m3BePe3YTRdHImOx8byFrzq5xvt8HljZyQOucrxO4y8FRH7WNrxpSNfu0TwH1yWxrI9H
         IdtY8y8KjueN4UVu9QjuWtifLsIhgwLMjt+4e7jvZ+EFB7arYDi2iXexH/iq7454oIeu
         1pupxlQKOOR/tBtth6W+JV1EeFsIOGLy4T5AmT+jlJ9Fhv1Pjx6wlBjrnKcCxdgxqjQp
         AKIQ==
X-Gm-Message-State: AGi0PuZfSTiJTj4OPO1O6nCXhN6HW/0Qe9gyL7Jothlc3QES6ivSsReD
        3l5Ny06mfubgjKocPrYIjtYcgISSRMI=
X-Google-Smtp-Source: APiQypI0Uqlb8rMVcML+wS0tjpBWJ29Q2mI0IU0tdmiIuIXJbmGB8qd2PV5bdDgY+pzW/LOsa0SJiQ==
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr11205488lja.243.1585678856052;
        Tue, 31 Mar 2020 11:20:56 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id r24sm1764162ljn.25.2020.03.31.11.20.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 11:20:55 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id p14so23045085lji.11
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 11:20:54 -0700 (PDT)
X-Received: by 2002:a2e:b4cb:: with SMTP id r11mr11392287ljm.201.1585678853923;
 Tue, 31 Mar 2020 11:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200331085308.098696461@linuxfoundation.org> <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
In-Reply-To: <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 31 Mar 2020 11:20:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
Message-ID: <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 11:08 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Perf build broken on Linux next and mainline and now on stable-rc-5.6 branch.

Strange. What is it that triggers the problem for you? It works fine
here.. The error looks like some kind of command line quoting error,
but I don't see the direct cause.

Have you bisected the failure? Build failures should be particularly
easy and quick to bisect.

                Linus
