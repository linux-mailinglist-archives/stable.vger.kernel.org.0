Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752F61762D2
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 19:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgCBShD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 13:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgCBShD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 13:37:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C51EB2166E;
        Mon,  2 Mar 2020 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583174223;
        bh=6VdW9GUf3ECxIVHNsXlXX91SuwGmgf0I9cmx7/LzW9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xBNSd3Q3Ivn+/xDQQlEXGU5dmFsRG2ZaoZHmgYoV9HZD+FYpvA1kBC7jFvKJpzm8T
         n969sFt/cqJQ/NReTQ4UXcI+rT7jx9cmhKSxVjbVO9N+ORPiH6Fy5DRjl3O7KoqwWH
         dl3Ye1cz/K1T3zSWM74uJjpTogfjKYKXVAc6jp2g=
Date:   Mon, 2 Mar 2020 19:37:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix 32-bit compatability with
 sendmsg/recvmsg" failed to apply to 5.4-stable tree
Message-ID: <20200302183700.GA159822@kroah.com>
References: <158317278525473@kroah.com>
 <344856f5-2da1-7019-fc64-f3d26b6f8962@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <344856f5-2da1-7019-fc64-f3d26b6f8962@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 02, 2020 at 11:22:26AM -0700, Jens Axboe wrote:
> On 3/2/20 11:13 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's a 5.4 version.

Thanks for this and the 5.5 version, both now queued up.

greg k-h
