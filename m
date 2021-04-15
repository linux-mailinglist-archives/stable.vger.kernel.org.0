Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D775A360230
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhDOGPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230164AbhDOGPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 02:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 025266146B;
        Thu, 15 Apr 2021 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618467301;
        bh=11Y+QrdKsNHVqadmmuYacLdywwlCfU3NvE8zhaLxRsY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Vb0xCy9rtsu0/n/gcZ9qfwEMR7zc3gduFw8Srae3qrdjYkeFMqJEJYKsWRJyVy2Lb
         ePKTjvTcOfIiXCQX7tS2KD7pP8TNipyfpdSvb8mZTdd3XCOxe73ub5I8Ytfhg08Usp
         4Y8oooKZbuMGyRo0P3po515CWkR4XQLuRK1kpL62Nw/Sj5sSLyGLWPlVeyWRPOdtsF
         365eIj4AtyBn3qElsCixhRb4s2Qr1oiNzMEH8cwPi/ej2cRSqDrnAIO2uBvpvEtoPE
         ZCpIA9WqALOnJF7gUAYJh/5TPWRx/vwZqKpPRpY0NRfpQbymV9cDudY0dOQccp/fQJ
         YfLAcRKDfHv2A==
Received: by mail-io1-f50.google.com with SMTP id b10so23107911iot.4;
        Wed, 14 Apr 2021 23:15:00 -0700 (PDT)
X-Gm-Message-State: AOAM533zIfDLLSjhUzHam6vE2JF3ydgVZHVtT8jlBmfvAlKOq6a/EXTg
        2O/FD0xmiq6zh4V2fVc06Qvvr3R1DJ5vf02zrJU=
X-Google-Smtp-Source: ABdhPJyYi8cibKwW7Ar+xzRNsTxcG1vnGF7v+XxVAkGDnAXLt/PkPRzsuieiedMDZEdKlalHs6s65sU1ImoYxHAy5HU=
X-Received: by 2002:a02:6a09:: with SMTP id l9mr1466825jac.57.1618467300418;
 Wed, 14 Apr 2021 23:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210412033451.215379-1-chenhuacai@loongson.cn> <alpine.DEB.2.21.2104121604150.65251@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2104121604150.65251@angie.orcam.me.uk>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Thu, 15 Apr 2021 14:14:48 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7fPhA+vKNAYNdVsjZkU75CaVv2btpwRYh9E4XcX9h14A@mail.gmail.com>
Message-ID: <CAAhV-H7fPhA+vKNAYNdVsjZkU75CaVv2btpwRYh9E4XcX9h14A@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Remove unused and erroneous div64.h
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Maciej,

On Mon, Apr 12, 2021 at 10:06 PM Maciej W. Rozycki <macro@orcam.me.uk> wrote:
>
> On Mon, 12 Apr 2021, Huacai Chen wrote:
>
> > 5, As Nikolaus, Yunqiang Su and Yanjie Zhou said, the MIPS-specific
> >    __div64_32() sometimes produces wrong results, which makes 32bit
> >    kernel boot fails.
> >
> > I have tried to fix theses errors but I have failed with the last one.
>
>  I think this is a weak argument for removal, isn't it?
Yes ,it is weak, but I'm not able to fix it, could you please help me?

Huacai
>
>   Maciej
