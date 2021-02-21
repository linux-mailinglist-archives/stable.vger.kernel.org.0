Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C132083B
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 05:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBUEDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 23:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhBUEDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Feb 2021 23:03:43 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974CBC061574;
        Sat, 20 Feb 2021 20:03:03 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id h8so9605051qkk.6;
        Sat, 20 Feb 2021 20:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YCBlIveawCHb5Ra4kWySdRysMcOqPyJyzUq0Stqn3vo=;
        b=bjDx0vkPPI2UuQ5FooqKrfBugut01qTsstarmkiIzZ/WNQww6XehcCw0BjSAiI9vB/
         KJqD1rGBdNXXEU6HQrmnMYNjLENNpoc9Mj6bCbdn/01R4mNXKuP0EXGdSThsy3CCK2lY
         5191kMEv1n97DHvGPAqkF7Att+sYHnxml4y42skFmyehBl50I9teFSk/BZZrBlzYxeci
         LMPl4WDKwCi9jxdBhEdeJZZsPCcFRSdGeXSgsm/cu69nTojvj+rOcj68PNLie1sZRcpu
         cvID8XmgGGjffTnkTdR6yil+girTeFzLjPrmp0YC9XHfWEf/WTSv8DaZaNKmLk55rpOh
         4DFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YCBlIveawCHb5Ra4kWySdRysMcOqPyJyzUq0Stqn3vo=;
        b=DxlmRvJ85+ATPginpDomQ0kPDsastzNVuOYSUAGIFp5Kb8vE1dnQiSJH71AL4vfLNk
         0Hu+XH9ULwI9cySsZRDS9eE8dYRRPlM9S7G/coeSZdm7MD0luHdt0t5mjj4lGjsjHGe0
         ChLZ+FKYi9J+ngnWEPZJBLESTc6AS8+Nfjz0JinwFJt4BYqhwEdBeCS9UgM3U1gM5vQE
         1yY8y27DXLp/5d9335auFTdFPtO56PU1bjbxIih7TEtLUjvmAst0MemYXs6+2YZiWL/P
         IyBOpGP20OmNkWRco59BeH1SVuoMYToB6APmOK49K11/cPCueqpJcEvyg6GDRp1kjzVi
         syFQ==
X-Gm-Message-State: AOAM530HCk0WTUvcXa/uBOMBHCV+ZRhKgZ6kxlbH6AwNxhbmk5fZDTZZ
        vNSSSBAw2ee9tA65EkkZfy+2emzMkD7IuH7yXOJidPN2OTiczAOL
X-Google-Smtp-Source: ABdhPJxIaXW7yoWbfuIvKnMTGaP1xH/QZrjo6n3gyTvAH950oENna13caA41o3lGlY/Q+KZcxxXGSLh7e/ETYK9KLIw=
X-Received: by 2002:a37:bd01:: with SMTP id n1mr16338643qkf.469.1613880182572;
 Sat, 20 Feb 2021 20:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20210220081231.10648-1-yunqiang.su@cipunited.com> <alpine.DEB.2.21.2102201515350.2021@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2102201515350.2021@angie.orcam.me.uk>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Sun, 21 Feb 2021 12:04:38 +0800
Message-ID: <CAKcpw6XLnXpg_0H1is1KnaEdTqc897GUn4ubV9PkPOSj9rp92g@mail.gmail.com>
Subject: Re: [PATCH v3] MIPS: use FR=0 for FPXX binary
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips <linux-mips@vger.kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maciej W. Rozycki <macro@orcam.me.uk> =E4=BA=8E2021=E5=B9=B42=E6=9C=8820=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8B=E5=8D=8810:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, 20 Feb 2021, YunQiang Su wrote:
>
> > some binary, for example the output of golang, may be mark as FPXX,
> > while in fact they are still FP32.
> >
> > Since FPXX binary can work with both FR=3D1 and FR=3D0, we force it to
> > use FR=3D0 here.
>
>  This defeats the purpose of FPXX of working with what hardware provides;

Yes. It is some like a workaround.
Should we add a new CONFIG option?

> R6 has the value of FR hardwired according to the FPU configuration[1][2]=
.
>
> > https://go-review.googlesource.com/c/go/+/239217
> > https://go-review.googlesource.com/c/go/+/237058
>
>  You need to fix the compiler.  In the interim you may be able to use
> `objcopy', `elfedit' or a similar tool to fix up the broken existing
> binaries if required.
>

The above 2 merge request of golang are just for it.
This patch for kernel is to support the current exists binary that we
cannot modify.
For example, use the kernel of Debian 11 with the userland of Debian 10.

Without this workaround, then, we cannot switch on O32_FP64 support.
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D962485

>  NB I suspect there is something wrong with the linker as well, because I
> would expect the FP mode of an input legacy object (that is one without
> GNU attributes or MIPS abiflags) to be interpreted according to the legac=
y
> ABI requirements, i.e. o32 =3D> FR=3D0, n32/n64 =3D> FR=3D1, and the outp=
ut GNU
> attributes or MIPS abiflags set accordingly.  You need to investigate
> further what is going on here.

Yes. This is a problem that I will inveset.


>
> References:
>
> [1] "MIPS Architecture For Programmers, Volume I-A: Introduction to the
>     MIPS64 Architecture", Imagination Technologies Ltd., Document Number:
>     MD00083, Revision 6.01, August 20, 2014, Table 6.4 "FPU Register
>     Models Availability and Compliance", p. 87
>
> [2] "MIPSAR Architecture For Programmers Volume III: MIPS64 / microMIPS64
>     Privileged Resource Architecture", Imagination Technologies Ltd.,
>     Document Number: MD00091, Revision 6.03, December 22, 2015, Table 9.4=
9
>     "Status Register Field Descriptions", p. 215
>
>   Maciej



--
YunQiang Su
