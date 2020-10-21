Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308292946F3
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 05:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411755AbgJUD1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 23:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411753AbgJUD1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 23:27:54 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2451C0613CE
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 20:27:54 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h196so543352ybg.4
        for <stable@vger.kernel.org>; Tue, 20 Oct 2020 20:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NHQQTC/1fvdvHmPqhTJvDcGZgDKrGV4UVD2R9wkaIxM=;
        b=NyN7rjdXEmlfJd4riz+XDVwbaSUSxRCKzQPm7gjFCx5p0mENkQaQo8CsaQgkNVMFF+
         c78FNkoiHvwrxJPm1KxVr7waf7+11QDd+Q9m3qMUbi2HsDSi9CC/O5Ai+Qz9RYo1Bogr
         H79YdE3654bfoIR2NRlBOk9UYRyhP4KYFE16+/J55XIYWUQ5d593WA7zRj9G5ay7SFMG
         TlPzoLEzODd6huaj530lrLAyrsp+5qjVzyToOZMptULsiDHI4CA/lBh/P5wwCkXNaJpI
         iuFiivKqC4yIUqdjeAIHfbx9vnr25HpA9TD3lUw0qn1/96sx+ET9LOpxEAnqMaVPrSBd
         u3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NHQQTC/1fvdvHmPqhTJvDcGZgDKrGV4UVD2R9wkaIxM=;
        b=QE4qj3X74ku3yavPwOgCYGCub2IflC3lxAjwsRQP4fv7EgyxgIfs5pfyxzqZgs08bz
         b9YebIp8fYv2Iju7CjHQD0AMEAgk6/4/XGf6085wk8HbXe7yrg2niDBu6mrAywWCAm3M
         UARCzF73xWbSMpeiIK8Kl7FvdiNiIwOvdmANsPahNSCDWJ25Ls9sifcgI7SkPep2pNKm
         XloiV3DX8hhzO/qIu4NupCGPyVxZS8ZkDyqSksGYqibk7mcYsdnVNhhYfftxpgh83xl/
         qdSaMU14swve/orA8ewt0R1jOBci0A4QQaruAPIn4vL08Q1kwhasoLVtDYuWCrudxn/p
         s8Bg==
X-Gm-Message-State: AOAM532QEUScpdYRVPGHawkQU4DVsr54b2w4UA6lds+z5wHlgdNDFlNY
        e4dHi6WUU3Esw+0tEvMHvZAtRJaDTJXXjszLsXM=
X-Google-Smtp-Source: ABdhPJznpHTCZgReVTp1c/N7LADhapaupI1xyYGlmUJO7GQR3jVftEKjw/N8yvipp2Zb/OHQEEjaDj/QHeCuwynL4To=
X-Received: by 2002:a25:384c:: with SMTP id f73mr2086502yba.135.1603250873788;
 Tue, 20 Oct 2020 20:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
 <20201013085806.GB1681211@kroah.com> <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
 <20201013134849.GA1968052@kroah.com> <CACT4zj8GW57Ugaaade5BnAeHgo15uf=zbmYNJhxwBygevXLW3g@mail.gmail.com>
 <20201014081119.GA3009479@kroah.com> <CACT4zj_uS+Ziip0EZa32+PGVLC0ZP7+=MbovrUR+rCwe6r5_4Q@mail.gmail.com>
 <20201014113749.GA3679515@kroah.com> <CACT4zj_fOGjUjj0+BKTZoi+jzy2=wUq4woqbRXMrpOQ+8yWNKg@mail.gmail.com>
In-Reply-To: <CACT4zj_fOGjUjj0+BKTZoi+jzy2=wUq4woqbRXMrpOQ+8yWNKg@mail.gmail.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Wed, 21 Oct 2020 11:27:42 +0800
Message-ID: <CACT4zj9n3Axvqe+f540LYZzHPDC1y3xS-XT7KqvciOOwWskj7A@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 15, 2020 at 9:17 AM Ben Chuang <benchuanggli@gmail.com> wrote:
>
> Hi, Greg,
>
> On Wed, Oct 14, 2020 at 7:37 PM Greg KH <gregkh@linuxfoundation.org> wrot=
e:
> >
> > On Wed, Oct 14, 2020 at 06:42:06PM +0800, Ben Chuang wrote:
> > > Hi Greg,
> > >
> > > On Wed, Oct 14, 2020 at 4:10 PM Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > > >
> > > > On Wed, Oct 14, 2020 at 04:00:49PM +0800, Ben Chuang wrote:
> > > > > Hi Greg,
> > > > >
> > > > > On Tue, Oct 13, 2020 at 9:48 PM Greg KH <gregkh@linuxfoundation.o=
rg> wrote:
> > > > > >
> > > > > > On Tue, Oct 13, 2020 at 07:11:13PM +0800, Ben Chuang wrote:
> > > > > > > On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundati=
on.org> wrote:
> > > > > > > >
> > > > > > > > On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > > > > > > > > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoun=
dation.org> wrote:
> > > > > > > > > >
> > > > > > > > > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wr=
ote:
> > > > > > > > > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > > > > >
> > > > > > > > > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstr=
eam.
> > > > > > > > > > >
> > > > > > > > > > > Set SDR104's clock to 205MHz and enable SSC for GL975=
0 and GL9755
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.co=
m.tw>
> > > > > > > > > > > Link: https://lore.kernel.org/r/20200717033350.13006-=
1-benchuanggli@gmail.com
> > > > > > > > > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > > > > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > > > > > > ---
> > > > > > > > > > > Hi Greg and Sasha,
> > > > > > > > > > >
> > > > > > > > > > > The patch is to improve the EMI of the hardware.
> > > > > > > > > > > So it should be also required for some hardware devic=
es using the v5.4.
> > > > > > > > > > > Please tell me if have other questions.
> > > > > > > > > >
> > > > > > > > > > This looks like a "add support for new hardware" type o=
f patch, right?
> > > > > > > > >
> > > > > > > > > No, this is for a mass production hardware.
> > > > > > > >
> > > > > > > > That does not make sense, sorry.
> > > > > > > >
> > > > > > > > Is this a bug that is being fixed, did the hardware work pr=
operly before
> > > > > > > > 5.4 and now it does not?  Or has it never worked properly a=
nd 5.9 is the
> > > > > > > > first kernel that it now works on?
> > > > > > >
> > > > > > > It seems there is misunderstanding regarding =E2=80=9Chardwar=
e=E2=80=9D means.
> > > > > > > I originally thought that the "hardware" refers to GL975x chi=
ps.
> > > > > > >
> > > > > > > This Genesys patch is to fix the EMI problem for GL975x contr=
oller on a system.
> > > > > >
> > > > > > Did it work on the 4.19 kernel?  Another older kernel?  Or is 5=
.9 the
> > > > > > first kernel release where it works?
> > > > >
> > > > > The patch works on after v5.4.
> > > >
> > > > You are not answering the question I am trying to ask.
> > > >
> > > > My question is:
> > > >         Did this hardware ever work properly before the 5.9 kernel
> > > >         release.
> > >
> > > Yes.
> >
> > It did?  What kernel release from kernel.org did it work, and what
> > kernel release did it break on?
>
> Sorry, I don't know if  "this Hardware" refers to a single GL975x
> controller or the whole system.
> "Yes", for those existing systems built in GL975x controller. These
> systems are no EMI issue on v5.4~v5.9.
>
> "No", for some systems with developing stage build in GL975x
> controller because there may be an EMI issue.
> For those systems, they need the v5.9 to pass the EMI test.
>
> >
> > > > > > In other words, is this fixing a regression, or just enabling h=
ardware
> > > > > > support for something that has never worked before for this har=
dware?
> > > > >
> > > > > This patch is to reduce the EMI at SDR104 mode for GL975x.
> > > > > It changes the preset frequency of SDR104 to 205Mhz and sets the =
SSC value.
> > > > > So I think it is fixing a regression.
> > > >
> > > > A regression is when an older kernel works fine, but a newer kernel=
 does
> > > > not.  When that happens, you can point to a specific commit and say=
,
> > > > "this commit here broke this previously working hardware".
> > > >
> > > > Is that the case here?  If not, this is not a regression.
> > >
> > > With this definition, no.
> >
> > Wait, I do not understand, this is the exact oposite of what you said
> > above.
> >
> > Which is true?
>
> These existing systems built with GL975x have no EMI problems.
> The patch can reduce the impact of EMI, so these existing systems are sti=
ll ok.
>
> For these existing systems, on an older kernel (v5.4) they work fine
> (no EMI issue), on a newer kernel (v5.9) they work fine (no EMI
> issue).
> For those developing systems, on an older kernel (v5.4) they don't
> work fine (EMI issue), on a newer kernel (v5.9) they work fine(no EMI
> issue).
>

Sorry, I forgot to consider some existing machines with pre-installed windo=
ws.
These machines fit the definition of regression.
They will have EMI issue when v5.4 is installed on them.

Best regards,
Ben

> >
> > totally confused,
>
> If you are still confused, please let me know. :).
>
> Best regards,
> Ben
>
> >
> > greg k-h
