Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88DE3D5482
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 09:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhGZHC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 03:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232146AbhGZHC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 03:02:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE2EE60F4C;
        Mon, 26 Jul 2021 07:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627285377;
        bh=X1P8+pobet+S34SD35lP6Li8uW4bhJ6VOh6Qpt1+xJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wwZgE0SHX0krrI0D0BsKQB2DQ0eGYrtnthCWnwZrh1nN3lm41itHys6pgwU59YHh9
         LKGPqhlaLCyj46xJ1pust8QQ2+hMYRHmSUf0CyHuK7O/yadUoQdFUzljqMpM7fnF9j
         nR5EmU5NcGn1MqEU0idgRvT00YYa5Oq/+D2KnyII=
Date:   Mon, 26 Jul 2021 09:42:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH io_uring backport to 5.13.y] io_uring: Fix race condition
 when sqp thread goes to sleep
Message-ID: <YP5nexpekGSGrjAM@kroah.com>
References: <82a82077d8b02166482df754b1abb7c3fbc3c560.1627189961.git.olivier@trillion01.com>
 <ca9be2ad-711e-51a3-9c5d-9472a1fad625@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca9be2ad-711e-51a3-9c5d-9472a1fad625@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 25, 2021 at 01:10:22PM -0600, Jens Axboe wrote:
> On 7/24/21 11:07 PM, Olivier Langlois wrote:
> > [ Upstream commit 997135017716 ("io_uring: Fix race condition when sqp thread goes to sleep") ]
> > 
> > If an asynchronous completion happens before the task is preparing
> > itself to wait and set its state to TASK_INTERRUPTIBLE, the completion
> > will not wake up the sqp thread.
> 
> Looks good to me - Greg, would you mind queueing this one up?
> 

Now queued up, thanks!

greg k-h
