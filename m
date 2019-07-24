Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4724172838
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 08:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfGXG3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 02:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfGXG3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 02:29:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98AF1218DA;
        Wed, 24 Jul 2019 06:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563949749;
        bh=X3nxKCNfdD0lLhL4VaMbjI82mxOi5YsL2BdBUB7PXfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ia/h8K9bQmR91vtH03cL9qwrjaUYgV6tHF/jXmZTRsM310/Qu4K2coGuxtCifgUvk
         eIW51YSyh45RSNp6n/TLMvaqR4ZHqq5isjGGWb4jjeix6aKGY8HnjlZrc5oOp4QN96
         ZfLgZaUz9VWmzJTA/J8AMfEMjenuM8eLGZP9v5tE=
Date:   Wed, 24 Jul 2019 08:29:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>, dsterba@suse.com,
        nborisov@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: correctly validate compression
 type" failed to apply to 5.1-stable tree
Message-ID: <20190724062906.GA19622@kroah.com>
References: <156388330112473@kroah.com>
 <20190723121955.GE3997@x250.microfocus.com>
 <20190723122817.GB11835@kroah.com>
 <7b2be0ce-1dbf-3579-0d6c-764c6c6da7fe@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b2be0ce-1dbf-3579-0d6c-764c6c6da7fe@mageia.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 01:31:46AM +0300, Thomas Backlund wrote:
> Den 23-07-2019 kl. 15:28, skrev Greg KH:
> > On Tue, Jul 23, 2019 at 02:19:55PM +0200, Johannes Thumshirn wrote:
> > > Hi Greg,
> > > 
> > > please try the following:
> > > 
> > > >From 9afa2d46ecb511259130eb51b4ab1feb1055d961 Mon Sep 17 00:00:00 2001
> > > From: Johannes Thumshirn <jthumshirn@suse.de>
> > > Date: Thu, 6 Jun 2019 12:07:15 +0200
> > > Subject: [PATCH] btrfs: correctly validate compression type
> > > 
> > > (commit aa53e3bfac7205fb3a8815ac1c937fd6ed01b41e upstream)
> > 
> > Worked for 5.1.y and 4.19.y, but not for the older ones.
> > 
> 
> It applies to 5.1 but it does not build:
> 
> + /usr/bin/make -O -j12 ARCH=x86_64 -s all
> fs/btrfs/props.c: In function 'prop_compression_validate':
> fs/btrfs/props.c:369:6: error: implicit declaration of function
> 'btrfs_compression_is_valid_type'; did you mean
> 'btrfs_compress_is_valid_type'? [-Werror=implicit-function-declaration]
>   if (btrfs_compression_is_valid_type(value, len))
>       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       btrfs_compress_is_valid_type
> cc1: some warnings being treated as errors

Yes, now dropped from 5.1 and 4.19 trees.

thanks,

greg k-h
