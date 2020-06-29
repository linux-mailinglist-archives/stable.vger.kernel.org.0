Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7370820E543
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391292AbgF2Vez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgF2Skz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51CAA239EE;
        Mon, 29 Jun 2020 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593428388;
        bh=HCf1PDcazJNTYh4cWiI0TA+wRLYx2zOnUVW+p6mgCwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRN5i4WdBKUaSMoop/hlajMSmJgAJZNr/jl3HvwBcyBg9DilCEaQdh9fZmgU2+CPK
         hKEIeoFT87RepeBJHlzvRrmxd/da6nWSNaQtg0ktUCqN/g8iNMjzdZE5xsXhwp/Yxn
         NpPupo37Hyu1L6DqLfAUhWr18L+3kX4TKdSOPcsI=
Date:   Mon, 29 Jun 2020 12:59:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     linux-nvme@lists.infradead.org, chaitanya.kulkarni@wdc.com,
        stable@vger.kernel.org
Subject: Re: regression: blktests nvme/004 failed on linux-stable 5.7.y
Message-ID: <20200629105939.GA3362395@kroah.com>
References: <1528690896.32343478.1593229315244.JavaMail.zimbra@redhat.com>
 <1015661434.32401219.1593424943236.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1015661434.32401219.1593424943236.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 06:02:23AM -0400, Yi Zhang wrote:
> Hello
> 
> commit[1] introduced regression that will lead blktest nvme/004 failed on v5.7.5, and commits [2] fixed this issue on latest linux tree.
> But commit[2] cannot be directly applied to stable tree due to dependceny[3], could you help backport the fix and dependency to stable tree, thanks.
> 
> 
> [1]
> 64f5e9cdd711 nvmet: fix memory leak when removing namespaces and controllers concurrently
> 
> [2]
> 819f7b88b48f nvmet: fail outstanding host posted AEN req
> 
> [3]
> 1cdf9f7670a7 nvmet: cleanups the loop in nvmet_async_events_process
> 696ece751366 nvmet: add async event tracing support

Why is this last commit needed?

The other ones are already queued up in the current queue, thanks.

greg k-h
