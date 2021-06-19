Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDA3AD848
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 08:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhFSG4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Jun 2021 02:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhFSG4G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Jun 2021 02:56:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA73F611ED;
        Sat, 19 Jun 2021 06:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624085634;
        bh=9zVgCgDQ+NOxiIF7+ECaA7+MU7v9th8KjjE0Os3Fn0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sar6mLxr/jwJlrmylCm9dGKioONPk6SEMyDhSVxa817uR9okfO8FvYkkDtoyrNcgz
         fuNGwEbHn6sXSS2bBeKKYFITYvPzanXi3YIOgdy+kffViLJAV42JxYxX+X5nNmF6+Q
         6ujJ9xaTvqxNpoHnzG1Rzn1LbH35nvMErXuY1md8=
Date:   Sat, 19 Jun 2021 08:45:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Tsoy <alexander@tsoy.me>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 35/38] rtnetlink: Fix missing error code in
 rtnl_bridge_notify()
Message-ID: <YM2SpRA5lgMNP1W3@kroah.com>
References: <20210616152835.407925718@linuxfoundation.org>
 <20210616152836.507544876@linuxfoundation.org>
 <fb24ef9ad94f8b052407c5bdd4e3815675b89213.camel@tsoy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb24ef9ad94f8b052407c5bdd4e3815675b89213.camel@tsoy.me>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 19, 2021 at 02:58:28AM +0300, Alexander Tsoy wrote:
> В Ср, 16/06/2021 в 17:33 +0200, Greg Kroah-Hartman пишет:
> > From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > 
> > [ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]
> > 
> > The error code is missing in this code scenario, add the error code
> > '-EINVAL' to the return value 'err'.
> > 
> > Eliminate the follow smatch warning:
> > 
> > net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
> > 'err'.
> 
> This patch breaks systemd-resolved. It is 100% reproducible on two of
> my systems, but there are also systems where I cannot reproduce it. The
> problem manifests itself as SERVFAIL on every DNS query.
> 
> Just reverting this patch from 5.10.45 fixes the problem for me.

Is Linus's tree also broken for you?  It should be reverted there first.

thanks,

greg k-h
