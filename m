Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4923E5562
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhHJIcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238358AbhHJIcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 04:32:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DFDC06179E
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 01:31:41 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f13so28987803edq.13
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 01:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=POsMn/MPNbk3bJTuG5iNhBUmsMNbGeyWS55/31ab+KY=;
        b=evoUc51SbxszGAM+GdoKto470aZ1fUmnVGIWvorklH/sUUROB3JlVUIkZePOHh0Zx0
         OwwjG77TEUHYMag/2ZuPbsbnpHR7O1+Do4YTRtvhFNI94O+G2NcTxpWG22hN88yBemeX
         7DjRDItwA67C9DFepQAI4SHyv/3XwlonK+h0iln+ahUO6s6hm1cDVFchRi/omT2Jhj2z
         rpt0Cg4Z5V56ShQZng9PPE+GxQuqxc1c2Ogf9zLKqJPXEmhFrqnvz8KxypfzFGymGs/6
         lSlKCHNpflzcDJM1wMHcDsiFtch9SKZ9Esap1XOI8dwKS8lZPsSv8YsgMHaAlV05+vrg
         8rGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=POsMn/MPNbk3bJTuG5iNhBUmsMNbGeyWS55/31ab+KY=;
        b=RvdVOQk1HaVkxUzBkI5ZME4+p7PvgQmFtXnHocMIl9gLqBswC4nu+Z/BMCVAqValMe
         gmOclKTJK6DJsAItIl8KIc93gf/loLQ2mj8QVrbUtAXzsSDxLx3I0Tl8VxmA+ysqNdlG
         mK5Gk5GrQV2b2ZYQOHRelDYih7zyrAWT7azbr5Uy6Krn8lF7ZQbAL4JCLyHgXoqqiSyI
         Y4FgUnGPZ4a/QkrSVmCoGPe5B4E4t2/JUYglI5kAumXNPd5vtLUhNLRbZ2c1sK48BmLU
         asRUF7QNw438rfzUugWxeHTyegyqByIVMWIdcVWciK7Z3xXaHgy9UgEmBd2zazGi1YsE
         mQZA==
X-Gm-Message-State: AOAM533OyNlT188DX2lzHeXI6LnIHiC+F8nUp164osByoBrdPLp/VOC1
        UnzBCzCGXnq71pcdhle/QUfy68FRY4jXfEwZVQ6kSQ==
X-Google-Smtp-Source: ABdhPJwjG5ne0dsishcQt4wgr1LtVXNpXKBus4oQFpt4T+082mfLD9aPhdjp9Of6NgE2j0+NL71+22DZ6vQHV9vB64E=
X-Received: by 2002:a05:6402:b6e:: with SMTP id cb14mr3514008edb.239.1628584299515;
 Tue, 10 Aug 2021 01:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210809172421.wcrije6p7qyy55jj@toshiba.co.jp> <YRHj96skjBbU4/9c@sashalap>
In-Reply-To: <YRHj96skjBbU4/9c@sashalap>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Aug 2021 14:01:27 +0530
Message-ID: <CA+G9fYuMkVVpLjd652icgmiN6KPPMWTYGhUywU1quxjrpkbMXg@mail.gmail.com>
Subject: Re: [stable-rc/4.19.y] Build fails with commit 6642eb4eb918 ("ARM:
 imx: add missing iounmap()")
To:     Sasha Levin <sashal@kernel.org>
Cc:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        linux-stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Aug 2021 at 07:57, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Aug 10, 2021 at 02:24:21AM +0900, Nobuhiro Iwamatsu wrote:
> >Hi,
> >
> >Build failed commit 6642eb4eb918 ("ARM: imx: add missing iounmap()") on
> >stable-rc/linux-4.19.y.
> >
> >````
> >arch/arm/mach-imx/mmdc.c: In function 'imx_mmdc_probe':
> >arch/arm/mach-imx/mmdc.c:568:2: error: 'err' undeclared (first use in this function)
> >  err = imx_mmdc_perf_init(pdev, mmdc_base);
> >  ^~~
> >arch/arm/mach-imx/mmdc.c:568:2: note: each undeclared identifier is reported only once for each function it appears in
> >arch/arm/mach-imx/mmdc.c:573:1: error: control reaches end of non-void function [-Werror=return-type]
> > }
> > ^
> >cc1: some warnings being treated as errors
> >make[1]: *** [scripts/Makefile.build:303: arch/arm/mach-imx/mmdc.o] Error 1

LKFT build system also found this build error on arm.

> >
> >````
> >
> >It seems that err has not been declared.
> >I attached a patch which revise this issue.
>
> Thanks for the report. Instead of fixing up 6642eb4eb918 ("ARM: imx: add
> missing iounmap()"), I'll take 9454a0caff6a ("ARM: imx: add mmdc ipg
> clock operation for mmdc") - this way we'll diverge less from upstream.

Thanks for looking into this issue.

- Naresh
