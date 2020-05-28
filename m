Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431F41E5E28
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 13:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbgE1LYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 07:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388198AbgE1LYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612F6206F1;
        Thu, 28 May 2020 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590665043;
        bh=PfwCNa8+w0Emv4wzjvTrctgrG8v8Tsq1D9s6BwqQx+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nn0C0KGpbei/csvP7eVgEIdc2AJaFsHxpUtyg86pI5iv737oQYA7/K/5qhn1HJDLF
         nMVlwrNfEwOlxUnI18yjND+nwXJltLs/3cww7MLcDcyjNGZNBb4qqarZG3MHiC1zrO
         B7OdAjuIGFUzhlbJOM1qDrdJBf42R5sQ1096VgIY=
Date:   Thu, 28 May 2020 13:24:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.6 086/126] virtio-balloon: Revert "virtio-balloon:
 Switch back to OOM handler for VIRTIO_BALLOON_F_DEFLATE_ON_OOM"
Message-ID: <20200528112401.GA3174440@kroah.com>
References: <20200526183937.471379031@linuxfoundation.org>
 <20200526183945.237904570@linuxfoundation.org>
 <8f649042-bc3a-2809-0332-44a5d3202807@suse.cz>
 <c8253932-5e6b-51e1-fe0c-19514779c9be@redhat.com>
 <20200528111117.GK33628@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528111117.GK33628@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 28, 2020 at 07:11:17AM -0400, Sasha Levin wrote:
> On Thu, May 28, 2020 at 10:21:41AM +0200, David Hildenbrand wrote:
> > On 28.05.20 07:51, Jiri Slaby wrote:
> > > On 26. 05. 20, 20:53, Greg Kroah-Hartman wrote:
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > 
> > > > [ Upstream commit 835a6a649d0dd1b1f46759eb60fff2f63ed253a7 ]
> > > > 
> > > > This reverts commit 5a6b4cc5b7a1892a8d7f63d6cbac6e0ae2a9d031.
> > > > 
> > > > It has been queued properly in the akpm tree, this version is just
> > > > creating conflicts.
> > > 
> > > Should this be applied to stable trees at all?
> > > 
> > > To me, it occurs to be a revert to avoid conflicts, not to fix something?
> > 
> > Agreed.
> 
> Right, I'll drop it - thank you.

Already committed, I'll go revert this now, thanks.

greg k-h
