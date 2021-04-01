Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A873519B7
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhDAR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 13:56:04 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34017 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237201AbhDARvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 13:51:04 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 142365C00A7;
        Thu,  1 Apr 2021 10:12:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 01 Apr 2021 10:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9UAT0c2LugB9PUWh+diHpFdwfan
        OxGFidpLL8PqB0U8=; b=FjprwOAcDzpw72Zlv4LYPSnaAFUSaRKAbj2KZY/d9Lh
        vQoDBjkf7tlikzzGQWeGvcUUoqFssa+OkjP6AOfFlYZIm3HdQM2LENZMwiHboaU5
        3wN9wQCswSQVg1rfTliEgFCqQLikxXn0hR9tsNAfe9Khosl75kaxkr+acFJWjLm0
        6ae1ZVpLRO5wKoH6UusRHa2OV8evUed4dosMmHKwS4VvSiOn7SktmcEw511xjfCd
        bNSzZ0UwAGtiK/0mAIFGe7QOQvLQAQKUt1Mct6L7/RqEQjxlNbrZVpFytKGPZiJ/
        MFvSPHks7OrJxq+KVMerHsnkv6xOhfunRjjDF2gEU8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9UAT0c
        2LugB9PUWh+diHpFdwfanOxGFidpLL8PqB0U8=; b=io5OYunkOaSxF9h5Ifxn7g
        pvZhYRtT1mScZrFI0hcQFaIP8BMZThNakTr1pSGTOw9Ka2QaeUFmViwg7Wpp3+SL
        Vsh96aXY6bByoeOSs5HugF6lKiDVrr8v8x4kMvH0jD9wWbtE5W28uAFxSy5Q5J/Q
        Ln9iTEQc9q7IQ0jBM1wI3LVSfuPOs75Q3mWMK4ufbvQo2k+JsDbw6N3fFnTu9E5m
        w/OmLryKuHayYHeC3fi7+V5bypbTP0He/ptxUk77n9dSplvPVMB///DfkXwHK3aW
        nqvsrQmWnu2TD7X0kvF4gDK4kjpW/RYkJvNdaw7KIBDzgxXJEU86M9za9Loi0crg
        ==
X-ME-Sender: <xms:v9RlYJEJjGgq57BqXrcEn5bUifotGJsZJcJ8ACfW8Wv0s4M1b8iNMQ>
    <xme:v9RlYDli4_KrZO4RLiBJnvzr16X7-uPd8iGp2hlkHnbIFQIBzKG7b_aF5Bw-KWvkI
    AMnhnZooXD69Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeigedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:v9RlYM2nL4hk1jQooiG4M0mlAQm2sZgnRbKg3sMhQbGwrvTydCk0tw>
    <xmx:v9RlYHSWUXgsLya9H528mPDjNBHCyFLnUMK0D7XPI2Zx-YcJ6jIMew>
    <xmx:v9RlYGuQs_pCZDZ7ugh9L5FVzjIsnrXLv5C4V4ybXVXx_fvhZUs6MA>
    <xmx:wNRlYApMrYycJx_GTfwbANmSJeL1qumxbVHrQ0HnkEQpuGSv-R3n1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDBEF1080067;
        Thu,  1 Apr 2021 10:12:14 -0400 (EDT)
Date:   Thu, 1 Apr 2021 16:12:11 +0200
From:   Greg KH <greg@kroah.com>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Message-ID: <YGXUu88J811vV+p8@kroah.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
 <YGVi7uT9kyfk7Mo7@kroah.com>
 <5d90f5b0-c161-bba7-5151-4d8a1c679b44@cornelisnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d90f5b0-c161-bba7-5151-4d8a1c679b44@cornelisnetworks.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 01, 2021 at 10:02:30AM -0400, Dennis Dalessandro wrote:
> On 4/1/2021 2:06 AM, Greg KH wrote:
> > On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
> > > On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
> > > > On Mon, Mar 29, 2021 at 09:48:17AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
> > > > 
> > > > > diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > > > index 2c8bc02..cec02e8 100644
> > > > > +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > > > @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
> > > > >    void hfi1_netdev_free(struct hfi1_devdata *dd)
> > > > >    {
> > > > >    	if (dd->dummy_netdev) {
> > > > > +		struct hfi1_netdev_priv *priv =
> > > > > +			hfi1_netdev_priv(dd->dummy_netdev);
> > > > > +
> > > > >    		dd_dev_info(dd, "hfi1 netdev freed\n");
> > > > > +		xa_destroy(&priv->dev_tbl);
> > > > >    		kfree(dd->dummy_netdev);
> > > > >    		dd->dummy_netdev = NULL;
> > > > 
> > > > This is doing kfree() on a struct net_device?? Huh?
> > > > 
> > > > You should have put this in your own struct and used container_of not
> > > > co-oped netdev_priv, then free your own struct.
> > > > 
> > > > It is a bit weird to see a xa_destroy like this, how did things get ot
> > > > the point that no concurrent thread can see the xarray but there is
> > > > still stuff stored in it?
> > > > 
> > > > And it is weird this is storing two different types in it too, with no
> > > > refcounting..
> > > 
> > > We do rework this stuff in the other patch series.
> > > 
> > > https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483-11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
> > > 
> > > If we fix it up in the for-next series, what should we do about stable?
> > 
> > What does stable matter?  WHy can it not just take the same patches that
> > end up in Linus's tree?
> 
> Guess it's more of a general question. What is the best way to handle things
> if the code changes drastically in Linus' tree, to the point where the bug
> no longer exists there, but does in stable?

Documentation/process/stable-kernel-rules.rst should be your first stop
for stuff like this.  Why not just take those "drastic changes" into the
stable kernel as well?

If for some reason that is impossible, then just email a patch to stable
and document the heck out of why this is not in Linus's tree and what
you have done to ensure that this change is correct.  And get the
maintainer to agree.  And be ready to fix it up again afterward as 90%
of the time we do this, the "new patch" causes problems :)

thanks,

greg k-h
