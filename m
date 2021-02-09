Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61E4314967
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBIHWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:22:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhBIHWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 02:22:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F271364DE8;
        Tue,  9 Feb 2021 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612855290;
        bh=GYNhKoo8XvDhtKgyS0Rl18AIWk3rmSlNFSv5B46tyhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WB4LIXaeEX9kZzXRvBxMx3DdNsReWe2+bMNgvhKfqH4DXTZ7tmL440UX88/qp59YT
         WYH20fU+Biwyv4xiGPZRT1Mgo5hT8ndfckgRwg5kuzYx6+e7ShhlW3O281psfGbmUb
         2pqe/jJmx7iJi021J2gkfcQDhgNrkHRpB6N3Kffc=
Date:   Tue, 9 Feb 2021 08:21:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Michael <fedora.dm0@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Reporting stable build failure from commit bca9ca
Message-ID: <YCI39srMrc8dmL+p@kroah.com>
References: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 04:14:44PM -0500, David Michael wrote:
> Hi,
> 
> Commit bca9ca[0] causes a build failure while building for a G4 system
> since 5.10.8:
> 
> arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
> arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org backwards
> make[2]: *** [scripts/Makefile.build:360:
> arch/powerpc/kernel/head_book3s_32.o] Error 1
> 
> Reverting the commit allows it to build.  I've uploaded the config[1],
> but let me know if you need other information.


Do you also have the same build failure in Linus's tree with this commit
in it?  And why not cc: the authors of the offending patch?

thanks,

greg k-h
