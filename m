Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4602E9350
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhADK27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbhADK27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:28:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD6920715;
        Mon,  4 Jan 2021 10:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609756098;
        bh=lMbzWsCGz1pxuG8mmCtrSboYxEaIhZkzmhKoTVrYfR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o7mcGI0gA4na/7UcKZ8w1Q5jaKagSZHgMAljBDlaz+kqop/x1V9LdUlDCjfF6RzZ3
         UEbVe7hNuhYr7rlhr/35yH8ZEu4SqaQ6szKbKVQy2pRehGgov0Y7WgEQ3oFBH+XSCQ
         KRLinNFt6osXDFFpYK6Ncy1ZoMRgeYYTzGlC0DSs=
Date:   Mon, 4 Jan 2021 11:29:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] tools headers UAPI: Sync linux/const.h with the
 kernel headers
Message-ID: <X/LuFMU3iVGuH82R@kroah.com>
References: <20210101202245.27409-1-petr.vorel@gmail.com>
 <20210101202245.27409-2-petr.vorel@gmail.com>
 <X++Fw3tSmvOOA1V2@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X++Fw3tSmvOOA1V2@pevik>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 01, 2021 at 09:27:47PM +0100, Petr Vorel wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> > commit 7ddcdea5b54492f54700f427f58690cf1e187e5e upstream.
> 
> > To pick up the changes in:
> 
> >   a85cbe6159ffc973 ("uapi: move constants from <linux/kernel.h> to <linux/const.h>")
> 
> > That causes no changes in tooling, just addresses this perf build
> > warning:
> 
> >   Warning: Kernel ABI header at 'tools/include/uapi/linux/const.h' differs from latest version at 'include/uapi/linux/const.h'
> >   diff -u tools/include/uapi/linux/const.h include/uapi/linux/const.h
> 
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Ian Rogers <irogers@google.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Petr Vorel <petr.vorel@gmail.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> > ---
> > Fix for previous commit.
> For stable/linux-5.4.y.

Both now queued up, thanks.

greg k-h
