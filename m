Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B206732439B
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhBXSMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhBXSLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:11:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2874A64ED1;
        Wed, 24 Feb 2021 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614190267;
        bh=/y1jTGhn5BMe7+HHv1qmGWsMV0+GZI6cIlBmZBK/53M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XemYnIFqaMVyEGp18mV/OtxC+ovx7ADu833lcp6el1XLh99/uBhtNp2hyxilVMuHP
         NMl3h5pr+HXZMcRXaoqD5PdIfK0KmLv73EqR40hZK3QahX8bMnX1UqR3MDL2tUEL+B
         MToC2sr7u8zO6lmmh9d8CyFAvm3F4LNqY4zXi7hU=
Date:   Wed, 24 Feb 2021 19:11:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Frank Schilder <frans@dtu.dk>
Subject: Re: ceph: downgrade warning from mdsmap decode to debug
Message-ID: <YDaWuRYHA3j8eJ5N@kroah.com>
References: <d461df79aac53a77de3ebae08543c5ca9c6660cb.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d461df79aac53a77de3ebae08543c5ca9c6660cb.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 11:32:47AM -0500, Jeff Layton wrote:
> Hi, we'd like to request that you pull this commit into stable kernels. 
> It's a trivial patch that just downgrades a (harmless) kernel warning
> message to debug level. The warning can be very chatty in some
> situations, and it'd be nice to silence it.
> 
> -----------------------------8<-------------------------------
> 
> commit ccd1acdf1c49b835504b235461fd24e2ed826764
> Author: Luis Henriques <lhenriques@suse.de>
> Date:   Thu Nov 12 11:25:32 2020 +0000
> 
>     ceph: downgrade warning from mdsmap decode to debug
>     
>     While the MDS cluster is unstable and changing state the client may get
>     mdsmap updates that will trigger warnings:
>     
>       [144692.478400] ceph: mdsmap_decode got incorrect state(up:standby-replay)
>       [144697.489552] ceph: mdsmap_decode got incorrect state(up:standby-replay)
>       [144697.489580] ceph: mdsmap_decode got incorrect state(up:standby-replay)
>     
>     This patch downgrades these warnings to debug, as they may flood the logs
>     if the cluster is unstable for a while.
>     
>     Signed-off-by: Luis Henriques <lhenriques@suse.de>
>     Reviewed-by: Jeff Layton <jlayton@kernel.org>
>     Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> 
> 

Queued up to 5.10.y as that was the only place it would apply to.  If
you want it in other kernel tree(s), please let me know.

thanks,

greg k-h
