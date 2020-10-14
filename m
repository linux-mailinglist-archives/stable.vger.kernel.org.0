Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E53728DB13
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgJNITv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 04:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbgJNITn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 04:19:43 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C7C05112D
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 01:01:01 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a12so1900527ybg.9
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 01:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sl/F/hVqmIdJdfmMDaUlmniXiqDoT7Cd5JySCRFUZ/E=;
        b=qTgL12F8iY9y0u0LT9fJ2I/GWYZfa2uxjY9Cc0hkYC8s4n66R5/yoZ6je3VIOf6s1E
         uO06axd/wyoyxppj60kkPJ2zypj/I5LgFDjMzY1MF6LmORopp7dgyOhgS4sFqklsfp/m
         yYIuZmppNkVdarRGwznrKAtsV7IbTeEBsMT7Socou1L/YUDNYiMggUo2OesoNahiYKQK
         e/8HqzO0z2Cdkg8T++yJYPoyTFq3NLCg2fFteTkNBmh9/2vhTpHBWDqSpAGPRItMFlM0
         D+qsH33LbD1UsvaZYXSrRiQCmt7Kgi4ZVqxgASPAFc57crTG9dESRDFYBTc3GQGtY4td
         lX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sl/F/hVqmIdJdfmMDaUlmniXiqDoT7Cd5JySCRFUZ/E=;
        b=Wx2f4pyWYGH8EVICfjOHWdVBUNh/UUWPRq6rxT2JqnbUbSqKmJaFi+7ypZKhAFC4S8
         Pq9ut3sjveIOOm59h3ZRTal4Mlz9F91Tmo6S2QS91rHuhvBQEZsOgsEuWtMaYafS0k+6
         RCgpM/dvfbQ+uh+ygxMA5hOusUtHbmMPWTe5/rzjKg03gqg9pX/scDxgYpGKMn+hvRj0
         M4s1HKZuFAGy6WVeKX5PnZQVYJl9V346GZbthY5LgUV0Fa6h36hBSLnqjjDMzNlY1jxa
         +JFU+1FBUUZfgqd69zV+YmBPHMNvVuRj3LA2e9C84Uy8usIh1X1GId8gOR6Oa+l0sJiV
         aoTA==
X-Gm-Message-State: AOAM533uuYqUqNKGbJTn+UBxNZXUfIEbEwn7BFZwJmCHvfLdXsP/Khs0
        WWoaOxk8phhi0Wq6UxwJzsmxIN3LkBRSi2rClkM=
X-Google-Smtp-Source: ABdhPJzGvZaG95rogVwPoAYXinkzEhvm9KNjuEYpRi5qPn1FgqVTJp0RbC9hQN+zMR/SYYivHmm9zbWns4gVSB7njaU=
X-Received: by 2002:a25:d6c7:: with SMTP id n190mr5040707ybg.75.1602662460923;
 Wed, 14 Oct 2020 01:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
 <20201013085806.GB1681211@kroah.com> <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
 <20201013134849.GA1968052@kroah.com>
In-Reply-To: <20201013134849.GA1968052@kroah.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Wed, 14 Oct 2020 16:00:49 +0800
Message-ID: <CACT4zj8GW57Ugaaade5BnAeHgo15uf=zbmYNJhxwBygevXLW3g@mail.gmail.com>
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

On Tue, Oct 13, 2020 at 9:48 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 13, 2020 at 07:11:13PM +0800, Ben Chuang wrote:
> > On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > > > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation.org=
> wrote:
> > > > >
> > > > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > > > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > >
> > > > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> > > > > >
> > > > > > Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL97=
55
> > > > > >
> > > > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuan=
ggli@gmail.com
> > > > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > ---
> > > > > > Hi Greg and Sasha,
> > > > > >
> > > > > > The patch is to improve the EMI of the hardware.
> > > > > > So it should be also required for some hardware devices using t=
he v5.4.
> > > > > > Please tell me if have other questions.
> > > > >
> > > > > This looks like a "add support for new hardware" type of patch, r=
ight?
> > > >
> > > > No, this is for a mass production hardware.
> > >
> > > That does not make sense, sorry.
> > >
> > > Is this a bug that is being fixed, did the hardware work properly bef=
ore
> > > 5.4 and now it does not?  Or has it never worked properly and 5.9 is =
the
> > > first kernel that it now works on?
> >
> > It seems there is misunderstanding regarding =E2=80=9Chardware=E2=80=9D=
 means.
> > I originally thought that the "hardware" refers to GL975x chips.
> >
> > This Genesys patch is to fix the EMI problem for GL975x controller on a=
 system.
>
> Did it work on the 4.19 kernel?  Another older kernel?  Or is 5.9 the
> first kernel release where it works?

The patch works on after v5.4.

>
> In other words, is this fixing a regression, or just enabling hardware
> support for something that has never worked before for this hardware?

This patch is to reduce the EMI at SDR104 mode for GL975x.
It changes the preset frequency of SDR104 to 205Mhz and sets the SSC value.
So I think it is fixing a regression.

Best regards,
Ben

>
> > There is a new Linux-based system now in development stage build in
> > the GL975x controller
> > encounter the EMI problem due to the Kernel 5.4 do not support Genesys
> > patch for EMI.
> > Hence we would like to add the patch to Kernel 5.4.
>
> Why not just use 5.9 for this system?
>
> thanks,
>
> greg k-h
