Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3DA05F6
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfH1PQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 11:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfH1PQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 11:16:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987B222CED;
        Wed, 28 Aug 2019 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567005391;
        bh=TygLUFJxilcn9+OVuMoKHM9pHCCkpYXpvBLmeO3ZXdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ChWSEFvSEFY8f1u9YH6DnWrey07XYAbSKLLY16bV6exNSfi264pW877VDhFFCuGr
         moi1F8qMNoAGDRgfRzf942zgVB0qurA7jciba3phcFs33TEZ4w1qePgh62nA1aZlbI
         qTdMUzzsEgRibbOwDT2iFn5Ft5jUvP/bo4IX3xwE=
Date:   Wed, 28 Aug 2019 17:16:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190828151628.GD9673@kroah.com>
References: <20190827072738.093683223@linuxfoundation.org>
 <af4552f9-6321-dd61-2264-3f3e793aaf61@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af4552f9-6321-dd61-2264-3f3e793aaf61@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 01:09:21PM -0600, shuah wrote:
> On 8/27/19 1:48 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.11 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
