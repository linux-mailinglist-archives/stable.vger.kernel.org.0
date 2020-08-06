Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556B523DCA1
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 18:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgHFQur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 12:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729555AbgHFQuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 12:50:13 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E497C0086B8;
        Thu,  6 Aug 2020 08:35:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id m22so7692552eje.10;
        Thu, 06 Aug 2020 08:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jAnZHwKItrjXdvdR58QzqOoGM6YiK6Tg67ZIO3IEXZQ=;
        b=PaV9DzcXBRT4XdiWVj2xuDnpNzGzZvTVchEJ29eJg3AwKErvnq9AkPTWImWIdPrvSk
         Cm1fi9ZxhQcs1r7k5zNMztQZEJqDMdu4nka/5tt8Hhb9cFcUnBoSa31kj9ZW0F5Bwztk
         NHaIsLTKVw7u8qV/lSP5g3fWoeyPzO6NUKldsdvdpw3jIGhMz1cqJ+9ArczJ7cx3GIwk
         PX8WirWmF4DG/A/CFrnhy+HE2KQsK+ZRlZFYc32HeYG6Tbh2C++BzOTYyxkUXmkEOi0k
         xTt2rad3nwG1/HXaM/GIW7ndJd+xF1vxwoL77XDNGhT/4l0+wVpZ2QhQn6ruUQVtS02g
         ux2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jAnZHwKItrjXdvdR58QzqOoGM6YiK6Tg67ZIO3IEXZQ=;
        b=TTPfMM13Pu9OMkt7JxxQcBfbqEEvjOOoD3OhDR9jjNMI3rOH3FU9JWaJ0i279B6ENc
         afd6v9+JHkBxdfK2LuuX0Xs1oozl+ODcj9U2gDDA2zlJqO4d6n1q3VEnYaTy47VQDl32
         PaiDPLLKTvPmffe5ANx4wHYxaanegVYtFUwxf2G0LRmMkRVDwTjOHZoJ0qe89+WdW2y2
         KqCv97hIG/ksaGLxClZ5TRxd2e526HyQJf4Fqp8BUpcWZzcGHL6EdQWVen1qZVLC94lU
         dPfPSUpdAOrdOOSErXE5OGN36zxwBIFEHg6h9UvYsdx8GyRVIw4kEW25Vc//14hdrd9M
         cxHg==
X-Gm-Message-State: AOAM530JJcsyGeEvUzWUBBrJC099TNgwOteWgIcuS7ccgTYC2a182LsF
        uc/0L24eMtPD9JUxlnL8tW4=
X-Google-Smtp-Source: ABdhPJzGSWcXsTvrFChy/oKLxWzAYTmdg9pUBz7YXxu/sHbxaHPFNUziq5MLvb9Mv5LaLwHDPyG+XA==
X-Received: by 2002:a17:907:4064:: with SMTP id nl4mr4903112ejb.342.1596728106880;
        Thu, 06 Aug 2020 08:35:06 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id h9sm4027593ejt.50.2020.08.06.08.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 08:35:06 -0700 (PDT)
Date:   Thu, 6 Aug 2020 17:35:00 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        X86 ML <x86@kernel.org>, stable <stable@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Vivek Goyal <vgoyal@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        0day robot <lkp@intel.com>, lkp@lists.01.org
Subject: Re: [x86/copy_mc] a0ac629ebe: fio.read_iops -43.3% regression
Message-ID: <20200806153500.GC2131635@gmail.com>
References: <159630256804.3143511.8894023468833792004.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200803094257.GA23458@shao2-debian>
 <20200806133452.GA2077191@gmail.com>
 <CAPcyv4hS7K0Arrd+C0LhjrFH=yGJf3g55_WkHOET4z58AcWrJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hS7K0Arrd+C0LhjrFH=yGJf3g55_WkHOET4z58AcWrJw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Dan Williams <dan.j.williams@intel.com> wrote:

> On Thu, Aug 6, 2020 at 6:35 AM Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * kernel test robot <rong.a.chen@intel.com> wrote:
> >
> > > Greeting,
> > >
> > > FYI, we noticed a -43.3% regression of fio.read_iops due to commit:
> > >
> > >
> > > commit: a0ac629ebe7b3d248cb93807782a00d9142fdb98 ("x86/copy_mc: Introduce copy_mc_generic()")
> > > url: https://github.com/0day-ci/linux/commits/Dan-Williams/Renovate-memcpy_mcsafe-with-copy_mc_to_-user-kernel/20200802-014046
> > >
> > >
> > > in testcase: fio-basic
> > > on test machine: 96 threads Intel(R) Xeon(R) Gold 6252 CPU @ 2.10GHz with 256G memory
> > > with following parameters:
> >
> > So this performance regression, if it isn't a spurious result, looks
> > concerning. Is this expected?
> 
> This is not expected and I think delays these patches until I'm back
> from leave in a few weeks. I know that we might lose some inlining
> effect due to replacing native memcpy, but I did not expect it would
> have an impact like this. In my testing I was seeing a performance
> improvement from replacing the careful / open-coded copy with rep;
> mov;, which increases the surprise of this result.

It would be nice to double check this on the kernel-test-robot side as 
well, to make sure it's not a false positive.

Thanks,

	Ingo
