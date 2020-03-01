Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C12174CA5
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgCAJw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:52:29 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46456 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgCAJw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Mar 2020 04:52:29 -0500
Received: by mail-oi1-f193.google.com with SMTP id a22so7369940oid.13;
        Sun, 01 Mar 2020 01:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zjw8utMkTnRlYhlmZOuTGDe+t7BCqfBiZYv0axgOoNI=;
        b=gU8MUgwCzB4a+tUG9pdlF2FLO/EloMEy87qDBnVoyxaVc/cFd5cEP/w2aFcXS0Hn7W
         7n1RPwk9ludNwlCFPrsA3uFZXAUvAAFHgnIIF/m1Nkwfshhk24YzQot3py3k6FpVIfsD
         ELHH7eDgjw0+9NtIT5sjZARw0amc39uXIJZpM6IXJR80OKO0cMmw71ACzKJmWVIBHJd0
         X0g9Npukf8a25oHPt3ccDRRRHzCwPdEnFHMOyplQYZXfq2GrWPcBNhBCy6L4m/+6ZDKj
         yTlr0gB7mGrgx1CyErPykmTDR8tJ3BbnkyWANtnqRxizuMnbtyaXSwHXcE+DPc3VkovQ
         wMCA==
X-Gm-Message-State: ANhLgQ1F0+s19h8N3R5TDQ09Z4sboQ+XGR0rw/u08zMHFp24KhX1WVdi
        AiIH3YWVttY8ro+RrmeEJ8dFjzbHC+SJsVxAXjLylgTq
X-Google-Smtp-Source: ADFU+vthZhblfiZa+LuLUUmlTiqLi9wLPhjMt0o6dEXKq0lSzk/OYnfu/dCKmbVO05gFQvUW1EFsVTHvPA30Z96QUY8=
X-Received: by 2002:aca:ac4c:: with SMTP id v73mr1955671oie.102.1583056348137;
 Sun, 01 Mar 2020 01:52:28 -0800 (PST)
MIME-Version: 1.0
References: <20200227132255.285644406@linuxfoundation.org> <CAMuHMdXPzqmhj1E0AywSiThMQK1AfR4Rp19DV7W8uSp=8p_Zgg@mail.gmail.com>
 <20200301094243.GA1027353@kroah.com>
In-Reply-To: <20200301094243.GA1027353@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 1 Mar 2020 10:52:17 +0100
Message-ID: <CAMuHMdUwgqcMYAUeWuWKoCqEEf=LvjX2fA_Bn4OuHYtOyvqrxA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Mar 1, 2020 at 10:42 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, Mar 01, 2020 at 10:38:18AM +0100, Geert Uytterhoeven wrote:
> > On Thu, Feb 27, 2020 at 2:55 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 4.14.172 release.
> > > There are 237 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> > > -------------
> > > Pseudo-Shortlog of commits:
> >
> > Given you do have a git branch containing these commits, is there any
> > chance you can update your scripts to insert a real (sorted) shortlog
> > here?
> > That would make it easier for us contributors to track what has been
> > backported.
>
> How would a real shortlog help any better, except to have things sorted
> a tad easier?

One reason is that it is easier to search in a sorted list.
A second reason is that contributions by the same person would be grouped
together.

> I can't remember why I do it this way, but for some reason, many many
> years ago, this was a better solution than a "traditional" shortlog.

IIRC,  because you started with quilt ;-)

> Here's the shortlog for this release for comparison:
>
> Aditya Pakki (3):
>       fore200e: Fix incorrect checks of NULL pointer dereference
>       orinoco: avoid assertion in case of NULL pointer
>       ecryptfs: replace BUG_ON with error handling code

See, the above are all commits by Aditya Pakki. No reason to continue
looking below ;-)

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
