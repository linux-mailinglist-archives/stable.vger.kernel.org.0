Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E233E97
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfFDFu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDFu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 01:50:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5ED2064A;
        Tue,  4 Jun 2019 05:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559627429;
        bh=qyabw+QI3W1pUMAUFsWv+0ICU//HDk2k/J6gphOlGSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDRURUmFOypkp2P3j+lBMad+gCMpqZrBCCI9dnXbCyBk/PR0LJtdpgKHh8MYEY6zM
         SWFpWhovEJY0Rll9SUYhYBDfFzke2ACsKlKh315fLkoV+IDRj66tMZR5zNlu7Fkb3X
         Rg0GrjzdhvjcLQSauBPmwrLFtzpWUP7Op09Yc1JA=
Date:   Tue, 4 Jun 2019 07:50:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190604055026.GC16504@kroah.com>
References: <20190603090522.617635820@linuxfoundation.org>
 <59b66e9f-69be-63a8-348a-9a24a1246dbf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b66e9f-69be-63a8-348a-9a24a1246dbf@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 05:31:48PM -0600, shuah wrote:
> On 6/3/19 3:08 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.7 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
