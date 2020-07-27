Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D5122F652
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgG0RNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 13:13:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgG0RNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 13:13:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E14672075A;
        Mon, 27 Jul 2020 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595870028;
        bh=qUJMIgaYsWCQp+a+C6JTgglyRu8tVPORSYp8mPuqrfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1MpmWjOcHgIGa2ZLQ943k06P7VD//wZTjppxFTJcee0qsEy/qSZ5lF7SQIvz3Q5tT
         5nqk6rgenLtSJhI86F90MZXVFTOXt3pgkli+54Bb6dE7mLgbquUKyi9LJMyJPsFqz1
         OLqxwZTnruj7L2kfVQKink75jupKANv9Ru8ndOX4=
Date:   Mon, 27 Jul 2020 17:21:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure double poll additions
 work with both request" failed to apply to 5.7-stable tree
Message-ID: <20200727152115.GA194978@kroah.com>
References: <159585645969173@kroah.com>
 <cb5acf7a-31b5-81c4-874b-366dba951f16@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb5acf7a-31b5-81c4-874b-366dba951f16@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 08:59:08AM -0600, Jens Axboe wrote:
> On 7/27/20 7:27 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here's the 5.7 variant:

Thanks, I'll queue it up for the next release after this one.

greg k-h
