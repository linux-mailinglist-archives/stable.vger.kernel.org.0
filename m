Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41AE67AE8
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfGMPWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 11:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGMPWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 11:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AC8820838;
        Sat, 13 Jul 2019 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563031327;
        bh=io3SM+h+aHi1m/rewLh4BxkQOxKj7wgaz86jIry6sE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aDlUgVbCrT0Uvx3Dnjd1BrusBuAjdTfuxFMOkEh2DOMUPMoZ8U+Xgw+eVuYDqApwP
         TNBedXc6lgfBOeUJJvaahsdGPaY6vyOHSddrjl2OcUQH1lQ0AEv6J3pHjLW+W3yWRE
         AeuKjwUr19x8uTqrhpVIPlHCeJ1RS89hwApAPAaY=
Date:   Sat, 13 Jul 2019 17:22:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiunn Chang <c0d1n61at3@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190713152205.GB10284@kroah.com>
References: <20190712121628.731888964@linuxfoundation.org>
 <20190713014614.xfvf2q2bt6n5bhui@rYz3n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713014614.xfvf2q2bt6n5bhui@rYz3n>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 08:46:15PM -0500, Jiunn Chang wrote:
> On Fri, Jul 12, 2019 at 02:17:44PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.18 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Hello,
> 
> Compiled and booted fine.  No regressions on x86_64.

Thanks for testing!
