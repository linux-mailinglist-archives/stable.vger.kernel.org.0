Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43BC271FB3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 12:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIUKIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 06:08:55 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33681 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIUKIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 06:08:55 -0400
Received: by mail-ot1-f67.google.com with SMTP id m12so11846725otr.0;
        Mon, 21 Sep 2020 03:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C2U9zgdNA+W5z39mxrnSClctTCx07o8njSeYRiDkxUQ=;
        b=Yqxg09ua1Uy5BCg8cI8sGidSWA2aFGehIXKrSXMUuazueRBHbwEXLFYDRhMTqr+QDp
         EjsrvAW7g6Q6aUz8qO/uBaX+XP32wAvF4aoL7E+VJIEKO92Atx8OceBpvlYgWMsjBlxg
         PvOOBUDAItswpoTDmKepsnqjU7mji/TNm5q1IkjPES0IlHOGpaAH3F7UtywhcESbBN7n
         7oR2WXqWH7aaFkoTN2BIPvZubw1woY0FBhyxPMUO1OANcb8Fpzymfl2ILZtgENdbsuoY
         1iKjVYiBITudVKYovtcbUHHWmu6Jf0IPC7zX8LY4S0d0nVL15q7FwEg3aNlOroYeWBbs
         iw2g==
X-Gm-Message-State: AOAM530HfDpxLbNJsEY3UF15tZgTeQRt/1XndP5YRpDMCv0xXfhu8uuc
        021nB3emnXGEsGGIM9fa2tu/KEamvmLgSHNtqf2JPdZh
X-Google-Smtp-Source: ABdhPJx0z6nJuof9O9shP/JtBfaIqTwWgK7RVeG7KPf2KNQd6Y85WoyMiJQvHvcs+fN+TsY5UDMK5YpXqSLo0OHyosg=
X-Received: by 2002:a9d:3b76:: with SMTP id z109mr31653937otb.250.1600682934646;
 Mon, 21 Sep 2020 03:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
 <20200921073218.GA3142611@kroah.com> <20200921095035.GC5862@quack2.suse.cz>
In-Reply-To: <20200921095035.GC5862@quack2.suse.cz>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Sep 2020 12:08:43 +0200
Message-ID: <CAMuHMdX871H5zqgb877Tw3N6PczpXTvnbCGRt++4udNpf8Oftg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IFBST0JMRU06IDUuOS4wLXJjNiBmYWlscyB0byBjb21waWxlIGR1ZSB0byAncmVkZQ==?=
        =?UTF-8?B?ZmluaXRpb24gb2Yg4oCYZGF4X3N1cHBvcnRlZOKAmSc=?=
To:     Jan Kara <jack@suse.cz>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Stuart Little <achirvasub@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Adrian Huang <ahuang12@lenovo.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ira Weiny <ira.weiny@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Honza,

On Mon, Sep 21, 2020 at 11:54 AM Jan Kara <jack@suse.cz> wrote:
> On Mon 21-09-20 09:32:18, Greg KH wrote:
> > On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
> > > On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
> > > > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz). The config file I am currently using is at
> > > >
> > > > https://termbin.com/xin7
> > > >
> > > > The build for 5.9.0-rc6 fails with the following errors:
> > > >
> > >
> > > arm and mips allmodconfig build breaks due to this error.
> >
> > all my local builds are breaking now too with this :(
> >
> > Was there a proposed patch anywhere for this?
>
> Attached patch should fix the build breakage. I'm sorry for that.

Thanks, this fixes my m68k build issues:
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
