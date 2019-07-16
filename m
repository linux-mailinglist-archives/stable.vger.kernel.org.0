Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247D66A40C
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 10:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfGPIlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 04:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbfGPIlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 04:41:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87236206C2;
        Tue, 16 Jul 2019 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563266490;
        bh=DBB35/iLHNMA2FqwsQw7nORQLk+gotkl4bG0qEae5FE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GcbF00sNNjwSXPu5gKOghSSg4FUS77FkWYXLH2OHtiZsRL7sw0/HdavXE6cD9RaAd
         z/cH/IXOeLS7+aHtptJbgGtIPZg017FReeS8eayIXTg3k2B9IFa15jlllMiSXKCLK0
         EdEtZQP/o8VexmZoG3PiLmEjXwWp8ZO+N0gToid0=
Date:   Tue, 16 Jul 2019 11:41:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry
 comparison
Message-ID: <20190716084126.GJ10130@mtr-leonro.mtl.com>
References: <20190715091913.15726-1-selvin.xavier@broadcom.com>
 <20190716071030.GH10130@mtr-leonro.mtl.com>
 <20190716071644.GA21780@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716071644.GA21780@kroah.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 04:16:44PM +0900, Greg KH wrote:
> On Tue, Jul 16, 2019 at 10:10:30AM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 15, 2019 at 05:19:13AM -0400, Selvin Xavier wrote:
> > > GID entry consist of GID, vlan, netdev and smac.
> > > Extend GID duplicate check companions to consider vlan_id as well
> > > to support IPv6 VLAN based link local addresses. Introduce
> > > a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.
> > >
> > > The issue is discussed in the following thread
> > > https://www.spinics.net/lists/linux-rdma/msg81594.html
> > >
> > > Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
> > > Cc: <stable@vger.kernel.org> # v5.2+
> > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> >
> > > Co-developed-by: Parav Pandit <parav@mellanox.com>
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> >
> > I never understood why bad habits are so stinky.
> >
> > Can you please explain us what does it mean Co-developed-by and
> > Signed-off-by of the same person in the same patch?
>
> See Documentation/process/submitting-patches.rst for what that tag
> means.

Read it, it doesn't help me to understand if I should now add
Co-developed-by tag to most of RDMA Mellanox upstreamed patches,
which already care my Signed-off-by, because I'm changing and fixing
them many times.

Maybe I should write for my upstreamed patched something like this?
Co-developed-by: Leon R...
Reviewed-By: Leon R...
Tested-by: Leon R...
Signed-by: Leon R...

Thanks

>
> thanks,
>
> greg k-h
