Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DAC318ADB
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhBKMhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 07:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231618AbhBKMed (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 07:34:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EE2664E23;
        Thu, 11 Feb 2021 12:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613046831;
        bh=jNgALE8uQwqd1w0SVELtzGJ/GK+zIW88YxI2LssWh1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xV57KyRHEzTjRjGjbTxqD/8ZUZHsBujSuhbQwqx0fNd2VTxRtjuWRKV46OXES7oJc
         +MySRAu6ZZOMfV4un1nFsD9mF3FffjUjWw9kWkxA+w8lFF0VSn3QwDKy//Zp+Gz2Wb
         cjXgIHKKSKs18oAsUgvAzPXDuIF4CSWJgEZU3IaA=
Date:   Thu, 11 Feb 2021 13:33:48 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Raoni Fassina Firmino <raoni@linux.ibm.com>
Cc:     stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/64/signal: Fix regression in
 __kernel_sigtramp_rt64() semantics
Message-ID: <YCUkLNoZjlZEkbZF@kroah.com>
References: <20210209150240.epboynhzuaia4qyr@work-tp>
 <YCPtOTuh0kOk7Xee@kroah.com>
 <20210211112809.ao77vciijej5kdu7@work-tp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211112809.ao77vciijej5kdu7@work-tp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 08:28:09AM -0300, Raoni Fassina Firmino wrote:
> On Wed, Feb 10, 2021 at 03:27:05PM +0100, Greg KH wrote:
> > On Tue, Feb 09, 2021 at 12:02:40PM -0300, Raoni Fassina Firmino wrote:
> > > Repeated the same tests as the upstream code on top of v5.10.14 and
> > > v5.9.16, tested on powerpc64 and powerpc64le, with a glibc build and
> > > running the affected glibc's testcase[2], inspected that glibc's
> > > backtrace() now gives the correct result and gdb backtrace also keeps
> > > working as before.
> > > 
> > > I believe this should be backported to releases 5.9 and 5.10 as
> > > userspace is affected in this releases. I hope I had tagged this
> > > correctly in the patch.
> > 
> > Now added to 5.10.y, 5.9.y is long end-of-life so there is nothing we
> > can do there, sorry.
> 
> No problem, I didn't know 5.9.y was already EOL, that is on me.

Hint, in the future www.kernel.org shows you this :)
