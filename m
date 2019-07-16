Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4E26A2BA
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 09:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfGPHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 03:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfGPHRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 03:17:18 -0400
Received: from localhost (unknown [113.157.217.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B5520880;
        Tue, 16 Jul 2019 07:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563261437;
        bh=ivmkYK87VvmWfwPxJ42xkGY8yxoOqLZyFPSJsjyYH8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PdYkRnKFI8BpFImebLmZjpoYxZvey+sR4PqUZI45mlNqCICAp8KEdn9O9jC6nURVf
         3nWumJTDL8jd2+pbS2SFBcfr+YJxfdD5UVUU23Ml6Ojqzb4BAnKsD/OI6sVfw4GGVR
         c0FdnfV0ov755dlSVXxGJ7BCa1KPibpctfO3dsyE=
Date:   Tue, 16 Jul 2019 16:16:44 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry
 comparison
Message-ID: <20190716071644.GA21780@kroah.com>
References: <20190715091913.15726-1-selvin.xavier@broadcom.com>
 <20190716071030.GH10130@mtr-leonro.mtl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716071030.GH10130@mtr-leonro.mtl.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 10:10:30AM +0300, Leon Romanovsky wrote:
> On Mon, Jul 15, 2019 at 05:19:13AM -0400, Selvin Xavier wrote:
> > GID entry consist of GID, vlan, netdev and smac.
> > Extend GID duplicate check companions to consider vlan_id as well
> > to support IPv6 VLAN based link local addresses. Introduce
> > a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.
> >
> > The issue is discussed in the following thread
> > https://www.spinics.net/lists/linux-rdma/msg81594.html
> >
> > Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
> > Cc: <stable@vger.kernel.org> # v5.2+
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> 
> > Co-developed-by: Parav Pandit <parav@mellanox.com>
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> 
> I never understood why bad habits are so stinky.
> 
> Can you please explain us what does it mean Co-developed-by and
> Signed-off-by of the same person in the same patch?

See Documentation/process/submitting-patches.rst for what that tag
means.

thanks,

greg k-h
