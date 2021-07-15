Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C193C9E13
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhGOMBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhGOMBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5566F61370;
        Thu, 15 Jul 2021 11:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350340;
        bh=6ZC/i+Q2hLmseNJtR/ELlJJ4FO0zsO4vwGZ/1XUQQig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1juoBTVb/jjKFRZy8Az5FMesIQnwLLNreozZPo83ZGJCxgGnyfZbKn/l1Rue5pJ5j
         fBHeT+QdRZ1iBJXgly1BEt6021uEOIclr7IUnNxkXxO+ludSV6PYRghWOGt4hBntJG
         d0hb5VVUl5wEG8kWwFBoJFvC8avsaxFLICG9atAI=
Date:   Thu, 15 Jul 2021 13:52:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     anatoly.trosinenko@gmail.com, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] fuse: reject internal errno" failed to
 apply to 4.19-stable tree
Message-ID: <YPAhaXQ9nYQ47QTI@kroah.com>
References: <1626009119113182@kroah.com>
 <CAOssrKeWW6P5d5-kk6GH_HV6QsinQpTDhXaCHzSFwtw4JXfvnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKeWW6P5d5-kk6GH_HV6QsinQpTDhXaCHzSFwtw4JXfvnw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 09:17:00AM +0200, Miklos Szeredi wrote:
> Hi Greg,
> 
> Please apply with --fuzz=3 (though I don't really see why this is
> needed, since there's just a single line of difference in the
> context).
> 
> Should work for backports to all previous versions.

Ok, that worked better, the context did not allow it to apply cleanly
as-is.

thanks,

greg k-h
