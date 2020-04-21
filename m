Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479B11B2F49
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDUSmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 14:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgDUSmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AE90206D9;
        Tue, 21 Apr 2020 18:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587494528;
        bh=W5iqH8D4ozFwKcYfj6Xz7G3N7rFf+lJ6e2XoJilKYKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxrTDI7aOq3eN/0af17tTwnT++GuqYFU6PmgagzU7Wvb4b+7GSJ0ROLxU/L51S3Um
         q53KgHl1Sz03V2jaF2aBzwDKL2by4PkWqLEmTBdoaGHnvXa4FpAcNAq6CXgQSsoLFZ
         yg9x4uhtUuqn9kqclJDz66KCn2e3kmHC8ordGPSU=
Date:   Tue, 21 Apr 2020 20:42:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/71] 5.6.6-rc1 review
Message-ID: <20200421184206.GA1417862@kroah.com>
References: <20200420121508.491252919@linuxfoundation.org>
 <b2fe599c-4cd6-1302-99ad-336fdaf67912@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2fe599c-4cd6-1302-99ad-336fdaf67912@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 10:49:59AM -0600, shuah wrote:
> On 4/20/20 6:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.6 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> Reboot/poweroff worked with no hangs.

Yeah, glad that issue is now resolved.  THanks for testing and letting
me know.

greg k-h
