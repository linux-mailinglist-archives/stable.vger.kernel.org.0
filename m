Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7653032E273
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 07:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCEGq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 01:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhCEGq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 01:46:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D14B864FDF;
        Fri,  5 Mar 2021 06:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614926787;
        bh=cGQFgxlJmblPvL3rxySlbMBC5k2wRs78SF2OOqVfxxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iznQZi9oFML2ixau1wK3eYqpMmRLaURdjRFyU/O4CWteJR3cRckemi4BRGpDM/nwc
         SWcHSiFsgbdXeW3W471X0JkJBAhVyr6farFsC1TuGcTWnnjA2AV+ttgNZPXkz13Cgi
         f+nWet2GUOqz9kqdQrWVLT5ztdWTmIP31sgMTFAg=
Date:   Fri, 5 Mar 2021 07:46:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: [PATCH 4.4.y 2/2] dm table: fix no_sg_merge iterate_devices
 based device capability checks
Message-ID: <YEHTwKad3rP+fMIe@kroah.com>
References: <161460624611368@kroah.com>
 <20210305063051.51030-1-jefflexu@linux.alibaba.com>
 <20210305063051.51030-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305063051.51030-3-jefflexu@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 02:30:51PM +0800, Jeffle Xu wrote:
> Similar to commit a4c8dd9c2d09 ("dm table: fix iterate_devices based
> device capability checks"), fix NO_SG_MERGE capability check and invert
> logic of the corresponding iterate_devices_callout_fn so that all
> devices' NO_SG_MERGE capabilities are properly checked.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Fixes: 200612ec33e5 ("dm table: propagate QUEUE_FLAG_NO_SG_MERGE")
> ---
>  drivers/md/dm-table.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
