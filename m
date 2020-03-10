Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3667180619
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJSVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:21:37 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34191 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgCJSVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:21:37 -0400
Received: by mail-ot1-f67.google.com with SMTP id j16so14160370otl.1
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 11:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQ+KXG5Dk3F2Ym0hqQSR5htSfCifQGVz+T0JMvTAuUA=;
        b=u/hp1G4Zn+6D6Je2+RJ5CNNGQf+hIuSQUmT49qiYfK6k1W+R+vbKCRsA7PdQOrRVLE
         Zf0IsfmCjcOI8p4xJIPcQvbq221sNTAzTuViRkNrYKhmDGUbM5z69aASvEn7XJC+5XLQ
         +fMUcSlU9vnXQu/MzK0Uo/29b7eaRbPJQNNWFBzboZbCbHK/Is3EAkfQWC4twuuwgAfm
         bBP8f9xlD9wxQsYKXUM20acDMfGpz5gMr4uoIeBZZXJtZFPRT9dfLkr6BHz2GPJuwAL+
         X+VMTigbXwU2w297SCvQbulrLr8hhBm6b5doNuFlu19kvi+nB/w7jfDd6KYmShjH7S5y
         BFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQ+KXG5Dk3F2Ym0hqQSR5htSfCifQGVz+T0JMvTAuUA=;
        b=b/GXo0XOgkDACDgSHjWkeuWKQ0MenTsvvySE7J5+inp3JfUxL+6ZIE+9eV5aK3DtkQ
         acnI7a7QWwII8ikz3v9D/Zs5k4/nu4Gr6SN5qCRKKvcnhuaLzSOnbIM9fVJ6ooaFKpHS
         z1aNn6bn1gLZqwBxj8AEKOEeXiaVEZGGHHb16wv6QFHZonb62aJGduaxpRyduTwu52vi
         SfWoYZ2Ui2f7U8OHfeaEB28xwJcovXn7lT/cgyOoVwfyR+tj1V/8YCFRCl+y4NufN/kB
         FEbTbpDYyMsKRvicA+SrL3B3pU7NUadaiSKMe/UA/95eAUrcJy4M+GcYJHXAOw3VIwWC
         AOWw==
X-Gm-Message-State: ANhLgQ3nkZUR/KzKUNA5DXikJmoDnMaX8O8X9053iS5CRKr//gGr/PIS
        2LVvly6mwT3dm5ZuTqFNhhj6JuvPqP15Pg7q50YrKw==
X-Google-Smtp-Source: ADFU+vtpQO3rO4eg0koILwt6e5pa8qFoURNxTIamis3w1YLJ8DN9tX3ZNmBAKC2Vx6c6VTofQdo1CvpDbgkhAUIWN9Y=
X-Received: by 2002:a05:6830:13c4:: with SMTP id e4mr18265547otq.139.1583864495682;
 Tue, 10 Mar 2020 11:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200308073400.23398-1-natechancellor@gmail.com>
 <CAK7LNARcTHpd8fzrAhFVB_AR7NoBgenX64de0eS2uN8g0by9PQ@mail.gmail.com>
 <20200310012545.GA16822@ubuntu-m2-xlarge-x86> <c2a687d065c1463d8eea9947687b3b05@AcuMS.aculab.com>
 <CAK7LNARMsO0AeO8-kH4czMuW0Y_=dN+ZhtXNdRE7CWGvU2PNvA@mail.gmail.com> <CAKwvOdmf0V61O5gsuby_50fijrxe=LNh4pTtRGy_8=5637P7qw@mail.gmail.com>
In-Reply-To: <CAKwvOdmf0V61O5gsuby_50fijrxe=LNh4pTtRGy_8=5637P7qw@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 10 Mar 2020 11:20:59 -0700
Message-ID: <CAGETcx930eOFOLjf2zjY5RLvSNnyyESLRv+8M7s=cP8EnMDBLg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 9:16 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> + Saravana, who I spoke to briefly about this.
>
>
> On Tue, Mar 10, 2020 at 8:32 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > On Tue, Mar 10, 2020 at 8:31 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Nathan Chancellor
> > > > Sent: 10 March 2020 01:26
> > > ...
> > > > Sure, I can send v2 to do that but I think that sending 97 patches just
> > > > casting the small values (usually less than twenty) to unsigned long
> > > > then to the enum is rather frivolous. I audited at least ten to fifteen
> > > > of these call sites when creating the clang patch and they are all
> > > > basically false positives.
> > >
> > > Such casts just make the code hard to read.
> > > If misused casts can hide horrid bugs.
> > > IMHO sprinkling the code with casts just to remove
> > > compiler warnings will bite back one day.
> > >
> >
> > I agree that too much casts make the code hard to read,
> > but irrespective of this patch, there is no difference
> > in the fact that we need a cast to convert
> > (const void *) to a non-pointer value.
> >
> > The difference is whether we use
> > (uintptr_t) or (enum foo).
> >
> >
> >
> >
> > If we want to avoid casts completely,
> > we could use union in struct of_device_id
> > although this might be rejected.

The union like you suggested might fly. Maybe the new field data_ulong
or data_u32 might work and even help non-enum non-pointer values to be
stored in this directly too without needing the casting that's needed
today.

I still don't get why the compiler can't be smarter about this. If the
enum would fit inside the pointer, why not leave that alone and throw
a warning only when the enum really can overflow the pointer field?

> >
> >
> > FWIW:
> >
> > diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
> > index 6853dbb4131d..534170bea134 100644
> > --- a/drivers/ata/ahci_brcm.c
> > +++ b/drivers/ata/ahci_brcm.c
> > @@ -415,11 +415,11 @@ static struct scsi_host_template ahci_platform_sht = {
> >  };
> >
> >  static const struct of_device_id ahci_of_match[] = {
> > -       {.compatible = "brcm,bcm7425-ahci", .data = (void *)BRCM_SATA_BCM7425},
> > -       {.compatible = "brcm,bcm7445-ahci", .data = (void *)BRCM_SATA_BCM7445},
> > -       {.compatible = "brcm,bcm63138-ahci", .data = (void *)BRCM_SATA_BCM7445},
> > -       {.compatible = "brcm,bcm-nsp-ahci", .data = (void *)BRCM_SATA_NSP},
> > -       {.compatible = "brcm,bcm7216-ahci", .data = (void *)BRCM_SATA_BCM7216},
> > +       {.compatible = "brcm,bcm7425-ahci", .data2 = BRCM_SATA_BCM7425},
> > +       {.compatible = "brcm,bcm7445-ahci", .data2 = BRCM_SATA_BCM7445},
> > +       {.compatible = "brcm,bcm63138-ahci", .data2 = BRCM_SATA_BCM7445},
> > +       {.compatible = "brcm,bcm-nsp-ahci", .data2 = BRCM_SATA_NSP},
> > +       {.compatible = "brcm,bcm7216-ahci", .data2 = BRCM_SATA_BCM7216},
> >         {},
> >  };
> >  MODULE_DEVICE_TABLE(of, ahci_of_match);
> > @@ -442,7 +442,7 @@ static int brcm_ahci_probe(struct platform_device *pdev)
> >         if (!of_id)
> >                 return -ENODEV;
> >
> > -       priv->version = (enum brcm_ahci_version)of_id->data;
> > +       priv->version = of_id->data2;
> >         priv->dev = dev;
> >
> >         res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "top-ctrl");
> > diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> > index e3596db077dc..98d44ebf146a 100644
> > --- a/include/linux/mod_devicetable.h
> > +++ b/include/linux/mod_devicetable.h
> > @@ -261,7 +261,10 @@ struct of_device_id {
> >         char    name[32];
> >         char    type[32];
> >         char    compatible[128];
> > -       const void *data;
> > +       union {
> > +               const void *data;
> > +               unsigned long data2;
> > +       };
> >  };
> >

I've never (or long since forgotten) consciously declared a union
without a name and directly accessed it's fields. If this compiles,
this seems reasonable.

-Saravana
