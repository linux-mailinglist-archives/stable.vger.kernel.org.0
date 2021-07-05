Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3D3BB783
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhGEHKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGEHKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 03:10:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DF8F61351;
        Mon,  5 Jul 2021 07:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625468881;
        bh=ToGOTX4jLedytfqbRzNU5vA7JybZemZVcqhFwXpJz7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYGDE9iSa6qnls2RjDEQQfEIafbam6pX5umieKcf63ZxNWH13qpi1iMl5ZBKqUU/V
         S4b7EoYrbi3ctUvUR9ntq6jzfZjQlOWKXBaegYCYTTUbp8+KuiklBPqon4vGxy9UD8
         PixDjn8ZVzXcPoNPl1GsiTyS3KO8QubRt6Bu1Xtc=
Date:   Mon, 5 Jul 2021 09:07:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Eddie Hung <eddie.hung@mediatek.com>
Subject: Re: [PATCH v4.14] usb: gadget: f_fs: Fix setting of device and
 driver data cross-references
Message-ID: <YOKvz2WzYuV0PaXD@kroah.com>
References: <20210603171507.22514-1-andrew_gabbasov@mentor.com>
 <20210604110503.GA23002@vmlxhi-102.adit-jv.com>
 <CACCg+XO+D+2SWJq0C=_sWXj53L1fh-wra8dmCb3VQ4bYCZQryA@mail.gmail.com>
 <20210702184957.4479-1-andrew_gabbasov@mentor.com>
 <20210702184957.4479-2-andrew_gabbasov@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702184957.4479-2-andrew_gabbasov@mentor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 02, 2021 at 01:49:57PM -0500, Andrew Gabbasov wrote:
> Fixes: 4b187fceec3c ("usb: gadget: FunctionFS: add devices management code")
> Fixes: 3262ad824307 ("usb: gadget: f_fs: Stop ffs_closed NULL pointer dereference")
> Fixes: cdafb6d8b8da ("usb: gadget: f_fs: Fix use-after-free in ffs_free_inst")
> Reported-by: Bhuvanesh Surachari <bhuvanesh_surachari@mentor.com>
> Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
> Link: https://lore.kernel.org/r/20210603171507.22514-1-andrew_gabbasov@mentor.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> (cherry-picked from commit ecfbd7b9054bddb12cea07fda41bb3a79a7b0149)

There is no such commit id in Linus's tree :(

Please resubmit with the correct id.

thanks,

greg k-h
