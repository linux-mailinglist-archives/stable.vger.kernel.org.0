Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458CD180B0
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 21:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfEHTwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 15:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbfEHTwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 15:52:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0611F214AF;
        Wed,  8 May 2019 19:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557345156;
        bh=EtV0GppDsx6A7wMUfgUybNBag75yT8pxR0enu+LrYO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bEiFOQVWOixaOLfDaVIDPX1vHBSGu2u68cjK06cJUnjRVbpexNQYZz59diTRuwnoF
         KewR5+N39Zavf+6UffG1D7Zjc4sUW6Z/L4LJYvX1hmxFgLh4WY56brhmDsk5bis8id
         gBF8RBM1YW/Tsz8LAiFaQrZA3OfWn6TDMoPUgFpU=
Date:   Wed, 8 May 2019 18:49:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4pyFIFBBU1M=?= =?utf-8?Q?=3A?= Stable queue: queue-5.0
Message-ID: <20190508164957.GA6157@kroah.com>
References: <cki.A78709C14B.5852BV39BE@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.A78709C14B.5852BV39BE@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 11:54:19AM -0400, CKI Project wrote:
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 274ede3e1a5f - Linux 5.0.14

Meta-comment, are you all going to move to the "latest" stable queue
now that 5.1 is out?  Or are you stuck at 5.0?  5.0 is only going to be
around for a few more weeks at most.

And, any plans on doing this for 4.19 or other older LTS kernels that
are going to be sticking around for many years?

thanks,

greg k-h
