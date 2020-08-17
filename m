Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4C24676F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgHQNjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgHQNjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 09:39:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50BE520786;
        Mon, 17 Aug 2020 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597671570;
        bh=/Gv6wVbngGpL9qEocXXOBdOeIvaN2Plg1yivRAmMIQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DlYMSi0HfZaZNX89NwAhYdrrwsqfg8H286uGPRKT3GmjWafEw7mMbmyF6HYXo+Uah
         7N9a5a5tlkDSOyokQZ+0gDzN4fyTNcr2uxChvXZh9yA1QlUd+DGyGcU8S7gHWFxtAA
         CEH1Q5fUkjdOWR206Ok9PvlwKEtal4IY4SFirt2Y=
Date:   Mon, 17 Aug 2020 15:39:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: sanitize double poll handling"
 failed to apply to 5.7-stable tree
Message-ID: <20200817133950.GB359148@kroah.com>
References: <1597660994188250@kroah.com>
 <40b9659c-26c4-465f-562d-a89f80b6f361@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40b9659c-26c4-465f-562d-a89f80b6f361@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 06:15:34AM -0700, Jens Axboe wrote:
> On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's one that works.

Applied, thanks!

greg k-h
