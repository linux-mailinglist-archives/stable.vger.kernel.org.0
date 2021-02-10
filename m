Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC1F31691B
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhBJO1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231710AbhBJO1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:27:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 417EF64E0B;
        Wed, 10 Feb 2021 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612967227;
        bh=R6KnKC5AFJDqls2fhml6j2fw/BA3txg7oLng2Y8/TPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpuMik236BjdZVxALhJbyDR6AlFU+W4vfGOC2CDInoKR0pNP5t8noOq3zuo/UhBTf
         /4Nnd/XFJcpvvMVzXKrUGKojUHFst55R4e/iS2xX6+fnSk+JVcn1mUXWSkCeMK7IHm
         rIb4MD+nCyVDcd6Ajr1zJj1OrmYmHCIHDkRcACNg=
Date:   Wed, 10 Feb 2021 15:27:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Raoni Fassina Firmino <raoni@linux.ibm.com>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/64/signal: Fix regression in
 __kernel_sigtramp_rt64() semantics
Message-ID: <YCPtOTuh0kOk7Xee@kroah.com>
References: <20210209150240.epboynhzuaia4qyr@work-tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209150240.epboynhzuaia4qyr@work-tp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 12:02:40PM -0300, Raoni Fassina Firmino wrote:
> Repeated the same tests as the upstream code on top of v5.10.14 and
> v5.9.16, tested on powerpc64 and powerpc64le, with a glibc build and
> running the affected glibc's testcase[2], inspected that glibc's
> backtrace() now gives the correct result and gdb backtrace also keeps
> working as before.
> 
> I believe this should be backported to releases 5.9 and 5.10 as
> userspace is affected in this releases. I hope I had tagged this
> correctly in the patch.

Now added to 5.10.y, 5.9.y is long end-of-life so there is nothing we
can do there, sorry.

thanks for the backport,

greg k-h
