Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB2C2EAE7
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfE3DBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbfE3DBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:01:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A94724452;
        Thu, 30 May 2019 03:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185305;
        bh=PUtJt2UpKL2lAa4EDr11wrCKMz9ZJu3jR8YAgt+cK4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O660I7PYxj+iT2F9uv7Wc1ARMjGa6h/VgjLOvSd+1TgwovX5+qK7uFqFqMe+oFLii
         WpzYoa+wHj+tDEq5AtaINPOw0VEq2mntfkrADF8QGcx41hOzGS6ETV5pNqmzHu4/4M
         P4iC9UCLs4J2GdrzwIEJ8zPF41MtWl0dcbJRNRtk=
Date:   Wed, 29 May 2019 20:01:44 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll
 address" has been added to the 4.4-stable tree
Message-ID: <20190530030144.GA6051@kroah.com>
References: <20190530000140.C90462054F@mail.kernel.org>
 <VI1PR0501MB22711EFC034FE4C57C62C6B8D1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB22711EFC034FE4C57C62C6B8D1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 02:01:59AM +0000, Parav Pandit wrote:
> Hi Sasha,
> 
> > -----Original Message-----
> > From: Sasha Levin <sashal@kernel.org>
> > Sent: Thursday, May 30, 2019 5:32 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: stable-commits@vger.kernel.org
> > Subject: Patch "RDMA/cma: Consider scope_id while binding to ipv6 ll address"
> > has been added to the 4.4-stable tree
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     RDMA/cma: Consider scope_id while binding to ipv6 ll address
> > 
> > to the 4.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-
> > queue.git;a=summary
> > 
> > The filename of the patch is:
> >      rdma-cma-consider-scope_id-while-binding-to-ipv6-ll-.patch
> > and it can be found in the queue-4.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree, please let
> > <stable@vger.kernel.org> know about it.
> > 
> This patch depends on another patch [1] in same series.
> 
> However, these two patches only make sense on the kernels which has commit [2].
> Patch [2] is not available in 4.4, 4.9 and 4.14 kernels.
> 
> Therefore, patch in this email should not be applied to 4.4, 4.9 and 4.14 kernel trees.

Now dropped from all of those trees, thanks.

> [1] commit 823b23da71132b80d9f41ab667c68b112455f3b6 ("IB/core: Allow vlan link local address based RoCE GIDs")

Note this patch is only in 5.2-rc1, and not in any stable tree.  is that
ok?

thanks,

greg k-h
