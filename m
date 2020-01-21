Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B241144081
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 16:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgAUP3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 10:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgAUP3s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 10:29:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F420B217F4;
        Tue, 21 Jan 2020 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579620587;
        bh=uQUXOBNCZU2vSOgHDd2x5m+OIJCoFaOVHWPIJeeq4bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kYHr9yiPHmyKyOq9cPrkjpNGT2GXeXlN8B51StEWcaW1ix/bMEEfpwDNN+VoZUIQL
         lBzao2tkbbcxktyjwI4AzPWFNXFo1PgBQCqrja48PuGksXPfUUncXUGk2XdVE1J6QU
         q6VD0IxkDgmNrwgwaFrT7QsFYIONxGaIVNT7kwpw=
Date:   Tue, 21 Jan 2020 16:29:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wolfgang Walter <linux@stwm.de>
Cc:     stable@vger.kernel.org
Subject: Re: Linux 5.4.13
Message-ID: <20200121152945.GB586917@kroah.com>
References: <20200117231105.GA2130102@kroah.com>
 <2465902.uHH96e9i0Q@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2465902.uHH96e9i0Q@stwm.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 20, 2020 at 06:49:46PM +0100, Wolfgang Walter wrote:
> Am Samstag, 18. Januar 2020, 00:11:05 schrieben Sie:
> > I'm announcing the release of the 5.4.13 kernel.
> > 
> > All users of the 5.4 kernel series must upgrade.
> > 
> > The updated 5.4.y git tree can be found at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> > linux-5.4.y and can be browsed at the normal kernel.org git web browser:
> > 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summar
> > y
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiling 5.4.13 I got (for one test configuration):
> 
> In file included from net/hsr/hsr_main.c:12:
> net/hsr/hsr_main.h:194:20: error: two or more data types in declaration 
> specifiers
>   194 | static inline void void hsr_debugfs_rename(struct net_device *dev)
>       |                    ^~~~
> make[3]: *** [scripts/Makefile.build:266: net/hsr/hsr_main.o] Error 1
> make[2]: *** [scripts/Makefile.build:509: net/hsr] Error 2
> make[1]: *** [Makefile:1652: net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> There seems to be already a patch:
> 
> 	https://lkml.org/lkml/2020/1/7/876
> 
> which is not in torvalds tree yet, though.
> 
> Just found it by accident, usually 	I do not use HSR.

When it hits Linus's tree, can you let us know the git commit id so we
can properly backport it?

thanks,

greg k-h
