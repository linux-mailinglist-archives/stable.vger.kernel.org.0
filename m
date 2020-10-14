Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A012528DF23
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387851AbgJNKmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388187AbgJNKmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 06:42:19 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0487C061755
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 03:42:18 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n65so2230992ybg.10
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 03:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KElkZoFa4d1KSSehw8G7Z2lZNXTO8bW78+cRormbQ8M=;
        b=k9tKAfwnD8JAp6I+2KLmQkRsfuWe9+HAUq+8FV/QVZfws/SuGTc34ezXYFPrBfdiB8
         F3c1ZFksbvPTFsqhZRF++ZyfyeKS2BTooMTZebkcNNaY315Jbmv8uJ1Fm9Ep3qkAb8kS
         42CAeYy8pG1dwBxJF35m9u5lVAp1UpcuODoqkAKciGlZoGe4ZY8bQ9vGu7Hax1cDdvUa
         Ot5ki4PrGTLOhwagx/jVv/+YeQCaNc29pKDVp4wnbsMT9AifAp7YZPzdcUasYAGzdTC7
         LwTBJ1HVywNWYxI7039oCgxXGOwqKIqYdHpdiyYmZ9kz75bVen+k/mNzNnCzjHNzMDMk
         Himw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KElkZoFa4d1KSSehw8G7Z2lZNXTO8bW78+cRormbQ8M=;
        b=POum/RDLMbcBUu6dbJukx2BTU0n6ZFg8+EGSK0IAk/qaI6U3qHRBweO9Op1YiPpM4l
         yChI9e2SVxx56U2XSdB1lI7nhimV7bMqU9mlWEjo00ngposIsZS2sykk3D0kp5BIXNwB
         BujyUWu4Z4JktZifjPJTkv5OhWWpUhkHlE476uWrOpkRR3TotK3ST4Gb9+sbEvFnkYkc
         P3tOdIcBK0SGvQ+AvvjoFI2djMqiJawOqDbVUr7sQQQWO+7r7+i2s7Uzu8oGgvpevdjQ
         lVqkKVexmcU1HhlHTZJKSoufO/o3v3EW5MqiPcW9ene6si6vAevJccOUxhl14DC1PAQ2
         IoOw==
X-Gm-Message-State: AOAM530xh+m92EtwAKR5daJMV715KAgJ4gjyGvk01e8m0N23hInzo4wD
        nikdvk6q4Snmc0KACM3L4tZ68PFLjEK+uOevC5o=
X-Google-Smtp-Source: ABdhPJztB8mbCysuMtcSrvr3K/JRIKbfMOPYqjPTRZVNvz23RudDvJpmLI5ViurISOls7mVyMzgmS/JRxYNW+AnWLQo=
X-Received: by 2002:a25:c786:: with SMTP id w128mr5867164ybe.135.1602672137947;
 Wed, 14 Oct 2020 03:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
 <20201013085806.GB1681211@kroah.com> <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
 <20201013134849.GA1968052@kroah.com> <CACT4zj8GW57Ugaaade5BnAeHgo15uf=zbmYNJhxwBygevXLW3g@mail.gmail.com>
 <20201014081119.GA3009479@kroah.com>
In-Reply-To: <20201014081119.GA3009479@kroah.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Wed, 14 Oct 2020 18:42:06 +0800
Message-ID: <CACT4zj_uS+Ziip0EZa32+PGVLC0ZP7+=MbovrUR+rCwe6r5_4Q@mail.gmail.com>
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

On Wed, Oct 14, 2020 at 4:10 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 14, 2020 at 04:00:49PM +0800, Ben Chuang wrote:
> > Hi Greg,
> >
> > On Tue, Oct 13, 2020 at 9:48 PM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Tue, Oct 13, 2020 at 07:11:13PM +0800, Ben Chuang wrote:
> > > > On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundation.org=
> wrote:
> > > > >
> > > > > On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > > > > > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > > > > > >
> > > > > > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > > > > > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > >
> > > > > > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> > > > > > > >
> > > > > > > > Set SDR104's clock to 205MHz and enable SSC for GL9750 and =
GL9755
> > > > > > > >
> > > > > > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > > Link: https://lore.kernel.org/r/20200717033350.13006-1-benc=
huanggli@gmail.com
> > > > > > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > > > ---
> > > > > > > > Hi Greg and Sasha,
> > > > > > > >
> > > > > > > > The patch is to improve the EMI of the hardware.
> > > > > > > > So it should be also required for some hardware devices usi=
ng the v5.4.
> > > > > > > > Please tell me if have other questions.
> > > > > > >
> > > > > > > This looks like a "add support for new hardware" type of patc=
h, right?
> > > > > >
> > > > > > No, this is for a mass production hardware.
> > > > >
> > > > > That does not make sense, sorry.
> > > > >
> > > > > Is this a bug that is being fixed, did the hardware work properly=
 before
> > > > > 5.4 and now it does not?  Or has it never worked properly and 5.9=
 is the
> > > > > first kernel that it now works on?
> > > >
> > > > It seems there is misunderstanding regarding =E2=80=9Chardware=E2=
=80=9D means.
> > > > I originally thought that the "hardware" refers to GL975x chips.
> > > >
> > > > This Genesys patch is to fix the EMI problem for GL975x controller =
on a system.
> > >
> > > Did it work on the 4.19 kernel?  Another older kernel?  Or is 5.9 the
> > > first kernel release where it works?
> >
> > The patch works on after v5.4.
>
> You are not answering the question I am trying to ask.
>
> My question is:
>         Did this hardware ever work properly before the 5.9 kernel
>         release.

Yes.

>
> > > In other words, is this fixing a regression, or just enabling hardwar=
e
> > > support for something that has never worked before for this hardware?
> >
> > This patch is to reduce the EMI at SDR104 mode for GL975x.
> > It changes the preset frequency of SDR104 to 205Mhz and sets the SSC va=
lue.
> > So I think it is fixing a regression.
>
> A regression is when an older kernel works fine, but a newer kernel does
> not.  When that happens, you can point to a specific commit and say,
> "this commit here broke this previously working hardware".
>
> Is that the case here?  If not, this is not a regression.

With this definition, no.
Thank you. :)

Best Regards,
Ben

>
> thanks,
>
> greg k-h
