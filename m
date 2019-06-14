Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59DA45440
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 07:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfFNFtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 01:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfFNFtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 01:49:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 933602133D;
        Fri, 14 Jun 2019 05:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560491351;
        bh=wIqYOuhdSMFupVcnp9vW1Ue7FJ+QVtopxgZS/I94rcU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zIjGdJkTICYEs2AtYUBI5SfDCwPix8SSCwIDPAOEB1iwfDOrDS6SLXVlegIE5tSoM
         aVQX+eVWdqGG4b+gOtUcH/vZhGOuwCAxfO4Kd2T/SA7adbBwSgeYtVViYmL4fw0McT
         LghW8IXhxvRshc/YxBNtlfVw8FSXNBT3N49+jDGA=
Date:   Fri, 14 Jun 2019 07:49:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614054908.GB27319@kroah.com>
References: <20190613075652.691765927@linuxfoundation.org>
 <CA+G9fYsRq=DyOWhhPq3axyhLVBWLp7-3QZ3p5dSScR06ar5SZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsRq=DyOWhhPq3axyhLVBWLp7-3QZ3p5dSScR06ar5SZg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 12:09:12AM +0530, Naresh Kamboju wrote:
> On Thu, 13 Jun 2019 at 14:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.10 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
