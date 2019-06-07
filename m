Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12509391BA
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfFGQQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 12:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbfFGQQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 12:16:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D80402089E;
        Fri,  7 Jun 2019 16:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559924190;
        bh=/F/c4QDEf06P5tEgw0z3DOKfB8bwE9ii6Uy2T7OVa1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ktxl9FKXcbeyfqXJgD2WhYz7AYCKu2YE/ZrTBU7NlJJJjMDemtaHGeDSfDHWqS8C7
         TNuGQCmwwSLUGcEIk4saTherUSRQf2+s07Zd2dgFC6Kb7FOTVAE6juvZpKDu+F+wj4
         PU/jFK1TUWVK6EtMEcNb3Fuk9Az/NwS5hefdlSTI=
Date:   Fri, 7 Jun 2019 18:16:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/69] 4.14.124-stable review
Message-ID: <20190607161627.GA9920@kroah.com>
References: <20190607153848.271562617@linuxfoundation.org>
 <20190607161102.GA19615@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607161102.GA19615@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 09:11:02AM -0700, Guenter Roeck wrote:
> On Fri, Jun 07, 2019 at 05:38:41PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.124 release.
> > There are 69 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 09 Jun 2019 03:37:08 PM UTC.
> > Anything received after that time might be too late.
> >
> 
> fs/btrfs/inode.c: In function 'btrfs_add_link':
> fs/btrfs/inode.c:6590:27: error: invalid initializer
>    struct timespec64 now = current_time(&parent_inode->vfs_inode);
>                            ^~~~~~~~~~~~
> fs/btrfs/inode.c:6592:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
>    parent_inode->vfs_inode.i_mtime = now;
>                                    ^
> fs/btrfs/inode.c:6593:35: error: incompatible types when assigning to type 'struct timespec' from type 'struct timespec64'
>    parent_inode->vfs_inode.i_ctime = now;
>                                    ^

What arch?  This builds for me here.  odd...

greg k-h
