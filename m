Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0ED020A89
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfEPO7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 10:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfEPO7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 10:59:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF392082E;
        Thu, 16 May 2019 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558018762;
        bh=pyqHeLwP0/o9bZkhKal+7TzHaVuEsQxVDwhcKhA9fIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2LAASp4DFsILEKi+SAR9UczNHo2R5cc3t23BYKuO1yGgAxlyaN/01WK3nokWL9Qf
         t76QJQDnnzzn49ejYnpMdimyzRVWkj1irSlHUZHQ0r90Hm5ycL9pYZeLXV4hLhz9oY
         NCLlb64+RUb/buooN5W9D9IpaKQ84T2QBY722CF8=
Date:   Thu, 16 May 2019 16:59:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.18 00/86] 3.18.140-stable review
Message-ID: <20190516145919.GA30606@kroah.com>
References: <20190515090642.339346723@linuxfoundation.org>
 <f2a05600-e302-9a06-80a1-421cae299287@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2a05600-e302-9a06-80a1-421cae299287@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 08:27:55AM -0600, shuah wrote:
> On 5/15/19 4:54 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.18.140 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:45 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.18.140-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-3.18.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Wonderful, thanks!

greg k-h
