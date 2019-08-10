Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6E4888FB
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 09:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbfHJHJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 03:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfHJHJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Aug 2019 03:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641712089E;
        Sat, 10 Aug 2019 07:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565420950;
        bh=p0UXi5jlbcF7bmE2fgD2iuaEiQDHVwlnBHdKGXSI3JU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e53XEIDXaB5XYUVveX3PR6Zu8miEigROCFbI962PF8rpoxs/X6CCLmBOMezLmRRJT
         Pk9amNebvkGrK/5Qg4z+aODFQkzsf3eda/h72omXrYHs5HzBD6waws41p9JwVWumNm
         XadIexPe7qg894jsvEm6ptSqVUOQTq5PegknJoh0=
Date:   Sat, 10 Aug 2019 09:09:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.189-stable review
Message-ID: <20190810070908.GE6896@kroah.com>
References: <20190809133922.945349906@linuxfoundation.org>
 <f6ab9977-49df-af3f-6bab-0eafc1b4c44f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ab9977-49df-af3f-6bab-0eafc1b4c44f@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 04:07:14PM -0600, shuah wrote:
> On 8/9/19 7:45 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.189 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 11 Aug 2019 01:38:45 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.189-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing both of these and letting me know.

greg k-h
