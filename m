Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722E21F1BA8
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 17:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgFHPFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 11:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbgFHPFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 11:05:40 -0400
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD3572064C;
        Mon,  8 Jun 2020 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591628740;
        bh=sO3WCMOnXMw15fUKtCA29vNwJpoiTTFL9IjrQwVAwlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vDLai6EAjU1S+k+WbjBxEIYLmiNFfGOE9tUdp8U/TfSuXx82pVD9p6T/vutanRrIg
         njZC39u253hWIupl8R652QF68VTnTo/J6kxX26vcsIqm7OqXngglpfYwkwJ94HDLKo
         86GxHCkjlKjj1b72as6q3z+eX13SQ/VH6+eyMnLg=
Date:   Tue, 9 Jun 2020 00:05:33 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, eduard@hasenleithner.at,
        sagi@grimberg.me, hch@lst.de,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH nvme] nvme: Revert "nvme: Discard workaround for
 non-conformant devices"
Message-ID: <20200608150533.GA477@redsun51.ssa.fujisawa.hgst.com>
References: <20200603091851.16957-1-dakshaja@chelsio.com>
 <20200605134340.GA3109673@kroah.com>
 <20200608063539.GA15373@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608063539.GA15373@chelsio.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 12:05:44PM +0530, Dakshaja Uppalapati wrote:
> On Friday, June 06/05/20, 2020 at 15:43:40 +0200, Greg KH wrote:
> > On Wed, Jun 03, 2020 at 02:48:51PM +0530, Dakshaja Uppalapati wrote:
> > > This reverts upstream 'commit 530436c45ef2
> > > ("nvme: Discard workaround for non-conformant devices")'
> > > 
> > > Since commit `530436c45ef2` introduced a regression due to which
> > > blk_update_request IO error is observed on formatting device, reverting it.
> > > 
> > > Fixes: 530436c45ef2 ("nvme: Discard workaround for non-conformant devices")
> > > Cc: stable <stable@vger.kernel.org> # 4.19+
> > > Signed-off-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
> > > ---
> > >  drivers/nvme/host/core.c | 12 +++---------
> > >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > This was only for stable?
> > 
> 
> Yes this is for stable 5.4 and 4.19 branches

No, this revert needs to be rejected. The stable patches need to be the
upstream equivalent.
