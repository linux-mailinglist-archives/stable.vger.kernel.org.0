Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7138B79379
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfG2S6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbfG2S6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 14:58:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A754206DD;
        Mon, 29 Jul 2019 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564426692;
        bh=zgKfBWrlVs0BWqbWq453nBIBZ8evDtpioWPOioqCcy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/c5i4VTnvuIr0oyNRodMJY0H5NblFqcIy9tgxlfElBzxFWX7ik7s26SxFXpCRM2r
         zeSjNrbIbeBf4izETKWN6tMYjG0cBbPXG+ZQHVQivbT3pqTWJo+ixLUvAE7NNGNwfM
         d4U9Mxw/0YsRXZkQlkcuaTtGdPZ+r0+Qatq1UY8o=
Date:   Mon, 29 Jul 2019 20:58:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: fs/io_uring.c stable additions
Message-ID: <20190729185808.GA25051@kroah.com>
References: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
 <20190729181528.GA25613@kroah.com>
 <abd31004-9c2f-ffa9-10b3-77ed4427d411@kernel.dk>
 <93699ab7-35b2-338a-967d-bf0b432e8abf@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93699ab7-35b2-338a-967d-bf0b432e8abf@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 12:35:14PM -0600, Jens Axboe wrote:
> On 7/29/19 12:17 PM, Jens Axboe wrote:
> > On 7/29/19 12:15 PM, Greg Kroah-Hartman wrote:
> > > On Mon, Jul 29, 2019 at 12:08:28PM -0600, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > I forgot to mark a few patches for io_uring as stable. In order
> > > > of how to apply, can you add the following commits for 5.2?
> > > > 
> > > > f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4
> > > 0ef67e605d2b1e8300d04fd9134d283bbbf441b9
> > > Does not apply :(
> > > 
> > > > c0e48f9dea9129aa11bec3ed13803bcc26e96e49
> > > 
> > > Now queued up.
> > > 
> > > > bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49
> > > 
> > > Does not apply :(
> > > 
> > > > 36703247d5f52a679df9da51192b6950fe81689f
> > > 
> > > Now queued up.
> > > 
> > > You are 2 out of 4 :)
> > > 
> > > Care to send backported versions of the 2 that did not apply?  I'll be
> > > glad to queue them up then.
> > 
> > Huh strange, I applied them to our internal 5.2 tree without conflict.
> > Maybe I had backported more...
> > 
> > I'll send versions for 5.2 in a bit for you.
> 
> Here you go, those two on top of the others. Ran it through the
> regressions tests here, works for me.

That worked, all now queued up, thanks!

greg k-h
