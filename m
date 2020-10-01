Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858A72807AE
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgJATYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:24:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:24:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B74DA20848;
        Thu,  1 Oct 2020 19:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580254;
        bh=UxYRzYsn7QPxpJqwCh+bYsmoiiSgAYFg/8tIEdK1iz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ckKS7kcHgi9/RjfvTuE7cWlhNaY/svhcoSx79+AZ3/Ba1RTwhENSkMx/1KH7iiD3K
         m3WisrJ/gc2Y4u+LVwEcp47ySlmuyK4QXKP82uZfnS19/gdKnHIQ8kY4hYiueIsslc
         4QvoboVI49rC4Q+kDHApAtmSWQkhAJa6sfcGCsmk=
Date:   Thu, 1 Oct 2020 21:24:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
Message-ID: <20201001192414.GF3873962@kroah.com>
References: <20200929105929.719230296@linuxfoundation.org>
 <6e54e620-dbeb-0a39-b641-3fce97267b16@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e54e620-dbeb-0a39-b641-3fce97267b16@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 30, 2020 at 08:26:20AM -0600, Shuah Khan wrote:
> On 9/29/20 5:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.13 release.
> > There are 99 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing them all and letting me know.

greg k-h
