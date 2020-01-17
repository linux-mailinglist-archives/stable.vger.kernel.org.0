Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C64140C59
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 15:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgAQOXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 09:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgAQOXJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 09:23:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AAD62072B;
        Fri, 17 Jan 2020 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579270988;
        bh=gap0/53YJTTxUaW1ZNsFwWpb1xxgzIidqgjjcXgrN+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yL8XQo0/T8tM+oLhkkhEBUIlSgtOtklw8DJxtDTDZmlFcRLjOnrNsKzXFVYRt+QPP
         shxieXZfXPMwLnKMhhNCktJPQDn8uDBw2LMiyJqyq6puJESG1Y+p7CUmqtzHu8z74M
         8TWVxUStNO/q0+DyqBchUg2dzRdoJc/3fvQA4JkE=
Date:   Fri, 17 Jan 2020 15:23:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/203] 5.4.13-stable review
Message-ID: <20200117142306.GA1879300@kroah.com>
References: <20200116231745.218684830@linuxfoundation.org>
 <25658ca7-fa1a-303b-7a75-099b9bcf235b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25658ca7-fa1a-303b-7a75-099b9bcf235b@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 01:21:02PM +0000, Jon Hunter wrote:
> 
> On 16/01/2020 23:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.13 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.13-rc1-g3c8b6cdc962e
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing these and letting me know.

greg k-h
