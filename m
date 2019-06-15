Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC23470CE
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfFOP2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOP2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 11:28:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807112183F;
        Sat, 15 Jun 2019 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560612482;
        bh=HoABkGwEPy8voZE90/2/o79Up/OLWxvRlLsW3ED9Q6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=btWW2+tHiLLx7ggGeE7GuFnA/WNgCoyUMa4a6vBZCB4VghbR3UCUNXCUAhhrmLLWA
         nw7lZgA2moflL7fiGW7vmROFrgNDDtx7W+6An0piI3dzGyRN8+faD9gTxmcS6lPb8d
         3Reyu7C5q/rAsOhqpB2rYCdc7ZJqmIuUEYbpVivM=
Date:   Sat, 15 Jun 2019 17:27:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sven Joachim <svenjoac@gmx.de>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 5.1.9 build failure with
 CONFIG_NOUVEAU_LEGACY_CTX_SUPPORT=n
Message-ID: <20190615152759.GA5171@kroah.com>
References: <87k1dsjkdo.fsf@turtle.gmx.de>
 <20190611153656.GA5084@kroah.com>
 <CAKMK7uH_3P3pYkJ9Ua4hOFno5UiQ4p-rdWu9tPO75MxGCbyXSA@mail.gmail.com>
 <20190611174006.GB31662@kroah.com>
 <20190613074210.GA16875@kroah.com>
 <7c9602d9-0619-2a01-5793-dbcf259d10df@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c9602d9-0619-2a01-5793-dbcf259d10df@mageia.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 15, 2019 at 01:21:59PM +0300, Thomas Backlund wrote:
> Den 13-06-2019 kl. 10:42, skrev Greg Kroah-Hartman:
> 
> > I've just reverted it now.
> > 
> > If someone can send me a patch series of all of what needs to be
> > applied, in a format that I can actually apply them in, I will be glad
> > to do so.  But for now, I'd like to get people's systems building again.
> > 
> 
> 
> That would be basically re-adding the b30a43ac7132 commit and adding the
> following patch (also attached in case the inlined version gets mangled):

Thanks for this, I've queued it up now, let's try this all again :)

greg k-h
