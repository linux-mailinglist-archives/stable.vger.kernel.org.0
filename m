Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A252BABDD
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKTO3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgKTO3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 09:29:54 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E657C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:29:54 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id v20so10231376ljk.8
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vDPBgO3uo8+/dosAedlCw+h4RcP8gEHZLzLWs9uGsho=;
        b=GZldtKaiB6YXXPqkfPYLavH3CBsSoyQ15KZQrz8/Uu1ATyB0SGKdjQjiyY91rlKfc/
         uqkbKThLWLf7SrPZ3jSkEIibfao/BBLdW/5SUgWdjFBhJEteidJ+vJA6JfXQRv0GXOW/
         yRY1YpznbIhMyTEeFMdqs+Fk8T0CKOAmjodr8FI5YmMUF4et2sIGieTZ+uLzEcHAg4lE
         Wncs+IDU9GPiBUQp17KluPU3SIWY3CVzCOs0YBFZF26mFQiag9EUa4pTwoEA6ngSJc4T
         96QXRCKmwuNcGjs67Bjiew74xePxkA1vhcdfz40gCOlES7Li3dQ3Llcz+MZpNi2NBJMR
         FlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vDPBgO3uo8+/dosAedlCw+h4RcP8gEHZLzLWs9uGsho=;
        b=By0AtCsc1hRGiPRNVO+kvHw3qmblEvkT4+iwufdBQ2XFDhnDRCUk7Lr7clP2aDjMNw
         motp5/8rQgMfAIzUDvi/Si3/mX1LgO8cmQfURodPrWba7g4SdJFuyVQCttVA9CDlNq1b
         zPf2D9hjin6x4535vlBusL14KmhBUE1FQPwTTMb6k9QAHuvnptcLyMftFCa7U1c2cT2N
         VSReEzCg4OvT3eYGdQMvB9GILSYHYhqq53k3k9pY3jldq1eijZQjfSjLQG1pvvDKwMLF
         KJuBHZi5U8a9+moAGyl7/Vi3fz1h8Uhf1MVl30oTplQ1QPeugQLMXq2BFBZjeEXgfbh7
         Nvwg==
X-Gm-Message-State: AOAM531YnWXb7MKFV+rEXu1JF2ffbRBRGESSZfB7iFY52nxc8gRJ5twe
        ni5QnOeocasqwHvL3nNblaw0Jo+Bnvtu6x1i0q0=
X-Google-Smtp-Source: ABdhPJxgE26On7V77ILRgIjkavE+qP9nC9aScvDtQWqWj9qPSXmu0AsDCVZLXj+hmEmQ9OzsEoKfyu2ToLOUJuHYPe4=
X-Received: by 2002:a2e:a416:: with SMTP id p22mr8748493ljn.221.1605882591420;
 Fri, 20 Nov 2020 06:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20201120073909.357536-1-carnil@debian.org> <CAHtQpK6xA4Ej_LCKBv6TWgiypzwzFzPy3ANvH8BRw-y_FkuJqg@mail.gmail.com>
 <20201120133400.GA405401@eldamar.lan>
In-Reply-To: <20201120133400.GA405401@eldamar.lan>
From:   Andrey Zhizhikin <andrey.z@gmail.com>
Date:   Fri, 20 Nov 2020 15:29:39 +0100
Message-ID: <CAHtQpK7=hpWLM-ztyTS8vzGDfG_46Qx2vc6q0fm1dDDU3W6+UA@mail.gmail.com>
Subject: Re: [PATCH] Revert "perf cs-etm: Move definition of 'traceid_list'
 global variable from header file"
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Salvatore,

On Fri, Nov 20, 2020 at 2:34 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
>
> Hi Andrey,
>
> On Fri, Nov 20, 2020 at 10:54:22AM +0100, Andrey Zhizhikin wrote:
> > On Fri, Nov 20, 2020 at 8:39 AM Salvatore Bonaccorso <carnil@debian.org> wrote:
> > >
> > > This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
> > > (but only from 4.19.y)
> >
> > This revert would fail the build of 4.19.y with gcc10, I believe the
> > original commit was introduced to address exactly this case. If this
> > is intended behavior that 4.19.y is not compiled with newer gcc
> > versions - then this revert is OK.
>
> TTBOMK, this would not regress the build for newer gcc (specifically
> gcc10) as 4.19.158 is failing perf tool builds there as well (without
> the above commit reverted). Just as an example v4.19.y does not have
> cff20b3151cc ("perf tests bp_account: Make global variable static")
> which is there in v5.6-rc6 to fix build failures with 10.0.1.
>
> But it did regress builds with older gcc's as for instance used in
> Debian buster (gcc 8.3.0) since 4.19.152.
>
> Do I possibly miss something? If there is a solution to make it build
> with newer GCCs and *not* regress previously working GCC versions then
> this is surely the best outcome though.

I guess (and from what I understand in Leo's reply), porting of
95c6fe970a01 ("perf cs-etm: Change tuple from traceID-CPU# to
traceID-metadata") should solve the issue for both older and newer gcc
versions.

The breakage is now in
[tools/perf/util/cs-etm-decoder/cs-etm-decoder.c] file (which uses
traceid_list inside). This is solved with the above commit, which
concealed traceid_list internally inside [tools/perf/util/cs-etm.c]
file and exposed to [tools/perf/util/cs-etm-decoder/cs-etm-decoder.c]
via cs_etm__get_cpu() call.

Can you try out to port that commit to see if that would solve your regression?

>
> Regards,
> Salvatore



-- 
Regards,
Andrey.
