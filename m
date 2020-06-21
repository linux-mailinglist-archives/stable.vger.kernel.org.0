Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDF22029CD
	for <lists+stable@lfdr.de>; Sun, 21 Jun 2020 11:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgFUJZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jun 2020 05:25:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbgFUJZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jun 2020 05:25:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B582320C09;
        Sun, 21 Jun 2020 09:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592731518;
        bh=Hqy33nzHbNYYYlgMleWec/Gwa2GJ+4OMw/FM2IpGj3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lrEQyxWgd657fPOsY2AzFlUzZ/YH2skOBnHsCkjeI2ikSVd4rbCKdHtFR3RR1CbP6
         +v97ZjOlXsl4/4X+BJA2GjhqGvgw4TrfyMW6RCL6DmiSDgTiH5aQqgIx52BcNGWWex
         DjGfkWj294HTxvWpN0tx8pO1q4ejnXptTC0RZ4C0=
Date:   Sun, 21 Jun 2020 11:25:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
Message-ID: <20200621092514.GB97925@kroah.com>
References: <20200619141710.350494719@linuxfoundation.org>
 <253bcb22-78c4-6dd9-12cd-5eeb942c5bbc@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <253bcb22-78c4-6dd9-12cd-5eeb942c5bbc@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 11:07:12PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 6/19/20 9:28 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.5 release.
> > There are 376 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 

THanks for testing all of these and letting me know.

greg k-h
