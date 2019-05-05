Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5B013E8A
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 11:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfEEJCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 05:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfEEJCl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 05:02:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358782087F;
        Sun,  5 May 2019 09:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557046960;
        bh=quk9nqi0AdVHX2kkxfLOs0bkhqVerto33aMUVix2Yzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEc4VgwQtcwFurNMjmIkYAGP9WWUGuuFYmgQnogViOS+2rGZLvhgG4yypKyRxMgU4
         HzVvadyPPhzySBEPBIUSlYdN9P0o1t1S+BJVoBl0qqJN7jkhf4uorshxSkpSyG25zz
         R+2wqp6rMai+k6T1Xb94TdaVnRdTX5xKIZ5UZ0yc=
Date:   Sun, 5 May 2019 11:02:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/23] 4.19.40-stable review
Message-ID: <20190505090236.GA24937@kroah.com>
References: <20190504102451.512405835@linuxfoundation.org>
 <20190505030044.q3dlgd5bhfx5txmf@xps.therub.org>
 <20190505070854.GA3895@kroah.com>
 <CA+G9fYv668HB5nZSn_drMd5cLhfH7GP0NxDsF88wtp3MUAMimA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv668HB5nZSn_drMd5cLhfH7GP0NxDsF88wtp3MUAMimA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 05, 2019 at 02:23:22PM +0530, Naresh Kamboju wrote:
> On Sun, 5 May 2019 at 12:38, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, May 04, 2019 at 10:00:44PM -0500, Dan Rue wrote:
> > > On Sat, May 04, 2019 at 12:25:02PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.40 release.
> > > > There are 23 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Mon 06 May 2019 10:24:19 AM UTC.
> > > > Anything received after that time might be too late.
> > >
> > >
> > > Results from Linaro’s test farm.
> > > Regressions detected.
> >
> > Really?  Where?
> 
> Not really.
> selftest: net: msg_zerocopy.sh is an intermittent failure on qemu_i386 device.

Is that a test problem, or a qemu problem?

> We could ignore this failure as known issues.

It wasn't listed in the report, or did I miss it?

