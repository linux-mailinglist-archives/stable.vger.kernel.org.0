Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2F252167
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 05:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfFYDxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 23:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfFYDxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 23:53:46 -0400
Received: from localhost (unknown [116.226.249.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811A42085A;
        Tue, 25 Jun 2019 03:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561434826;
        bh=izxrWomxneckttGUFEaH7tTd6OFJu4xjCKQcorOurwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jDKPCPaqzD3KqfDKMqk+wRxjEq35QG9CbHe0uqTGOQ2z31FoXbJlzHIjFG2rP1LQf
         pGId7QkXbNS/xCqcMbbaauN73mgxNaiIi7sgsDZhL2TxNUN415iOu0sYXULPfYSPIo
         zas4DDbq3Ckq8o59MAouCV+6SMWw/hanyMLJt/Eo=
Date:   Tue, 25 Jun 2019 11:08:52 +0800
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
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
Message-ID: <20190625030852.GC11074@kroah.com>
References: <20190624092320.652599624@linuxfoundation.org>
 <CA+G9fYsxR5FtxPWNF5zs8uGWpAZCNRLAq+7azZCg_k0Mm_=fxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsxR5FtxPWNF5zs8uGWpAZCNRLAq+7azZCg_k0Mm_=fxA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 25, 2019 at 06:15:37AM +0530, Naresh Kamboju wrote:
> On Mon, 24 Jun 2019 at 15:38, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.15 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

thanks for testing and letting me know.

greg k-h
