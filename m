Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2F228CAB3
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgJMI53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbgJMI53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Oct 2020 04:57:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6412F208D5;
        Tue, 13 Oct 2020 08:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602579449;
        bh=5skNUANjPwSulVA0ZFuYGhV9zTjGW1jjMZ2xM7Ma91w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xdVO3bFan0jpAQ6w7QkzVH9NjeKXzB53CmWreXmDnpwn/cVv4GilFPCRCEf9X6bUK
         HVjgdGQjHiGX27ilwokYHi+qv+gXsEwYXHmOQCTjp6ao5f/ZYlfuy27fPgC9YBAIQf
         vtm1PRD3fbGbapp7U/vDxlDWaOg7PMSHSJ1wB4pg=
Date:   Tue, 13 Oct 2020 10:58:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Chuang <benchuanggli@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
Message-ID: <20201013085806.GB1681211@kroah.com>
References: <20201013074600.9784-1-benchuanggli@gmail.com>
 <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > >
> > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> > >
> > > Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755
> > >
> > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli@gmail.com
> > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > ---
> > > Hi Greg and Sasha,
> > >
> > > The patch is to improve the EMI of the hardware.
> > > So it should be also required for some hardware devices using the v5.4.
> > > Please tell me if have other questions.
> >
> > This looks like a "add support for new hardware" type of patch, right?
> 
> No, this is for a mass production hardware.

That does not make sense, sorry.

Is this a bug that is being fixed, did the hardware work properly before
5.4 and now it does not?  Or has it never worked properly and 5.9 is the
first kernel that it now works on?

> There are still some customer cases using v5.4 LTS hence we need to
> add the patch for v5.4 LTS.

Your customer problems are not the upstream kernel's problems, this is
why they pay you :)

Have you read the stable kernel rules:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

What category does this patch fall into?

thanks,

greg k-h
