Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6643A19A70D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 10:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgDAITi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 04:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDAITi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 04:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81F302078B;
        Wed,  1 Apr 2020 08:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585729178;
        bh=JwjTS3bwTaJDS/riSAQ5aa/vYk0FiIl4EYogUkNM0Ok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFMJk6JxojbKWDvRsRVeV4/F37W4Dirv+aht8O0ybrQWer32kQKS4pBeaQFbE9q5r
         RHuzpBiVE3/y4iQs5a2YkSCmYgBT20C0WTegpXLyrsbbNcMJXVUxxlYLGfDDPERrj6
         5+Kd/bmhRLV/n5EKMHvHfr25TGu2g91jLj2bgOa0=
Date:   Wed, 1 Apr 2020 10:19:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401081935.GA2023509@kroah.com>
References: <20200331085308.098696461@linuxfoundation.org>
 <0c4aaa5f-0f85-4b00-e938-4f34c55e3711@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c4aaa5f-0f85-4b00-e938-4f34c55e3711@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 01:32:53PM -0600, shuah wrote:
> On 3/31/20 2:59 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.1 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
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

Thanks for testing these and letting me know.

greg k-h
