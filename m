Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B80F279A9E
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 18:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgIZQKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 12:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgIZQKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 12:10:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57ADB2083B;
        Sat, 26 Sep 2020 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601136633;
        bh=SvvlnA+2hqdXxuFiLTuOyuSVGEsj1AU6uaCHf1FzS/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PDjSksLEelv76bZ2Gad6xkkizUi/rb36bJ3btvLQuMtn9EyeTttxkowpV/WTiZPjr
         d4ynu5VehddI7Mp5drDCoWVMOzG9ReRyHa8L0rtK/+AGmQRco7O97Mtgc5sHLbSVbC
         mrm3FoH5/Q3yYY05d+qZSvR7D086V5UHyzG+ZrDQ=
Date:   Sat, 26 Sep 2020 18:10:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/56] 5.8.12-rc1 review
Message-ID: <20200926161046.GE3361615@kroah.com>
References: <20200925124727.878494124@linuxfoundation.org>
 <6b36894105c87c32f83958d5e161184e42ff7ad5.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b36894105c87c32f83958d5e161184e42ff7ad5.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 26, 2020 at 02:52:03AM +0530, Jeffrin Jose T wrote:
> On Fri, 2020-09-25 at 14:47 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.12 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Sun, 27 Sep 2020 12:47:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in on
> > greg k-
> 
> Compiled and booted 5.8.12-rc1+ . "dmesg -l err" did not report any
> error or errors.
> 
> Tested-by:  Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

Thanks for testing this one!

greg k-h
