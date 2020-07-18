Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD822492C
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 08:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgGRGLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 02:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgGRGLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jul 2020 02:11:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFAB62064B;
        Sat, 18 Jul 2020 06:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595052694;
        bh=GMf2rTKnWsPwuMHtJiOnUaeZHGZ4hpYp+1vHRST167g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jbzhlWXC/fA2FIZ+Ta0eZCVLX68vk2RGTuZHZTsbgHwqHA3CBxIRXhMXgDJfPe0Hv
         n1K83WmOZWpk8yMzuHhSmh9sRaVICeeT8KIx931/zmSyUk0jd2R3p4rHN2gguqXwJd
         0SOwa9kxycKGtJJmfgdCk+yek63v188fcSpOaMY0=
Date:   Sat, 18 Jul 2020 08:11:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Stable inclusion request
Message-ID: <20200718061125.GA3437964@kroah.com>
References: <bd2a28c0-ee8c-3be9-58f1-a52cc935bb86@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd2a28c0-ee8c-3be9-58f1-a52cc935bb86@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 17, 2020 at 12:09:58PM -0600, Jens Axboe wrote:
> Hi,
> 
> I forgot to mark this one with stable, can you please cherry-pick it
> for 5.7-stable? It picks cleanly. Thanks!
> 
> commit 681fda8d27a66f7e65ff7f2d200d7635e64a8d05
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Jul 15 22:20:45 2020 +0300
> 
>     io_uring: fix recvmsg memory leak with buffer selection

Now queued up, thanks!

greg k-h
