Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A671A2E98D0
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbhADPb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbhADPb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:31:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67DB6221F9;
        Mon,  4 Jan 2021 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609774278;
        bh=rOGxdK3PtLlK0J3tsVfJTyEgs6tZWXz3msutsPhMVEE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PWyXCpA6jTHCNp1SpHjW+NwQbr2G6qtkneSvlqQBTjPn7OH5psJWVE/wG0E5ND/RO
         gUfYea3jGf7RQZ9timvGh+XQGD4Sy1cQcKBv69Cn/fvI7xljeczoSS/0zgTfwsIptY
         2uVacw6srAXs0nOPYARJZk8lcSHBt1CHGrRV1Txyw0BUu6iIPov0gh9Z+blvjY2tcA
         Fqps0oLqwxe0p9LwD67qR/IgaCMeUhp8tii9IarSuoKGJhsNeML38T+fcVFM23nkS5
         O34wdj7mUFuKo1A/Zf0SjusLwQZBCW/Bi/Wk+C2j3yJ5+nP5NPzjFkT1btKwZa/DWZ
         UykQQj31wTnfg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kwRpD-0002Qj-AX; Mon, 04 Jan 2021 16:31:16 +0100
Date:   Mon, 4 Jan 2021 16:31:15 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: iuu_phoenix: fix DMA from stack
Message-ID: <X/M0wxQfyr6gCBkK@hovoldconsulting.com>
References: <20210104145007.28093-1-johan@kernel.org>
 <X/Ms7xMPzdgWs8Fx@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/Ms7xMPzdgWs8Fx@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 03:57:51PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Jan 04, 2021 at 03:50:07PM +0100, Johan Hovold wrote:
> > Stack-allocated buffers cannot be used for DMA (on all architectures) so
> > allocate the flush command buffer using kmalloc().
> > 
> > Fixes: 60a8fc017103 ("USB: add iuu_phoenix driver")
> > Cc: stable <stable@vger.kernel.org>     # 2.6.25
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing. Now applied.

Johan
