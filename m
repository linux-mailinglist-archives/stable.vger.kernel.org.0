Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601B43804DE
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhENILy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 04:11:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229654AbhENILx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 04:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87A2B61451;
        Fri, 14 May 2021 08:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620979842;
        bh=ChdJtnXGfwPwSfJqxRHdRCzodI2o/6/gSbEMsLKE7H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L9veiuUvhaP+6mRKND1UX0jGh2wR/jgQUXpkc3hrjQ+alC09x2g1oLiuv/tABxsTB
         pcVq1ky8+df2/VPEGylBL3C0wRpDpVto9V7nXWbWjkTgGXmazvJVTa0TiTCZ1J+apc
         STV5rYt/u4t0hAsK1g3HxXefO7+mZbJuIUUQHcuFhsDcSqmq2N4FAvsJw3hMDub7wJ
         IV0R746R0fLJiM/S6yjFa/PjPT+ML2OFzGtD9eSLuMInGEVLdT+KL/nChGzo5Q6PUl
         /JucOUT95EQ7RrtwuMcyY7bX3arVFz0MTXZVUAQACSUvArEUNe0JSqW87Ps1XIkUep
         pTIsQhd5rNnjQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lhSuA-0008Uw-74; Fri, 14 May 2021 10:10:42 +0200
Date:   Fri, 14 May 2021 10:10:42 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 245/530] tty: actually undefine superseded ASYNC
 flags
Message-ID: <YJ4wgpBvKOlPl4lg@hovoldconsulting.com>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144827.885941093@linuxfoundation.org>
 <YJvxjC5qyyRmLSyB@hovoldconsulting.com>
 <YJ4s1Ut2HYyjL0H7@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ4s1Ut2HYyjL0H7@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 14, 2021 at 09:55:01AM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 12, 2021 at 05:17:32PM +0200, Johan Hovold wrote:
> > On Wed, May 12, 2021 at 04:45:55PM +0200, Greg Kroah-Hartman wrote:
> > > From: Johan Hovold <johan@kernel.org>
> > > 
> > > [ Upstream commit d09845e98a05850a8094ea8fd6dd09a8e6824fff ]
> > > 
> > > Some kernel-internal ASYNC flags have been superseded by tty-port flags
> > > and should no longer be used by kernel drivers.
> > > 
> > > Fix the misspelled "__KERNEL__" compile guards which failed their sole
> > > purpose to break out-of-tree drivers that have not yet been updated.
> > > 
> > > Fixes: 5c0517fefc92 ("tty: core: Undefine ASYNC_* flags superceded by TTY_PORT* flags")
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > Link: https://lore.kernel.org/r/20210407095208.31838-2-johan@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > I don't think this should be backported to any stable tree and the
> > stable tag was left out on purpose.
> 
> It's about time that userspace gets this right, so this should be fine
> as it's something that any out-of-tree code is going to have to get
> correct eventually.

Eventually, yes. Just doesn't seem right to break stuff on purpose in a
minor stable update.

That said, I really don't care one bit about out-of-tree drivers so go
ahead if you want to.

Johan
