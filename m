Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DE324D3A5
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 13:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHULOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 07:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgHULOl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Aug 2020 07:14:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A96BF20738;
        Fri, 21 Aug 2020 11:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598008481;
        bh=ijFTi3agI+ovrb8c4NpMxZl7/UIe6XklExJQelCsTCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IxJ70GpWqufoCQhv60JfkfFs3YQJF7t5q/DCSKKAt8pSvXVU0Td+bswAEyzAXFZXd
         lOzGqrMDx3M/CvOaY5ZLIYWfI7zVQCFkkaNCWlBwQnHhW7fSBsiEnadtLHWr7N9OkQ
         XLRB1t4JNeK3SYM9b0N97fK05wwfr1mVZSqskAqA=
Date:   Fri, 21 Aug 2020 13:14:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
Message-ID: <20200821111459.GA2222852@kroah.com>
References: <20200820091612.692383444@linuxfoundation.org>
 <5de67ee5-20aa-a8f5-103c-f770d5711fba@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de67ee5-20aa-a8f5-103c-f770d5711fba@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 05:47:46PM -0600, Shuah Khan wrote:
> On 8/20/20 3:17 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.3 release.
> > There are 232 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of these and letting me know.

greg k-h
