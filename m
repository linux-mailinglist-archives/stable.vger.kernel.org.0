Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F9792E4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 20:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbfG2SPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 14:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfG2SPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 14:15:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0382206DD;
        Mon, 29 Jul 2019 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564424131;
        bh=XD/svAglHpuigJf60aUmiT+Vak6Bskovd4W8KJJSiUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFXeN7vmLpABH7jBo9TFTyR/EcT2Otxy9xd/h1yJgAvvto46Ytcud7pXn/DFal9bk
         qPK0wEna0P1Y1pFfCw3HjoWEsCgvMrgaPByqgS5jTl0kuamf86qMiJ4eTUtEjvOa1n
         yOMs7BIUmihDNL4McqeC2eaSm3kAKQm4dnCy4NOw=
Date:   Mon, 29 Jul 2019 20:15:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: fs/io_uring.c stable additions
Message-ID: <20190729181528.GA25613@kroah.com>
References: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 12:08:28PM -0600, Jens Axboe wrote:
> Hi,
> 
> I forgot to mark a few patches for io_uring as stable. In order
> of how to apply, can you add the following commits for 5.2?
> 
> f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4

Does not apply :(

> c0e48f9dea9129aa11bec3ed13803bcc26e96e49

Now queued up.

> bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49

Does not apply :(

> 36703247d5f52a679df9da51192b6950fe81689f

Now queued up.

You are 2 out of 4 :)

Care to send backported versions of the 2 that did not apply?  I'll be
glad to queue them up then.

thanks,

greg k-h
