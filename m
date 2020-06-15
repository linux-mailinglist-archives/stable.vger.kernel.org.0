Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD61FA157
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgFOUVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730995AbgFOUVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:21:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96E892074D;
        Mon, 15 Jun 2020 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592252462;
        bh=ZHzqOyPZgyQtRrzhN3yGvrB4wrOElA05Gb0sW+MnX04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xncANb0CfueEv/vLhc/beFfkwNR1I94L2TJ9iAb7eFVnAg/jfmZ0D+cieERe/+kzB
         5f/rpLqxzxMHxF6UHIsZp869EFz3Y83eEm82ZNtjIIIONacBVAGyybHEfBHJx9QJmf
         k78DBlQa8Y0pvD1UsVMseD2YKkpJVFK5lgW4cO4w=
Date:   Mon, 15 Jun 2020 22:20:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] io_uring: fix flush req->refs underflow"
 failed to apply to 5.6-stable tree
Message-ID: <20200615202057.GA437074@kroah.com>
References: <159222954019964@kroah.com>
 <a4ac1fdd-576c-9cff-bc54-4d090f2bad2c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4ac1fdd-576c-9cff-bc54-4d090f2bad2c@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 09:18:29AM -0600, Jens Axboe wrote:
> On 6/15/20 7:59 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Greg, if you could cherry pick this one:
> 
> commit d8f1b9716cfd1a1f74c0fedad40c5f65a25aa208
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Sun Apr 26 15:54:43 2020 +0800
> 
>     io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()
> 
> first (which should also go into stable), the below will apply without
> conflicts after that.

That worked great, thanks!

greg k-h
