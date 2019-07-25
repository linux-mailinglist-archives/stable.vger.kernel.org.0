Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E97747A1
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbfGYG7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387668AbfGYG7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 02:59:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 529B02081B;
        Thu, 25 Jul 2019 06:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564037980;
        bh=bLCqeo4kteEkmjqXtTjtM5PTfpwUEy83/N08lCJDEmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zq07nUqwRmG89XgxJgcSetQi0a6jTH2UY7erbmcTSecKHSySc77TNLmI0OGpwX/dJ
         zr/Jymg9Iys18yIY7egq40MlXL9pX/4zqqv9ooyKzgGcAAHgqNJ8SdCGrQewhtKARU
         lK6TwsCb5RlMiBb5A03FuYNrJ8ZYjZ979H/jFhbQ=
Date:   Thu, 25 Jul 2019 08:35:06 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sd_zbc: Fix report zones buffer
 allocation" failed to apply to 5.1-stable tree
Message-ID: <20190725063506.GE6723@kroah.com>
References: <15639782522644@kroah.com>
 <e5527e8a83751616a31ee9f6a49295e4ba7332e3.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5527e8a83751616a31ee9f6a49295e4ba7332e3.camel@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 06:07:23AM +0000, Damien Le Moal wrote:
> On Wed, 2019-07-24 at 16:24 +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Greg,
> 
> I sent you a backported version that applies cleanly to both 5.1 and
> 5.2 stable trees.

Please fix up and resend.

thanks,

greg k-h
