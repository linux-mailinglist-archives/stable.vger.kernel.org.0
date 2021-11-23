Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9845A2E6
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhKWMof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:44:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231623AbhKWMoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:44:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BB6F60F50;
        Tue, 23 Nov 2021 12:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637671286;
        bh=FRikde0I9a4WzIpqUt2iCu9byjSggwOwavedsafE5BY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iyquXK1I9LX5sIlQpMQ6wI4Cx2eifVgsSChGeoRAzyib/epBAQVlW1LdwucdvIclO
         uw3JU8SiHLLYS/kky6J95Lpmab2uFUQHxEdCG1mEg4rLCGwQ0Mv5bCRcsWoDAuEkBW
         tSM+opOqQhYJt4uPXcHBdlfy98cLCetENWC7kuEk=
Date:   Tue, 23 Nov 2021 13:41:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 4.4 00/11] batman-adv: Fixes for stable/linux-4.4.y
Message-ID: <YZzhdAFXzHaNt5eQ@kroah.com>
References: <20211120123939.260723-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120123939.260723-1-sven@narfation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 20, 2021 at 01:39:28PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> I went through  all changes in batman-adv since v4.4 with a Fixes: line
> and checked whether they were backported to the LTS kernels. The ones which
> weren't ported and applied to this branch are now part of this patch series.
> 
> There are also following three patches included:
> 
> * batman-adv: Consider fragmentation for needed_headroom
> * batman-adv: Reserve needed_*room for fragments
> * batman-adv: Don't always reallocate the fragmentation skb head
> 
> which could in some circumstances cause packet loss but which were created
> to fix high CPU load/low throughput problems. But I've added them here
> anyway because the corresponding VXLAN patches were also added to stable.
> And some stable kernels also got these fixes a while back.

All patches and series now queued up, thanks!

greg k-h
