Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7223C4F2
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 09:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404148AbfFKHVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 03:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404144AbfFKHVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 03:21:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F2E2086D;
        Tue, 11 Jun 2019 07:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560237712;
        bh=fLu1hpslSz6m7EpFnbEn6tLDYatqy6ymCd8Apolhonw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yj8uuboaPFnzK7h6DjT4oWkDww5eixMUfBzqqg9wLK93JeZYuvsxeNKnZzvYsGfJY
         1XpvsvQVW+AQquYwwGVw37f5tmTaHUwpRiCS+wJtRxZGPg4Lu+djH6nbc0W1tY3mCs
         2kqWi6nrVIi5ToJ+aKNVc8d69p/SQ9WkkDmvxKzM=
Date:   Tue, 11 Jun 2019 09:21:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190611072149.GB10581@kroah.com>
References: <20190609164127.541128197@linuxfoundation.org>
 <6708fcff-8a84-5756-bc68-0de47397ab91@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6708fcff-8a84-5756-bc68-0de47397ab91@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 04:01:41PM -0600, shuah wrote:
> On 6/9/19 10:41 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.9 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
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
