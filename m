Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559691F0AED
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 13:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgFGLTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 07:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgFGLTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 07:19:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CB6C20663;
        Sun,  7 Jun 2020 11:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591528746;
        bh=581OK8+Sq4W0QnoTgABiByBZkfha5M50UpFeg9I8kQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/te3J5IeN5fDBhM51CdmpaOOfuZrD0ebmZ6mZYulZhqaVEoBzxDxyO3PT8mbh9by
         8OAWXabis6sfUK5r2ujl5bIIi3xlgP5fwOjdl7eZPDxjK8hU3+UZYohXTrmXHZ21px
         ZM3kjH0LjKKKB4NjMIwrYLAjjRMZX2b+vDNjtbaY=
Date:   Sun, 7 Jun 2020 13:19:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/28] 4.19.127-rc1 review
Message-ID: <20200607111904.GB47740@kroah.com>
References: <20200605140252.338635395@linuxfoundation.org>
 <29f81676-b293-2264-b7b4-77ebcd6326f1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29f81676-b293-2264-b7b4-77ebcd6326f1@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 06, 2020 at 07:32:05AM +0100, Jon Hunter wrote:
> 
> On 05/06/2020 15:15, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.127 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.127-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> All tests are passing for Tegra. I am missing the report for this one. I
> can see everything passed but now our builders have been off-lined for
> the weekend. Can't believe we are giving the builders the weekend off!

Lucky builders :)

Anyway, thanks for testing all of these and letting me know.

greg k-h
