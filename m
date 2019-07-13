Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EDD67AE6
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfGMPWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 11:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGMPWA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 11:22:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E1A20850;
        Sat, 13 Jul 2019 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563031319;
        bh=1aqpqVE0jdvQsXhc4WnTryI+AbAnIS85tEZGzFF5NmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjdOyQ4Rcd/wXIfxugVPGrFfD+O3eS8Nmc9FZ1yvuUpon6Eh2X7ZT7Yq7eay3mkYU
         WoZLeeuQglU9FPK6YGPaDVNXxX9bkYK7ZdYHyJW1j9n3XIoT2fe0QiRg1i8cmrZY6r
         HCMdvMcASKmV/6ZpKmZuKL7AP5achgXlQRazId1A=
Date:   Sat, 13 Jul 2019 17:21:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shreeya Patel <shreeya.patel23498@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "skha >> Shuah Khan" <skhan@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190713152156.GA10284@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <c32535cfc39724655c7ed0933cae44a779d120f9.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c32535cfc39724655c7ed0933cae44a779d120f9.camel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 03:45:14PM +0530, Shreeya Patel wrote:
> On Fri, 2019-07-12 at 14:19 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> 
> Compiled and booted successfully. No dmesg regressions.

thanks for testing!
