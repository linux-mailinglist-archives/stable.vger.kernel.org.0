Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F01362E94
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 10:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhDQIkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 04:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhDQIkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Apr 2021 04:40:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D9AF61007;
        Sat, 17 Apr 2021 08:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618648817;
        bh=MZpm1e0oUW6USsAyZ0mf1APVCyK3fJEOWX9uCb6poD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DtsFPx4YMEvtVrxmBt6y6zbhAlY48jCMDkjT7Ftnr3aEmDbwLXOxvr2jQK2fw5g/E
         MonTJcWYX7TyG0NGr+K6BMfp59JrYVzxZayX7w/Lo1CX4FOjJFRDXrcAFaQvKwdo5U
         T9/XJRTi2MXH74KnKnk+V6syy2S27A8UIDwYNztQ=
Date:   Sat, 17 Apr 2021 10:40:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Steve Beattie <steve.beattie@canonical.com>
Subject: Re: Please apply commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap()
 call into vfs_setxattr()") to stable series from 5.10.y back to 4.19.y
Message-ID: <YHqe7sN2OfpNZkrS@kroah.com>
References: <YHnr2D9UO+pQO6uq@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHnr2D9UO+pQO6uq@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 09:56:08PM +0200, Salvatore Bonaccorso wrote:
> Hi Greg, hi Sasha
> 
> Please consider to apply commit 7c03e2cda4a5 ("vfs: move
> cap_convert_nscap() call into vfs_setxattr()") to stable series at
> least back to 4.19.y. It applies to there (but have not tested older
> series) and could test a build on top of 5.10.y with the commit.
> 
> The commit was applied in 5.11-rc1 and from the commit message:
> 
>     vfs: move cap_convert_nscap() call into vfs_setxattr()
> 
>     cap_convert_nscap() does permission checking as well as conversion of the
>     xattr value conditionally based on fs's user-ns.
> 
>     This is needed by overlayfs and probably other layered fs (ecryptfs) and is
>     what vfs_foo() is supposed to do anyway.

Does this actually solve an in-kernel problem, or is only an issue for
out-of-tree filesystems?

> Additionally, in fact additionally for distribtuions kernels which do
> allow unprivileged overlayfs mounts this as as well broader
> consequences, as explained in
> https://www.openwall.com/lists/oss-security/2021/04/16/1 .

That's an out-of-tree issue from what I can tell, what in-kernel issue
does the above commit resolve?  Or am I reading that report incorrectly?

thanks,

greg k-h
