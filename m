Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C11805CA
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 12:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbfHCKek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 06:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388423AbfHCKej (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 06:34:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EAE12166E;
        Sat,  3 Aug 2019 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564828478;
        bh=Xc3NPPiP7Nw3Z1ABbHPV9aIEDCt1vmQYX48K7vXTX7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u7y5auBGMYx2/Y8s1awUrB5P0grcXQTl18BUc91X3WJtinpd3itk/rM/mrK/V1FVt
         lh3gUam5DTUX1lNBxwT+cnZh4bWVK7tW10qXnEIcIpKGxHaP9qbL2MlPTLt8/r/DW2
         Vhl8cmPsbORTOszPRMC7TB4rAAiLxJLiflUnqGWM=
Date:   Sat, 3 Aug 2019 12:34:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
Message-ID: <20190803103435.GA16522@kroah.com>
References: <20190802092101.913646560@linuxfoundation.org>
 <20190803095825.GA28812@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190803095825.GA28812@amd>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 03, 2019 at 11:58:25AM +0200, Pavel Machek wrote:
> On Fri 2019-08-02 11:39:34, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.64 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> The git tree does not seem to correspond to the patches posted. git has:
> 
> commit 63a8dab46af2b65ecdb5a83662d94a3a26be973e
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Aug 2 13:30:55 2019 +0200
> 
>     Linux 4.19.64-rc1
> 
> commit 1b35ed42aeacc21a9d21646165333566dd8e181a
> Author: Xin Long <lucien.xin@gmail.com>
> Date:   Mon Jun 17 21:34:13 2019 +0800
> 
>     ip_tunnel: allow not to count pkts on tstats by setting skb's dev
>     to NULL
>     
> But 1b35ed42aeacc ip_tunnel patch is not mentioned here nor is
> included in the series on the list AFAICT. (I don't find anything
> wrong with 1b35ed42aeacc).

It was added after I did this release, see the stable mailing list for
the details, it went into the 4.14.y and 4.19.y tree at the same time.

thanks,

greg k-h
