Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56A29D4AF
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgJ1VwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgJ1VwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:52:00 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE298C0613D1;
        Wed, 28 Oct 2020 14:52:00 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id m128so1135969oig.7;
        Wed, 28 Oct 2020 14:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=aJ74ood16CLKSxoR+e2RXQCM4uz05wMoEH0BE8t4REc=;
        b=e+FuKY/Ub4Cwf5J8IcvLM8T9qbM5jJ7Tf6sDwQ3NCCCb8338aRSAKQ3GH0+82QXf3N
         /2/iMDpAS30r0GH8dozChkaFsaF2JlgAyxFi7cY/fgNr6p5hOqoj8etbqEB5t4kn7ZlU
         ivsSZ3FmiW/0qZ2jYg/T7aG6ujp+S15ywoyRIyilT/wSjdxAbh87H7xCsxmtQFZzCrbj
         DwbKyPsY3qu6it+bLNfdkMkxQsS2Gjwet2S8VTT0nf4iOVdF9lSMYaQCXboxb6U5QSJh
         AVXHlPvbaBdw7J7OFlGnwAcUdhI/ad/q3nwO24ERTGydZD9z8S5dTmthTlBfQ4Tu1JwC
         j4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=aJ74ood16CLKSxoR+e2RXQCM4uz05wMoEH0BE8t4REc=;
        b=itTjvdz0WAF85uwx1ZhSsIilgApxRNjoEUOMBByEWk+nMnVi0EoiOfKUu19PrPkVeA
         aZG8/lXFwkGcVMBykBSZjiIy9HF1hl4Ec4zHjERRjPux/wzDz2VJoI3SL/mtuCJlAMyx
         Ch8yhZpDEPhSApVjBh5f4rUqcUAmJyk6qUU6/XBsu6z2vH0t6j5PouySgG/NjKHNGrc9
         GRX/yPFrImlTGvmFH6uRpTEUeC3pqUeu8DzNLoBaSCJhmErVE1P5OB3d0ymomWxittsW
         83CQyp2vHpIcMZhXrJ5xrpRrFfdz2lix2s2n4Lg0l86jBKhE289LD4Gcn+L+1t/jqHRo
         /CuQ==
X-Gm-Message-State: AOAM532vHnYAUnISiLUjG2KhHxBq6XasvO+brHhIsxhiCczX1EW6pmOJ
        ZgY8I7dlItWGj7AR1fWizzznd3aJJoE=
X-Google-Smtp-Source: ABdhPJws2i2ws5CHDKvhOS3zT0wJJcNlygA3NjV54VA/bHcc1s06fBgRhX6VORIzCqjLGsxnq5d9rg==
X-Received: by 2002:aca:518a:: with SMTP id f132mr559432oib.161.1603918044909;
        Wed, 28 Oct 2020 13:47:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q8sm137237otf.7.2020.10.28.13.47.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Oct 2020 13:47:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 28 Oct 2020 13:47:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, patches@kernelci.org,
        linux- stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 4.4 000/112] 4.4.241-rc1 review
Message-ID: <20201028204722.GA126328@roeck-us.net>
References: <20201027134900.532249571@linuxfoundation.org>
 <20201028170621.GA118534@roeck-us.net>
 <20201028194647.GA124690@roeck-us.net>
 <CAEUSe7_72XC=Dz=yy6UrHLrgAQbHzP9V2UfmWXbwmeUSeVzgJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7_72XC=Dz=yy6UrHLrgAQbHzP9V2UfmWXbwmeUSeVzgJA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 02:33:35PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Wed, 28 Oct 2020 at 13:46, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Wed, Oct 28, 2020 at 10:06:21AM -0700, Guenter Roeck wrote:
> > > On Tue, Oct 27, 2020 at 02:48:30PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.4.241 release.
> > > > There are 112 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 29 Oct 2020 13:48:36 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > >
> > > Build results:
> > >       total: 165 pass: 165 fail: 0
> > > Qemu test results:
> > >       total: 332 pass: 332 fail: 0
> > >
> >
> > Did anyone receive the original e-mail ? Looks like I have been tagged as
> > spammer, and I am having trouble sending e-mails.
> 
> If the original is from 3.5 hours ago, yeah, we got it. I'm not seeing
> lore updated, but that's probably another issue.
> 

Thanks. Greg KH mentioned that lore.kernel.org was down. I got lots of
"undeliverable" messages back, same as yesterday for a different e-mail.
In that case no one received it, so I thought the same happened again.

Guenter
