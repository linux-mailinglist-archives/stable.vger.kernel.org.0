Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6E92BA534
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgKTIzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgKTIzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:55:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748D922253;
        Fri, 20 Nov 2020 08:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605862512;
        bh=dLT6qUiqwQ4+fzGUZpj1DN7x+1/BK5EnlKFTF9PoGAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XDk53m3NX5GuKaDPHJEK5uK91t0Iqq4OAfDUCHY0cLw3QrC9oi8Xeule4kLaHSBVm
         ftTWDYHsie+nihjXW3sV9Op8o6zIpvglDMn1OMQR5kFLkR05zOE9jJQ4o2msQucToe
         XMOZxfjEvkovWxxn+gMjHtoVfj45TWZBTahe4CME=
Date:   Fri, 20 Nov 2020 09:55:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Wen Xu <wen.xu@gatech.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: backports of afca6c5b2595 and ee457001ed6c for 4.4-stable
Message-ID: <X7eEmuTUE7LXc0zz@kroah.com>
References: <20201119202254.chd2av6h4baifgl6@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119202254.chd2av6h4baifgl6@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 08:22:54PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> These two were missing in 4.4-stable. Please add to your queue.

Good catch, now queued up, thanks.

greg k-h
