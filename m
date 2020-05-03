Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766861C2A82
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 09:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgECHOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 03:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgECHOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 May 2020 03:14:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C672075B;
        Sun,  3 May 2020 07:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588490050;
        bh=uv7houaI9rr07KdIUSeqayYtqNoe/i6wze3VmJUPWhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o60HaJ9aJUoo3ReUm7D4ye82b0yaJpmdUl+sZxceSvGvGyupegqKZpfs2Pm/Dql6N
         Lxf5grZCJGeLCP8qSy3L/+x6N/ob1ylFwWSYhlCWSMwunmY3OC7GPEB/VjPm96Ruqm
         iISBbHRk9hKo3z3s4g88loZj9uVa8yoS0QtH+tYc=
Date:   Sun, 3 May 2020 09:14:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/106] 5.6.9-rc1 review
Message-ID: <20200503071408.GB504535@kroah.com>
References: <20200501131543.421333643@linuxfoundation.org>
 <769045a8-0e13-4af8-7bfb-de13a9d3038f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <769045a8-0e13-4af8-7bfb-de13a9d3038f@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 05:14:08PM -0600, shuah wrote:
> On 5/1/20 7:22 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.9 release.
> > There are 106 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
