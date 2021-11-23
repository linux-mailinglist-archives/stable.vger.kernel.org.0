Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2035545A2AC
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhKWMgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236715AbhKWMgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:36:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B254261028;
        Tue, 23 Nov 2021 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637670790;
        bh=OQq6rH9FZx3qiPTDKlia4gm2UADleOIdpgdC75f3TB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twOffTAe/I8+7M9wZFlZ4LZVZ3JIylKvP28AVWkO7q0D6Gq69qSvVRzed0Mj/Q690
         Ka2juNYEJWg0OJX+hIh5Ha8U/8sxJxdQwH7+Y9oC4td+knrYJwzq07IT7L+gd/Q9Nc
         WSIyK+i0DUfEqxgIJX2dwlOxdcrcJc1YbrUHNdy4=
Date:   Tue, 23 Nov 2021 13:33:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 5.4 0/3] batman-adv: Fixes for stable/linux-4.19.y
Message-ID: <YZzfgzhgkOM4Yypx@kroah.com>
References: <20211120124053.261156-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120124053.261156-1-sven@narfation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 20, 2021 at 01:40:50PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> I went through  all changes in batman-adv since v4.19 with a Fixes: line
> and checked whether they were backported to the LTS kernels. The ones which
> weren't ported and applied to this branch are now part of this patch series.
> 
> For this kernel version, I only found following three patches:
> 
> * batman-adv: Consider fragmentation for needed_headroom
> * batman-adv: Reserve needed_*room for fragments
> * batman-adv: Don't always reallocate the fragmentation skb head
> 
> which could in some circumstances cause packet loss but which were created
> to fix high CPU load/low throughput problems. But I've added them here
> anyway because the corresponding VXLAN patches were also added to stable.
> And some stable kernels also got these fixes a while back.
> 
> Kind regards,
> 	Sven
> 
> Sven Eckelmann (3):
>   batman-adv: Consider fragmentation for needed_headroom
>   batman-adv: Reserve needed_*room for fragments
>   batman-adv: Don't always reallocate the fragmentation skb head

Now queued up, thanks.

greg k-h
