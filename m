Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7499732F0
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbfGXPkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfGXPkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 11:40:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E5EE206B8;
        Wed, 24 Jul 2019 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563982810;
        bh=1ugpj2cDMT4LouxJwPEh3vVev4JOTmGdyzokTnqYusk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/R6w3WO1nkn9185iFQVPIu47pK5tQEVId66GPEaejTV2sX7SRONSUNwobzBEB+BE
         VvGLsSnS7L9r1mF6+Zd32tdtoSE0Lq0rLzRK2/WuouhE+7D/WwwZ/lWFJ1LgWWn9MB
         Yrn/2Tkiu1DR3mn6tzWF8XXC5VjJGhgUhgoDPqHU=
Date:   Wed, 24 Jul 2019 17:40:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: btrfs related build failures in stable queues
Message-ID: <20190724154008.GA3050@kroah.com>
References: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d32a9740-c5cf-8c91-fd39-ba8f0499541d@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 08:07:50AM -0700, Guenter Roeck wrote:
> v4.9.y to v5.1.y:
> 
> fs/btrfs/file.c: In function 'btrfs_punch_hole':
> fs/btrfs/file.c:2787:27: error: invalid initializer
>    struct timespec64 now = current_time(inode);
>                            ^~~~~~~~~~~~
> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'

This was reported, only seems to show up on arm64, right?

> v4.19.y, v5.1.y:
> 
> fs/btrfs/props.c: In function 'prop_compression_validate':
> fs/btrfs/props.c:369:6: error: implicit declaration of function 'btrfs_compression_is_valid_type'
> 
> My apologies for the noise if this has already been reported/fixed.

Odd, I thought I fixed that, maybe I need to push out an updated git
tree, sorry about that.

greg k-h
