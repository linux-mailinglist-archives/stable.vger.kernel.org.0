Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5005461BE
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfFNOzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 10:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfFNOzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 10:55:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6666E21537;
        Fri, 14 Jun 2019 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560524112;
        bh=qPHCZhWtcqEgDltgHB7RybMnRvVYxJdmMQbDX1h+qNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ZKhN7rfbMH2nt9u5DB6cC1pmnjdP/PewuBTcd5bzVgUFiMZHL3q/b+2oQNSKue6G
         5uPjmlDAzHSGM6+hQS1+Hb3uhlexta8eNeGMA/AZyXoUXQXhM/Qdp1U8iNu3QGnMti
         wAh90U3HvSfKTtX1guYOLFeuDdlg2TRY+4RV/n94=
Date:   Fri, 14 Jun 2019 16:55:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "matanb@mellanox.com" <matanb@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Message-ID: <20190614145510.GA14860@kroah.com>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
 <9C189085-083D-46EA-98DB-B11AD62051B6@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9C189085-083D-46EA-98DB-B11AD62051B6@vmware.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 14, 2019 at 02:41:39PM +0000, Ajay Kaher wrote:
> 
> ﻿On 10/06/19, 6:22 PM, "Ajay Kaher" <akaher@vmware.com> wrote:
> 
> > This patch is the extension of following upstream commit to fix
> > the race condition between get_task_mm() and core dumping
> > for IB->mlx4 and IB->mlx5 drivers:
> > 
> > commit 04f5866e41fb ("coredump: fix race condition between
> > mmget_not_zero()/get_task_mm() and core dumping")'
> >    
> > Thanks to Jason for pointing this.
> >    
> > Signed-off-by: Ajay Kaher <akaher@vmware.com>
> > Acked-by: Jason Gunthorpe <jgg@mellanox.com>
> 
> Greg, I hope you would like to review and proceed further with this patch.  

If this is all calmed down now, I'll look at it next week, thanks.

greg k-h
