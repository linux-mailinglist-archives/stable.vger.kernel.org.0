Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58752198C45
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 08:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgCaGZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 02:25:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50291 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgCaGZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 02:25:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id t128so1181613wma.0;
        Mon, 30 Mar 2020 23:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ArVsRQLEDczzNKjhr+jbvPA9gOP9bTXo6z6wbtdEl10=;
        b=jns4IRlGX9ipfTr9QrAL9MdEaWIkQoFyIooKuQipIVNBQSVtUMw3vCCJFj+PSX0izw
         +M5IjJagxyUJYuSRRESQduiYnQMChrwqRwRMmueI54Njg2kqSOmeHR8E86vStL93enHf
         nNtb1uAil9EIpv0yMCIXp5n/QJU5ZfiZSTvwzVXvhrNq6eNYO5ZvtnbQK4Y50Rg/zc2P
         vtaXcjP2CslaNNrPwMndOFVXGoN98KaJHSKPngCN4govHd8pn3IpY6rqOFMWrPa7FGgh
         UUbwFPoeMF2tJKPSKIH/BsQDIuuqiToYHF5QTvAkoFHKWjTbqm3fRkmDCCZF8ztugo5+
         s2kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ArVsRQLEDczzNKjhr+jbvPA9gOP9bTXo6z6wbtdEl10=;
        b=iqVVlfGbYviLsn3xoqgqTJNMTTTk3VnugEF57SdZWxjNJmB/fnNKYcA1vfDRTrTsqi
         7xFoMF2pt972o/yRh38K+9YLrN11F47XcCFMWfRiB2AiPomw35I3lVlB3rwQZzUjl+RL
         WpxDd8f0Nb7EWG8wBKH0l9vrTYS1Hlfg+JOqlKiX+ZREJoKd+hCdDaE3JX8W5nt/qX4z
         EF9ZfAiuOctx5iZjJikeuUkr0uKKwArXdK88WgQOl5Eyn35J5s+Xn2Gdr/0+t2zQCiaq
         PNYAkrUObIEcO7e/VZzxJi19+kPaBrttT5LlhJXtuBCqQKQEOTZ0VfdOcqMVPUoL9ZdT
         oaHg==
X-Gm-Message-State: ANhLgQ26ql4+ZwL3tZobFiQjhNL4/pAlppcrwjsYec2fLe1Brjjly8xB
        rIzZUenudFmULWuECGLfWU27Qrdaz1AhbUeaVGk=
X-Google-Smtp-Source: ADFU+vsfDb61Ldk0iX/IBTCWS+t2mAybXufGyG8yv092g0wKK9uHiwzveQnqojQSYrvCusFMdLqY+42vSuKTVOjtWOA=
X-Received: by 2002:a1c:9c85:: with SMTP id f127mr1820416wme.91.1585635955410;
 Mon, 30 Mar 2020 23:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200311170120.12641-1-jeyu@kernel.org> <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
In-Reply-To: <CANcMJZDhSUV8CU_ixOSxstVVBMW3rVrrQVYMmy1fz=OdhxA_GQ@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 30 Mar 2020 23:25:44 -0700
Message-ID: <CANcMJZD9Lz-J_idL5i225VR_3Mo6PcTRsYBBrGsMByX6W4jepQ@mail.gmail.com>
Subject: Re: [PATCH v2] modpost: move the namespace field in Module.symvers last
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        stable@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 10:49 PM John Stultz <john.stultz@linaro.org> wrote:
> On Wed, Mar 11, 2020 at 10:03 AM Jessica Yu <jeyu@kernel.org> wrote:
> >
> > In order to preserve backwards compatability with kmod tools, we have to
> > move the namespace field in Module.symvers last, as the depmod -e -E
> > option looks at the first three fields in Module.symvers to check symbol
> > versions (and it's expected they stay in the original order of crc,
> > symbol, module).
> >
> > In addition, update an ancient comment above read_dump() in modpost that
> > suggested that the export type field in Module.symvers was optional. I
> > suspect that there were historical reasons behind that comment that are
> > no longer accurate. We have been unconditionally printing the export
> > type since 2.6.18 (commit bd5cbcedf44), which is over a decade ago now.
> >
> > Fix up read_dump() to treat each field as non-optional. I suspect the
> > original read_dump() code treated the export field as optional in order
> > to support pre <= 2.6.18 Module.symvers (which did not have the export
> > type field). Note that although symbol namespaces are optional, the
> > field will not be omitted from Module.symvers if a symbol does not have
> > a namespace. In this case, the field will simply be empty and the next
> > delimiter or end of line will follow.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: cb9b55d21fe0 ("modpost: add support for symbol namespaces")
> > Tested-by: Matthias Maennich <maennich@google.com>
> > Reviewed-by: Matthias Maennich <maennich@google.com>
> > Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
> > Signed-off-by: Jessica Yu <jeyu@kernel.org>
> > ---
> > v2:
> >
> >   - Explain the changes to read_dump() and the comment (and provide
> >     historical context) in the commit message. (Lucas De Marchi)
> >
> >  Documentation/kbuild/modules.rst |  4 ++--
> >  scripts/export_report.pl         |  2 +-
> >  scripts/mod/modpost.c            | 24 ++++++++++++------------
> >  3 files changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/Documentation/kbuild/modules.rst b/Documentation/kbuild/modules.rst
> > index 69fa48ee93d6..e0b45a257f21 100644
> > --- a/Documentation/kbuild/modules.rst
> > +++ b/Documentation/kbuild/modules.rst
> > @@ -470,9 +470,9 @@ build.
> >
> >         The syntax of the Module.symvers file is::
> >
> > -       <CRC>       <Symbol>          <Namespace>  <Module>                         <Export Type>
> > +       <CRC>       <Symbol>         <Module>                         <Export Type>     <Namespace>
> >
> > -       0xe1cc2a05  usb_stor_suspend  USB_STORAGE  drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL
> > +       0xe1cc2a05  usb_stor_suspend drivers/usb/storage/usb-storage  EXPORT_SYMBOL_GPL USB_STORAGE
> >
> >         The fields are separated by tabs and values may be empty (e.g.
> >         if no namespace is defined for an exported symbol).
>
> Despite the documentation here claiming the namespace field can be
> empty, I'm seeing some trouble with this patch when building external
> modules:
>   FATAL: parse error in symbol dump file
>
> I've confirmed reverting it make things work again, but its not clear
> to me quite yet why.
>
> The only difference I can find is that the Module.symvers in the
> external module project doesn't seem to have a tab at the end of each
> line (where as Module.symvers for the kernel - which doesn't seem to
> have any namespace names - does).
>
> Is there something I need to tweak on the external Kbuild to get
> Module.symvers to be generated properly (with the empty tab at the
> end) for this new change?
> Or does the parser need to be a bit more flexible?
>

One extra clue on this: I noticed the external module Makefile had
KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMBOLS)"  in the $(MAKE) string, where
EXTRA_SYMBOLS pointed to some files that no longer exist.  I removed
the KBUILD_EXTRA_SYMBOLS= argument, and magically, the generated
Module.symvers now had tabs at the end of each line.

I wonder if there some path in the KBUILD_EXTRA_SYMBOLS= handling that
isn't generating the output in the same way?

thanks
-john
