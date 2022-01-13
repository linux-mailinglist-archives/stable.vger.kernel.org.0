Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D249B48DD4C
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 18:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiAMR5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 12:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiAMR5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 12:57:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2270EC061574;
        Thu, 13 Jan 2022 09:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7FA9B82309;
        Thu, 13 Jan 2022 17:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011A9C36AE9;
        Thu, 13 Jan 2022 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642096664;
        bh=98ANPILxkIqb0sUQnnulBR26sYnHM2UKoblU9xxt6rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qhu5kgxOsOcRKGDAdn51EYSqhwJJXtMZUV9DIekHurwB/kwtds0YStgPYQwar+SWv
         FbYWKnd0tSYKXYvlw5jy0o2DDpGnbc3hg23hAwGojfj0CWzipBoZEYUpoiSuLKMYdl
         QwgH596wRhDB/7DEl6MdPVrDxYnQJxYZ0LARvdRU=
Date:   Thu, 13 Jan 2022 18:57:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "x86/mce: Remove noinstr annotation from mce_setup()" has
 been added to the 5.15-stable tree
Message-ID: <YeBoFTNOcFNWEp3/@kroah.com>
References: <164207874020173@kroah.com>
 <YeAnLb7OkkmTWtf/@zn.tnic>
 <YeA31erBrPKu755G@kroah.com>
 <YeBH0Pui5SD0Tf3T@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeBH0Pui5SD0Tf3T@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 04:40:00PM +0100, Borislav Petkov wrote:
> On Thu, Jan 13, 2022 at 03:31:49PM +0100, Greg KH wrote:
> > Any hints on how to get rid of this?  More patches in the series this
> > one came from?
> 
> Unfortunately, a whole series:
> 
> https://lore.kernel.org/r/20211208111343.8130-1-bp@alien8.de
> 
> and the 0day bot guys recently managed to trigger another warning there,
> which means even more fixes, even to generic code.
> 
> So what that warning tells you is that you call into instrumentable
> context from non-instrumentable one. But that has relevance only when
> someone traces the MCE code - and up until now I haven't received a
> single sensible use case for why that would make any sense.
> 
> So long story short, you can safely ignore it and if someone complains,
> ask her/him about the use case first and CC me.
> 
> :-)

Ok, will just ignore it, 5.16.y should only be alive for a few months
(4?) so it's not that big of a deal, I was just trying to ensure
0-warning builds were happening as it's easier to notice when I mess
something up with the stable releases.

I'll go drop this commit now, thanks.

greg k-h
