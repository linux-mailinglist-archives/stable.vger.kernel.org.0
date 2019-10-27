Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E0AE6167
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 08:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfJ0HW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 03:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfJ0HW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 03:22:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F072064A;
        Sun, 27 Oct 2019 07:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572160977;
        bh=BcXiuHY7nyQodAdix7GUzQVSdlJ5goDJC4RIsOp32Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tlLwywoW8ZRjpY+5qHAht95kVe9eRwYJHXNkNmIYqwYyydULZk35JsAeqB4hvSO9u
         9qRr1hZNGp+2dAQRn/eM666/un4PtRn3QxjOAqd048BexQRm9OOtjkKrJxjtcCDLOx
         rhZRI+CY4qxRhW6IoMS18SsAm/+MOEi0U+IzAGsM=
Date:   Sun, 27 Oct 2019 08:22:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: io_uring stable 5.3 backports
Message-ID: <20191027072254.GB1755924@kroah.com>
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
> Hi,
> 
> For some reason I forgot to mark these stable, but they should go
> into stable. In order of applying them, they are:
> 
> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
> ef03681ae8df770745978148a7fb84796ae99cba
> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
> 84d55dc5b9e57b513a702fbc358e1b5489651590
> fb5ccc98782f654778cb8d96ba8a998304f9a51f
> 935d1e45908afb8853c497f2c2bbbb685dec51dc
> 498ccd9eda49117c34e0041563d0da6ac40e52b8
> 2b2ed9750fc9d040b9f6d076afcef6f00b6f1f7c

Only 2 of these patches applied to the 5.3 stable tree, are you sure you
want these all there?  If so, can you provide a backport of them all?

I already did queue up these two:
	2b2ed9750fc9 ("io_uring: fix bad inflight accounting for SETUP_IOPOLL|SETUP_SQTHREAD")
	84d55dc5b9e5 ("io_uring: Fix corrupted user_data")

thanks,

greg k-h
