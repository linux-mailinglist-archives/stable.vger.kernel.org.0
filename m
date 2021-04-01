Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F76C350ED4
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 08:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhDAGHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 02:07:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39091 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhDAGGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 02:06:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BAB965C006C;
        Thu,  1 Apr 2021 02:06:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 01 Apr 2021 02:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+Nx6s3UwfIcxI0qux520/i5gi8M
        E7b+zSgs6x2c/WIA=; b=h6/Dz6sAcr8rWPxRzVYN++9LrgxarwOFvTGnpBJYgYf
        0ihNBr3JG2u2LzdJiVEfHvZfgHLE3av4KQCU4LmfhWjDs3NaVyGZuKknWA59Eu3Y
        RWm6j3qtltBdiT8735NqlIbMLaeQ22ojKWdWkXaBFcKtnvMDHdxJYcOfwlD6Kbye
        feyveLZWEjH42oepk/4Hegxl+XXeXefi7QW56Z+vEMI+sOLWRls47JUVqSD6wUd3
        McwY/pefxkazD+ws4EsI9U7tXPTi9sUF+O5UgwQGN8BEGsCHug6izMjMTejeGo15
        iqK/GVoJypZIZkDw2fIqI+MmUnjncfRHtT2P+Jy0QRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+Nx6s3
        UwfIcxI0qux520/i5gi8ME7b+zSgs6x2c/WIA=; b=jJtCeFPlZFLHmiOiO56O5J
        Dtu773W8ZTmF8q0HiuAmDg+XPHKASOAFAU/u0gaqtF7VJdOxR13XKg49XbP2VXyE
        yBS4YJPl9r/Lj2YlqEh9NDgZr5s9Omaoq6UcGmaMuRvWUAgDrnrdRPCMMGnnSMiv
        uMam6+2RlZqCkJYgcejaAym3E++m59JIEckomW1Us3IgGgBkAwHZAzNEcS68Zysg
        HnFCzlT3LF/j29chmOg1uqlYExCTF+P+qQKcYCjEJmRSAS9qY3E1bauIudpO816C
        ut2Anm/1i0vd9nmaKp/a7tj7y02+WaNiGfFaP/Lv6LjD6JGIRlb9joZaBJj+2+pQ
        ==
X-ME-Sender: <xms:8GJlYBN3DZJv4yFcce13nyuWLKI3QBrabgKY7aLGyGUWk02Jhf_z_Q>
    <xme:8GJlYMYf_tDYlh5aGxbEZDaa2qmMI9vVJOm2XQNgkOAagZQgQTYHC3gNSIGQQtxli
    GEHQd0S_ATTog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeifedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:8GJlYAvbNC8Utd77jfGT-DD2crmh3-NqhgFgF2IuaykBIjSVkApM8A>
    <xmx:8GJlYOP05nShHd872S1TsdxenR6YpO2XAIr0HF6SYujjZB08OzCw4A>
    <xmx:8GJlYH5VznASdEFZnZzDX-LvtkkaljVQJ4AplFYsW-WzsBtBo4E7jw>
    <xmx:8mJlYEBvvlwzdkqE8GMehEqLdf6iXffzw8MQRTyMmpfGKcnQowO8ZA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AC8B108005C;
        Thu,  1 Apr 2021 02:06:40 -0400 (EDT)
Date:   Thu, 1 Apr 2021 08:06:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Message-ID: <YGVi7uT9kyfk7Mo7@kroah.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
> On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
> > On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> > 
> > > diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > index 2c8bc02..cec02e8 100644
> > > +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
> > >   void hfi1_netdev_free(struct hfi1_devdata *dd)
> > >   {
> > >   	if (dd->dummy_netdev) {
> > > +		struct hfi1_netdev_priv *priv =
> > > +			hfi1_netdev_priv(dd->dummy_netdev);
> > > +
> > >   		dd_dev_info(dd, "hfi1 netdev freed\n");
> > > +		xa_destroy(&priv->dev_tbl);
> > >   		kfree(dd->dummy_netdev);
> > >   		dd->dummy_netdev = NULL;
> > 
> > This is doing kfree() on a struct net_device?? Huh?
> > 
> > You should have put this in your own struct and used container_of not
> > co-oped netdev_priv, then free your own struct.
> > 
> > It is a bit weird to see a xa_destroy like this, how did things get ot
> > the point that no concurrent thread can see the xarray but there is
> > still stuff stored in it?
> > 
> > And it is weird this is storing two different types in it too, with no
> > refcounting..
> 
> We do rework this stuff in the other patch series.
> 
> https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
> 
> If we fix it up in the for-next series, what should we do about stable?

What does stable matter?  WHy can it not just take the same patches that
end up in Linus's tree?

thanks,

greg k-h
