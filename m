Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1541E3804B8
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 09:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhENH4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 03:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhENH4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 03:56:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF4C61446;
        Fri, 14 May 2021 07:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620978904;
        bh=HYCcBNA9s/3WlXx2fAx7Gep3zr4GVt6z0pVJMAZej9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E9LPvEyjxrYsQUl1zJPaJ/oPd2OFCgHfZmMyV3jsiwH44uT2EHSGQERjfI6eTt6h0
         dsr9hQRHncdQXGyO0OBJQJQHBqh9EzXbEeYpaDD2WfgTjea5IFmC4qaE1RcXYsgFNk
         O9S38w0f33PItmkpPKF0Xtetg5eV+FsJMgOMo2mM=
Date:   Fri, 14 May 2021 09:55:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 245/530] tty: actually undefine superseded ASYNC
 flags
Message-ID: <YJ4s1Ut2HYyjL0H7@kroah.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144827.885941093@linuxfoundation.org>
 <YJvxjC5qyyRmLSyB@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJvxjC5qyyRmLSyB@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 05:17:32PM +0200, Johan Hovold wrote:
> On Wed, May 12, 2021 at 04:45:55PM +0200, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > [ Upstream commit d09845e98a05850a8094ea8fd6dd09a8e6824fff ]
> > 
> > Some kernel-internal ASYNC flags have been superseded by tty-port flags
> > and should no longer be used by kernel drivers.
> > 
> > Fix the misspelled "__KERNEL__" compile guards which failed their sole
> > purpose to break out-of-tree drivers that have not yet been updated.
> > 
> > Fixes: 5c0517fefc92 ("tty: core: Undefine ASYNC_* flags superceded by TTY_PORT* flags")
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://lore.kernel.org/r/20210407095208.31838-2-johan@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I don't think this should be backported to any stable tree and the
> stable tag was left out on purpose.

It's about time that userspace gets this right, so this should be fine
as it's something that any out-of-tree code is going to have to get
correct eventually.

thanks,

greg k-h
