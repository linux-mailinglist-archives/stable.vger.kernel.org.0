Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3735115F8A2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbgBNVSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgBNVSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:18:34 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F5E222C4;
        Fri, 14 Feb 2020 21:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715114;
        bh=XEc5EaSg0Vz//OyVSJdvtd6eH5z5ND0G4Cl8HbKlLOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M2bqMrJ3LPtazLraWkr/LSsQoxmWMrZ6h5dWyzcwrw6NT2e+s/KV9hjHj743cfZPO
         v0h9kANVPRt+AgmEYLO2v9SP8Vhxvt1RPnkJK+E7/ZlxMQA7LMMBqkb1egnBI6H4NX
         SkxoMf7rVlPtZsW+n5L9f84YNaxrfWdkkIk+ydsI=
Date:   Fri, 14 Feb 2020 16:17:44 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214211744.GA4144398@kroah.com>
References: <20200213151901.039700531@linuxfoundation.org>
 <20200214155834.GA6389@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214155834.GA6389@debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:28:34PM +0530, Jeffrin Jose wrote:
> On Thu, Feb 13, 2020 at 07:19:56AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.4 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> 
> hello,
> 
> compiled and booted 5.5.4-rc1+ . No new errors according to "dmesg -l err"

Wonderful, thanks for testing and letting me know.

greg k-h
