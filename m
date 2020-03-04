Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43701179351
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgCDPZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:25:50 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37823 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCDPZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 10:25:50 -0500
Received: by mail-yw1-f66.google.com with SMTP id g206so2308204ywb.4
        for <stable@vger.kernel.org>; Wed, 04 Mar 2020 07:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=8sse2ZoFpDstytju+TH7ofYW6pSMF+pSogTbI3fs9ho=;
        b=lGZ2xtuNzMfE7wAmiXHHzCnmr8MzzHfxItp2rd8giQGw/HSGKfml5i954ukKVs7g4R
         SV/CWrY+mfr1KM0nSpZ/L5/mBUZ0i2vp5pDWQevXUAn+rX4AN1qiCh6qk+K3FozYTkXc
         TgWgGofoMCm7TAPmWZQwVUuEA/9WUNcyr0rAo4tP0ChGoxZvyJpkBckjWehF+bIqa/LF
         lJfUprE1MYE3m2b7xdOIzKAeVUiDp6ow2zmAMYDqDsB9+iOrMXQXcV7Fn9FdSvGP/aqu
         NDRCFhJ/3FirfpACd6ZR17ng53eJFfPVArAk9t+mzEemvLMODRIYWMXgcyhKBBzY+5P3
         wZzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8sse2ZoFpDstytju+TH7ofYW6pSMF+pSogTbI3fs9ho=;
        b=gkK6QkphhSqPmEIH5rhN592/84GdFhdFk4nrqpmO1imXcAE4L9v834fOLxXnZ56qXo
         Hd38r3tAV7H8QvAEV04jVzl9NuIV7wBPSD1B4JHI6CoA83RAC9WsEN8qZrgdQB6jPbRW
         8XUr+7+f8d+MzS9DAh80EgwwQx/3J+0+cGG++ijGoBCSC8b0kcFZ49/yrjQXBShcVIZn
         DCIcMrlqPvWlwEmfCcqtxdqKf2oeBoeeoISdt9lORSvcZwB+otzTlowHVwzPjrqt1sou
         NKY/aTfrLbrR0VeC5K/r2s56sYs8cVdnFh+hb9Oet2uX6hz/Mk3OWU/0/ViAUDDVQvS9
         oFJg==
X-Gm-Message-State: ANhLgQ1JXgKvp+4prXlCk2iSBEHaqtFg1PErhZNMCO36//DpJgCccBLj
        n50YNFpi/vAEd16acnLpbR5cgwfZqHs=
X-Google-Smtp-Source: ADFU+vuFcgaPWUOAEJEwQ9M7JAHuHmY8ShKNroK4R3mkMu9rX782nf/hMKBtrfQJZO+16Isd7BkRlQ==
X-Received: by 2002:a81:3695:: with SMTP id d143mr3175382ywa.362.1583335548150;
        Wed, 04 Mar 2020 07:25:48 -0800 (PST)
Received: from localhost (c-75-72-120-152.hsd1.mn.comcast.net. [75.72.120.152])
        by smtp.gmail.com with ESMTPSA id k5sm3578652ywh.108.2020.03.04.07.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 07:25:47 -0800 (PST)
Date:   Wed, 4 Mar 2020 09:25:46 -0600
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304152546.qhfop74fuwmr6iop@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
References: <20200303174304.593872177@linuxfoundation.org>
 <CA+G9fYtNKXBOQKE_AD6qLoRo4TeaBYOc9Ce3kBxdLap1av4v=Q@mail.gmail.com>
 <20200304081128.GC1401372@kroah.com>
 <20200304084702.GA1416015@kroah.com>
 <20200304084946.GB1416015@kroah.com>
 <CA+G9fYuTXB03s5YSn=NL0dtF-Kzj0YHUu6NwqSh6m9Hco59DPw@mail.gmail.com>
 <20200304115232.GC1581141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304115232.GC1581141@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 04, 2020 at 12:52:32PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 04, 2020 at 04:22:30PM +0530, Naresh Kamboju wrote:
> > > > So why is this "Vulnerable"?  Because it didn't think it could find my
> > > > kernel image for some odd reason, despite it really being in /boot/ (I
> > > > don't use netboot)
> > 
> > Now I know the real reason why this test failed.
> > With this note we can conclude this is not a regression.
> > 
> > No regressions on arm64, arm, x86_64, and i386 for 4.19, 5.4 and 5.5 branches.
> 
> Great, thanks for confirming and for testing all of these.

We originally added spectre-meltdown-checker to lkft for informational
purposes, so that we could compare its report to any actual tests that
produce spectre/meltdown related failures (and help determine if the
problem is hardware/firmware or kernel). In practice, it's never been
helpful (because it's not an actual test) and so we'll be removing it
from LKFT.

Dan

> 
> greg k-h

-- 
Linaro LKFT
https://lkft.linaro.org
