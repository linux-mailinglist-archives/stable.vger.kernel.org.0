Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8038B3CBB
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 16:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfIPOko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 10:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfIPOkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 10:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC162067D;
        Mon, 16 Sep 2019 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568644843;
        bh=cZ42179XruIcWhh0vD4VAro6B1DZApPtlTMx7XJIIK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MhIqQimYxCOykYfle920w2XCLslbTxmpGZTPsgcM9jgF19PekY/Zd2giZC3ogE5jF
         8QvjjQzpQQ/97CyMqu25Qi5uAffGd/NWcjaev/ZTuYPNrIsz7CuWH8MOiweeFeIupD
         +2xFu3/HtCP3taS9TsomEoKKy9Tyd/eWYDPezWB8=
Date:   Mon, 16 Sep 2019 16:40:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     stable@vger.kernel.org,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH for-4.14 0/2] btrfs compression type validation fix
Message-ID: <20190916144040.GA1595490@kroah.com>
References: <20190916081726.7983-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916081726.7983-1-jthumshirn@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 10:17:24AM +0200, Johannes Thumshirn wrote:
> Hi Greg,
> 
> Here's the backport of aa53e3bfac72 ("btrfs: correctly validate compression
> type") for v4.14 with it's prerequisite e128f9c3f724 ("btrfs: compression:
> add helper for type to string conversion").
> 
> David Sterba (1):
>   btrfs: compression: add helper for type to string conversion
> 
> Johannes Thumshirn (1):
>   btrfs: correctly validate compression type
> 
>  fs/btrfs/compression.c | 31 +++++++++++++++++++++++++++++++
>  fs/btrfs/compression.h |  3 +++
>  fs/btrfs/props.c       |  6 +-----
>  3 files changed, 35 insertions(+), 5 deletions(-)

Thanks for the backports, now queued up.

greg k-h
