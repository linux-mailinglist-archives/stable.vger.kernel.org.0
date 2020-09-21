Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2341E27211E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 12:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgIUK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 06:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgIUK3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 06:29:37 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278E6C061755;
        Mon, 21 Sep 2020 03:29:37 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id p65so11769618qtd.2;
        Mon, 21 Sep 2020 03:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ha7uOpPsgSYW9Dzxfe8r1fOa9581cD52tuAWOWOVJgQ=;
        b=E9djVZppygHioNIyuetXkKkSPhJ6xTYCkuEKqwRIbnCjVA2PbtbGAF39BFm2WhPnzN
         wvvdClq3m4rNKCOmjZMG646YbDmD+Lk9lrdx6eaFv5BKZTJY0u5JtlHxP/erCed+zSrR
         weGDSrv8VJInEJBLlffO9hjOnoVKBHS8T2rY5kTAxTfgtzVI0mnbEsrZ4crQ4CP3Y3Nh
         ZlR4MK+HfsyHwGvFMt8/t9ovpEm8udyXbeRkCaYYwDlKAktj2Gu2eBqZYT+MOS6HE4RL
         Dl/7Nbwt7rCZswZoWshNSoWD7UOX0biZBudZqTGU9/iAtCMVuvlZp9cU8n2/XsbECrfp
         t5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ha7uOpPsgSYW9Dzxfe8r1fOa9581cD52tuAWOWOVJgQ=;
        b=d4MBjkO5spPEyR191Cs95sHOEkCkJGL8HWXe7uUk7raYs8Rw/MRw/R+Ur9pa0qzuf7
         kzdd4Si9T8yUsef5i0w1B614pq8GOYVbJQu1tYHF8Lwa9sz+MQV2C40CmmYxmdSuhV3P
         UntY3mPoreDQL+J+VWnUIT78CLoF51IjeUn/ob7jtNvsdgfeI+Hst+0v9HRkBV0+euW2
         2COC8irRSCFPnCx8IYJgh9VLsD1dJ1X53PJlhuC/xhQmSfUzDSbUkFCXnFAWhodt28sz
         voIoQWJODoI4ugJfbBsasehO2pVICJ+qL7pxJJu5JifVfHQN9dq+U3G/5VGDSV21rINf
         SxXQ==
X-Gm-Message-State: AOAM532tu+8LHnWzAYD99Gb6aYa6pwPKEqS95Pazn4RaocGfCIJalkao
        69qbgq8bE/7M8CnkkVuz4h0=
X-Google-Smtp-Source: ABdhPJyS7MgtwJ+ssdbtRNH5SJYuKINkDAEqZtCxruKBvMWxT7F7TZjyZ5h7mMWWPol4qvQ4hk36xQ==
X-Received: by 2002:aed:3bdc:: with SMTP id s28mr46154317qte.124.1600684176350;
        Mon, 21 Sep 2020 03:29:36 -0700 (PDT)
Received: from arch-chirva.localdomain (pool-68-133-6-220.bflony.fios.verizon.net. [68.133.6.220])
        by smtp.gmail.com with ESMTPSA id d5sm10328576qtm.36.2020.09.21.03.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:29:35 -0700 (PDT)
Date:   Mon, 21 Sep 2020 06:29:33 -0400
From:   Stuart Little <achirvasub@gmail.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jan Kara <jack@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Subject: Re: PROBLEM: 5.9.0-rc6 fails =?utf-8?Q?to_?=
 =?utf-8?Q?compile_due_to_'redefinition_of_=E2=80=98dax=5Fsupported?=
 =?utf-8?B?4oCZJw==?=
Message-ID: <20200921102933.GF3027080@arch-chirva.localdomain>
References: <20200921010359.GO3027113@arch-chirva.localdomain>
 <CA+G9fYtCg2KjdB2oBUDJ2DKAzUxq3u8ZnMY9Et-RG9Pnrmuf9w@mail.gmail.com>
 <20200921073218.GA3142611@kroah.com>
 <20200921095035.GC5862@quack2.suse.cz>
 <CAMuHMdX871H5zqgb877Tw3N6PczpXTvnbCGRt++4udNpf8Oftg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX871H5zqgb877Tw3N6PczpXTvnbCGRt++4udNpf8Oftg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Confirmed: the patch fixed the build for me as well; thank you! 

On Mon, Sep 21, 2020 at 12:08:43PM +0200, Geert Uytterhoeven wrote:
> Hi Honza,
> 
> On Mon, Sep 21, 2020 at 11:54 AM Jan Kara <jack@suse.cz> wrote:
> > On Mon 21-09-20 09:32:18, Greg KH wrote:
> > > On Mon, Sep 21, 2020 at 11:34:17AM +0530, Naresh Kamboju wrote:
> > > > On Mon, 21 Sep 2020 at 06:34, Stuart Little <achirvasub@gmail.com> wrote:
> > > > > I am trying to compile for an x86_64 machine (Intel(R) Core(TM) i7-7500U CPU @ 2.70GHz). The config file I am currently using is at
> > > > >
> > > > > https://termbin.com/xin7
> > > > >
> > > > > The build for 5.9.0-rc6 fails with the following errors:
> > > > >
> > > >
> > > > arm and mips allmodconfig build breaks due to this error.
> > >
> > > all my local builds are breaking now too with this :(
> > >
> > > Was there a proposed patch anywhere for this?
> >
> > Attached patch should fix the build breakage. I'm sorry for that.
> 
> Thanks, this fixes my m68k build issues:
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
