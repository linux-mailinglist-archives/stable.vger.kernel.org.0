Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650620EE30
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 08:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgF3GSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 02:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgF3GSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 02:18:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B9B206B6;
        Tue, 30 Jun 2020 06:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593497923;
        bh=Yt4ewVkej87QMDDe3/vDgX671ohqgd3bSxftoaGRj5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yOqbN5qY+9/+GVH769AAVlsUkBte0tuVUZprS2S+9TQLGlU2sqTwLNH1uEa+ykzEq
         uBge6TAiYxjs7dy4tAnNiWsaRtn7fLy9T5RfSc05cFV4zsyuZnzkOZTN/edpHpBSwg
         zz8OHotDX4vA1P1oW/wiHPaBRYYXKcAUub7OLC9I=
Date:   Tue, 30 Jun 2020 08:18:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] dm zoned: assign max_io_len correctly
Message-ID: <20200630061840.GC616711@kroah.com>
References: <20200630040047.231197-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630040047.231197-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 30, 2020 at 01:00:47PM +0900, Damien Le Moal wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> commit 7b2377486767503d47265e4d487a63c651f6b55d upstream.
> 
> The unit of max_io_len is sector instead of byte (spotted through
> code review), so fix it.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-zoned-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What stable tree(s) is this for?
