Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F10197CBC
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 15:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgC3NTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 09:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgC3NTh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 09:19:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47A52073B;
        Mon, 30 Mar 2020 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585574377;
        bh=mhR7zj1TXdIqY9TilHormp1kqcgr+fvMvMO3cKsUvqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uEa2Rhb1B84y1J+/lVOf3enNn/HjIkqWcwkF7EMqqsSY0pTwWDVWjWlKwK5Ag+tQ3
         tOgn6Fe/IPaxngi23LeCinWKQ5oIWltHlYm1/RI+1Y9vglcW7S2s+Df0F4b8fphH6d
         Bz2uYogAHWR3eEhziwpVmtsLZVdUzn9W4qegIR5w=
Date:   Mon, 30 Mar 2020 15:19:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     dan.carpenter@oracle.com, dmitry.torokhov@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] Input: raydium_i2c_ts - fix error codes
 in" failed to apply to 4.14-stable tree
Message-ID: <20200330131934.GB243244@kroah.com>
References: <15855617453276@kroah.com>
 <20200330124826.GF4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330124826.GF4189@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 08:48:26AM -0400, Sasha Levin wrote:
> On Mon, Mar 30, 2020 at 11:49:05AM +0200, gregkh@linuxfoundation.org wrote:
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
> > > From 32cf3a610c35cb21e3157f4bbf29d89960e30a36 Mon Sep 17 00:00:00 2001
> > From: Dan Carpenter <dan.carpenter@oracle.com>
> > Date: Fri, 6 Mar 2020 11:50:51 -0800
> > Subject: [PATCH] Input: raydium_i2c_ts - fix error codes in
> > raydium_i2c_boot_trigger()
> > 
> > These functions are supposed to return negative error codes but instead
> > it returns true on failure and false on success.  The error codes are
> > eventually propagated back to user space.
> > 
> > Fixes: 48a2b783483b ("Input: add Raydium I2C touchscreen driver")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Link: https://lore.kernel.org/r/20200303101306.4potflz7na2nn3od@kili.mountain
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> I also took 6cad4e269e25 ("Input: raydium_i2c_ts - use true and false
> for boolean values") to work around this conflict. Queued both for 4.14
> and 4.9.

Thanks!
