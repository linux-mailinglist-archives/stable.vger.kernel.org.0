Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF20D6F68
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 08:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfJOGIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 02:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfJOGIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 02:08:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AD420854;
        Tue, 15 Oct 2019 06:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571119728;
        bh=Eab4wxx8fkLlrOyZ0z2miUbqCj62cZt0sH+m+d7Cbxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E0EppSRJyT2oUWoTFgP9z0LJE9CninRobaES6WmlqQHMelr+YkVcG3QsJxuzgHwvo
         yfqolQF5/nYmmcUnuSA5uErokSrvJBO8iSiOTnFHqPNaPmENl0lrO/no7ENOkAonfP
         4T5AMbYso8nzIW+tYsoinZ+Xl5i74pscB3Pbhd2k=
Date:   Tue, 15 Oct 2019 08:08:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     navid.emamdoost@gmail.com, dan.carpenter@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Staging: fbtft: fix memory leak in
 fbtft_framebuffer_alloc" failed to apply to 4.14-stable tree
Message-ID: <20191015060846.GA923323@kroah.com>
References: <1571065171233128@kroah.com>
 <20191015004305.GF31224@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015004305.GF31224@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 08:43:05PM -0400, Sasha Levin wrote:
> On Mon, Oct 14, 2019 at 04:59:31PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 5bdea6060618cfcf1459dca137e89aee038ac8b9 Mon Sep 17 00:00:00 2001
> > From: Navid Emamdoost <navid.emamdoost@gmail.com>
> > Date: Sun, 29 Sep 2019 22:09:45 -0500
> > Subject: [PATCH] Staging: fbtft: fix memory leak in fbtft_framebuffer_alloc
> > 
> > In fbtft_framebuffer_alloc the error handling path should take care of
> > releasing frame buffer after it is allocated via framebuffer_alloc, too.
> > Therefore, in two failure cases the goto destination is changed to
> > address this issue.
> > 
> > Fixes: c296d5f9957c ("staging: fbtft: core support")
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> > Reviewed-by: Dan Carpenter <dan.carpenter@gmail.com>
> > Cc: stable <stable@vger.kernel.org>
> > Link: https://lore.kernel.org/r/20190930030949.28615-1-navid.emamdoost@gmail.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Conflicts due to 333c7b940526b ("staging: fbtft: Fixes some alignment
> issues - Style"). Fixed up and queued for 4.14-4.4.

Thanks for fixing this one, and the other failures up.

greg k-h
