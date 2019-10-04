Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C262CB45E
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 08:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388250AbfJDGNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 02:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbfJDGNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 02:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 531EC20862;
        Fri,  4 Oct 2019 06:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570169625;
        bh=az0+nDiQbHXVwkDwIkUVHEFXlzmlz8t1MOrD+xYtcLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rwb8cAwJ4OatNzyaO2teFMpTC98vpniWjQ5xXlZu7La/axkBqoyEtdEc5gkd66gYQ
         yz5fvSCXxvmwKxxf8/aIZzKxsPyTf8d171UwRxAcIiy5roivb/Vh4TnED8GDDZHjmh
         6LxpsQ9uwlPgQwnwNveGBUm8qkuOMgDNstYkhdnE=
Date:   Fri, 4 Oct 2019 08:13:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/344] 5.3.4-stable review
Message-ID: <20191004061343.GB845981@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <65695fdf-e399-4b0d-51bc-4243943820e9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65695fdf-e399-4b0d-51bc-4243943820e9@kernel.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:49:29PM -0600, shuah wrote:
> On 10/3/19 9:49 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.4 release.
> > There are 344 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 05 Oct 2019 03:37:47 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
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
