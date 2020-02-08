Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDFE1564F9
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 16:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgBHPDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 10:03:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbgBHPDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Feb 2020 10:03:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4372082E;
        Sat,  8 Feb 2020 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581174216;
        bh=X/BlWF00pSiOmcPTld4qliJRsKSfoijVH3MX2uKtugg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ULz6mnIDnKD/0ldo0JARP/QHyjPifpQNH8XMPwmAVwCQc2EGgwcyBF6doy0vNZzAE
         zjwFCfdPqDlpw0+ZVxmNKokkAzK5mDyic9DXpBVakSd5RM2W5DCJQNruocfshoR5+0
         Q/6LGnj6BZ6NgDxIQA2pqS3rToxGEJGlO1l+ZfXM=
Date:   Sat, 8 Feb 2020 16:03:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: v4.9.y.queue build failures (s390)
Message-ID: <20200208150334.GA1269910@kroah.com>
References: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
 <20200208132823.GA1234618@kroah.com>
 <15bfd5ad-bb01-3142-3c4a-44cb3661a772@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15bfd5ad-bb01-3142-3c4a-44cb3661a772@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 08, 2020 at 05:34:04AM -0800, Guenter Roeck wrote:
> On 2/8/20 5:28 AM, Greg Kroah-Hartman wrote:
> > On Sat, Feb 08, 2020 at 05:15:43AM -0800, Guenter Roeck wrote:
> > > For v4.9.213-37-g860ec95da9ad:
> > > 
> > > arch/s390/mm/hugetlbpage.c:14:10: fatal error: linux/sched/mm.h: No such file or directory
> > >     14 | #include <linux/sched/mm.h>
> > >        |          ^~~~~~~~~~~~~~~~~~
> > > compilation terminated.
> > > scripts/Makefile.build:304: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
> > > make[1]: *** [arch/s390/mm/hugetlbpage.o] Error 1
> > > Makefile:1688: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
> > > make: *** [arch/s390/mm/hugetlbpage.o] Error 2
> > > 
> > > Guenter
> > 
> > Thanks for letting me know, I'll try to guess and pick "sched.h" instead
> > here and push out an update.
> > 
> > greg k-h
> > 
> 
> You have "s390/mm: fix dynamic pagetable upgrade for hugetlbfs"
> in there which is tagged 4.12+.

{sigh}

yeah, stupid me, now dropped.

thanks,
greg k-h
