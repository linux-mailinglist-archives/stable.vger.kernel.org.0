Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91899AE6F4
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfIJJ3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfIJJ3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 05:29:31 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED25120872;
        Tue, 10 Sep 2019 09:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568107770;
        bh=M/1WqnE8KyzC1Zut+frnVH3Y4NLxKjV7BA/lkuC1kqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gjezKhhdCQvxKIY0YqNFnzmsSzcX9Pw0VbTtHanJzlhnztNouU+NKnILceCc7Xv6I
         fdHYLYwYrS0yN9MQbdTEOiBG2Unbk2acNUrHtHfmdOkCJIknvz6g7qFOnmBk0vZA7f
         mVfKRSao3sO+pdi6KY3BSdqa9YgCKIIm5bq6iqQY=
Date:   Tue, 10 Sep 2019 10:29:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
Message-ID: <20190910092927.GB19176@kroah.com>
References: <20190908121150.420989666@linuxfoundation.org>
 <df670408-bb4b-de9f-13d7-f9d605747df9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df670408-bb4b-de9f-13d7-f9d605747df9@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 10:20:23AM +0100, Jon Hunter wrote:
> 
> On 08/09/2019 13:40, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.14 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 10 Sep 2019 12:09:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.14-rc1-g562387856c86
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
