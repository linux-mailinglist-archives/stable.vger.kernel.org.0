Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B83D65A5
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbhGZQou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbhGZQoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 12:44:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43541C08EA4A;
        Mon, 26 Jul 2021 10:06:04 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id x192so16044271ybe.0;
        Mon, 26 Jul 2021 10:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W0uBidQDo1k3KgJjTsK5eifJjd4NTwvKhaZagQk8Cns=;
        b=JWK2eKIhXJQSRNxf6JVQTk+juUwxRErssXxBbIjcA8IKqvFQDM/Z3foZDXYxxkjMDy
         qh877fyC5q0MuvfRHZBIt6SemYTskypSuDmivskSSDI2UmpLBndGHxEhVJvKztG2CGqQ
         7fWNMHvq/N1MheaPtfnKHzFlQJBoQ4NPFgzN1Asa+N2T82Pce+r+6fSYP2vewaFwMsjD
         h5/FuxIvabLjOfX1P7KVp7XuFiKvSpSYnVq096grABOPE1QPFCFTBN8Fv8fgon6GX41C
         cXjmJ2jMd2vtWnaoLZKllyzuI/MeUlAWClkxvo55mkme9A/5GRAI221T0sKjCOeGU8Tq
         /o0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W0uBidQDo1k3KgJjTsK5eifJjd4NTwvKhaZagQk8Cns=;
        b=N8OefARsN/U5KGM6BK/s79RTZd/TMf45CrsX6rGI1jlyCWpNAJEqT+YBEADE4EmeiZ
         WetarQdEBnQnhw6cl3yYNZ7OG12S2EKmgR2BN2Fm2pkp6MTzkUpr/ezTZvkr8o0bPRC9
         wX+DTA8v1plO5qSAOvIBYZOC3t1warahml46Iv68ULRYttIx+FBKeM60ytsBrNyZi+OT
         w15FauCoCKsuSy8MD2Y9xkjKMKTYw/HKWOZtFKKz4KssdUf0im5fhkjElN22UgzVBRHb
         hHBdIWQeyFuc6dUKP6JN9WyNTiIJxZD5Vz8QY8qhXVLEyls69f01NGZ9/LTDP+dRm+3S
         31Jg==
X-Gm-Message-State: AOAM533vF00WC+6dZMU/L+N1paINWQ9j74/4f038JKbYFif4v+1AK2L+
        00O7Mtq6s0CT9Q3iIETHMLEqtpAHMWO1kKEg+nk=
X-Google-Smtp-Source: ABdhPJxrTFXd53TE3bMIC8WCAgmIrcouM/V6eoNsr9D3Wj0yPohsRZbPte/fnZR2oWciaCLOSGOVMY3/7AB1yLCI2sk=
X-Received: by 2002:a25:250b:: with SMTP id l11mr4728034ybl.342.1627319163507;
 Mon, 26 Jul 2021 10:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153846.245305071@linuxfoundation.org> <99b34fe9-0f1f-c94f-58d5-cfb43de98d76@linaro.org>
In-Reply-To: <99b34fe9-0f1f-c94f-58d5-cfb43de98d76@linaro.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 26 Jul 2021 18:05:27 +0100
Message-ID: <CADVatmPpBKtaUtzU+APGvNE_1pqgcmXYovWOqrt8qJkRqLM25w@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 5:47 PM Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
>
> Hello!
>
> On 7/26/21 10:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.13.6 release.
> > There are 223 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.13.6-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.13.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Build regressions detected across plenty of architectures and configurati=
ons:

I was going to report the same but just noticed that Greg has pushed out -r=
c2.


--=20
Regards
Sudip
