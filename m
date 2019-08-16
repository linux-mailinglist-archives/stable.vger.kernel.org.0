Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709058FBE5
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 09:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfHPHPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 03:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfHPHPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Aug 2019 03:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 287C42077C;
        Fri, 16 Aug 2019 07:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565939730;
        bh=FkblfPTNSNjTP99OjP72BMq0VgOgFP8UdddVUFzAqkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YNPb43NqyDNlRU9LH2BnYnZadIdbXb9pbjd1MKlb3dgasj7fmXFbQnlq959s10ny3
         UyormxE4uf+f38uY8592c+BAc7ruBLY1aXiILv31zu2FErNTkd+gOhCTBlnhrnQAu6
         MtRkS6gjJOumAXZKH75XkChUGRMO8aDqJgYAQI70=
Date:   Fri, 16 Aug 2019 09:15:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190816071528.GH1368@kroah.com>
References: <20190814165759.466811854@linuxfoundation.org>
 <20190816063921.GC3058@JATN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816063921.GC3058@JATN>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 12:39:21AM -0600, Kelsey Skunberg wrote:
> On Wed, Aug 14, 2019 at 06:59:16PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.9 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Compiled and booted with no dmesg regressions on my system.

Wonderful, thanks for testing them all and letting me know.

greg k-h
