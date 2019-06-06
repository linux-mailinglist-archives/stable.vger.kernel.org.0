Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC2E37810
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfFFPe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 11:34:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729145AbfFFPe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 11:34:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16AAA20684;
        Thu,  6 Jun 2019 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559835266;
        bh=6K31Iu5396KsB5hxR9tFW6nw3eAM8bewlwdFKWn9jqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Myd8eLsLf/E3tqH15Jcp8Ykmd/QdXM+yQgBzV38p7e36jMiRQh7gEarwRk4f5isav
         zqTBa7sd7xGI4A4GNaXLTXWyaVbqvrj9LiCRI2i37EH71W+OcyQ7+bQ+i2TAOWtTw2
         i5DSz0rNALHTPbgLZ9iyxe3F8irrTrPZN8KPQ36o=
Date:   Thu, 6 Jun 2019 17:34:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Michal Hocko <mhocko@kernel.org>, stable@vger.kernel.org,
        aarcange@redhat.com, akpm@linux-foundation.org, jannh@google.com,
        jgg@mellanox.com, oleg@redhat.com, peterx@redhat.com,
        rppt@linux.ibm.com, torvalds@linux-foundation.org,
        stable-commits@vger.kernel.org
Subject: Re: Patch "coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping" has been added to the
 4.4-stable tree
Message-ID: <20190606153424.GA29314@kroah.com>
References: <155965961313615@kroah.com>
 <20190604145216.GJ4669@dhcp22.suse.cz>
 <20190604150756.GA24221@kroah.com>
 <1559663498.24330.85.camel@codethink.co.uk>
 <20190605065024.GA15685@dhcp22.suse.cz>
 <1559736528.24330.87.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1559736528.24330.87.camel@codethink.co.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 01:08:48PM +0100, Ben Hutchings wrote:
> On Wed, 2019-06-05 at 08:50 +0200, Michal Hocko wrote:
> > On Tue 04-06-19 16:51:38, Ben Hutchings wrote:
> > [...]
> > > - I don't understand why collapse_huge_range() needs to be fixed, but
> > > then I really don't understand the khugepaged code at all!  So I would
> > > trust Michal on this.
> > 
> > To be honest, I am not really sure myself here. But we are using a
> > remote mm there and I do not see anything that would prevent from racing
> > with exit/coredump. Maybe I am wrong. Let's wait for Andrea for his
> > review feedback. This patch is quite tricky for the stable backport.
> 
> So, Greg, it seems like you should drop this from the current stable
> round.

Ok, will do, thanks.

greg k-h
