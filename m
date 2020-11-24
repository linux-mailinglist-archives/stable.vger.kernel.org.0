Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156D12C2D53
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 17:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731540AbgKXQuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 11:50:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbgKXQuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 11:50:55 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2FA5206D8;
        Tue, 24 Nov 2020 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606236653;
        bh=RpSMeT8lAld3kCRRKNL/SVKeYyECnwZ8HTXcvKgJogc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kdPY7EPVVWGAJASen/4PG3vXeci5sc4povnjfnGssOih3Bp3MJGyeCQbU3mb2U4SR
         TSRUi1SDkKi9NhVbi15sUxKm3QrKfLR2GfPqmDcKABIMzcjzMIloBrQMNO5rH5yvTH
         8sSbCa4myLUhK+mvY9w09JCvW5zARo4YMUDuCrNM=
Date:   Tue, 24 Nov 2020 17:50:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2][5.9 backport] io_uring: get an active ref_node from
 files_data
Message-ID: <X7056rhshylAXgPW@kroah.com>
References: <075a6b4e7a9235d13b08b1f13f461846fbb97673.1606170275.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <075a6b4e7a9235d13b08b1f13f461846fbb97673.1606170275.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 10:34:06PM +0000, Pavel Begunkov wrote:
> commit 1e5d770bb8a23dd01e28e92f4fb0b1093c8bdbe6 upstream
> 
> An active ref_node always can be found in ctx->files_data, it's much
> safer to get it this way instead of poking into files_data->ref_list.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Cc: stable@vger.kernel.org # v5.7+
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Both patches now queued up, thanks.

greg k-h
