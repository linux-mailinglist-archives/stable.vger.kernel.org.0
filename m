Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C0932FC3C
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 18:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhCFRUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 12:20:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhCFRUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 12:20:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E98B26501C;
        Sat,  6 Mar 2021 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615051201;
        bh=xetRj3rmZQfQt3c6LR210hA6CF3O9Qb6QyMhMdZgCvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ygHc8EDAjm25ict/vFdcehacUEunb0EtMiGb2A/rAcw1YDQCteE7CdXN1EgItySOg
         /xBcvFwHRjibe0m0zjdJ4nFM8hLzzEZf2F17krMuepxiKwpnGrpLUH/+ROjIy6vqB9
         5lvaTIFjGSY3qFB+8WIKyeewxj7eNFnmc6We8Md0=
Date:   Sat, 6 Mar 2021 18:19:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <YEO5vRfve1fCsZEv@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210306032428.GB193012@roeck-us.net>
 <YENRYLA3A6w5RQbH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YENRYLA3A6w5RQbH@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 06, 2021 at 10:54:40AM +0100, Greg Kroah-Hartman wrote:
> On Fri, Mar 05, 2021 at 07:24:28PM -0800, Guenter Roeck wrote:
> > On Fri, Mar 05, 2021 at 01:20:19PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.21 release.
> > > There are 102 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
> > ------------
> > Error log:
> > kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'
> 
> Ugh, I thought I dropped that patch last round, I'll go do it again
> later today, thanks for catching this...

I did drop it, and Sasha added it back, hopefully it really doesn't come
back without a working backport this time :)

greg k-h
