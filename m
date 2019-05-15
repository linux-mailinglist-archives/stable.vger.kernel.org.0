Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2C1F665
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfEOOSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 10:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfEOOSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 10:18:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482262084E;
        Wed, 15 May 2019 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557929911;
        bh=fhtXysbtrB4Z/20Qhee0D7pQxR0XGyrYHkDHHmLIO0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IhJWBor9rlI5x96L4OeVRWXOHQIFCKzjDy1DSwtOot2qDt8r+7U1bsuWUg2qFKMlw
         cYsjy6wXgzns22owI3uXWSHzuDdne4S5ISfzHGFwA9KSRbuVHgZniMSbmldiveAZ0N
         hjUyPj3+RTd6AdFRk+JJ+Zc3CcM4s6ref7Ejax7I=
Date:   Wed, 15 May 2019 16:18:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190515141829.GC8999@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <583de1c8-585c-e656-6251-84b6e563af42@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583de1c8-585c-e656-6251-84b6e563af42@aquantia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 01:56:47PM +0000, Igor Russkikh wrote:
> 
> 
> On 15.05.2019 13:56, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> ...
> 
> > Oliver Neukum <oneukum@suse.com>
> >     aqc111: fix double endianness swap on BE
> > 
> > Oliver Neukum <oneukum@suse.com>
> >     aqc111: fix writing to the phy on BE
> > 
> > Oliver Neukum <oneukum@suse.com>
> >     aqc111: fix endianness issue in aqc111_change_mtu
> 
> Hello Greg,
> 
> Could you please drop these three patches from the queue?
> They are invalid and will be reverted in net tree.
> 
> https://lore.kernel.org/netdev/1557839644.11261.4.camel@suse.com/

Now dropped from the 5.0 and 5.1 queues.

thanks,

greg k-h
