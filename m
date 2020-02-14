Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3C15D1FA
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 07:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgBNGVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 01:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgBNGVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 01:21:07 -0500
Received: from localhost (unknown [12.177.140.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C866217F4;
        Fri, 14 Feb 2020 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581661267;
        bh=788UuF58Xs9gRGfBYj6bZ2voXqopWQZh8sEqvich4dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S50dAmn+5k0luGC9trXSY1+8e28VQrfMBfEVpjXUikTynqawmchnrv/VK2aEzSJfu
         gW4hEicLv2EXJ5/HyCoy+F5XGCG7B9uvoPZOMoXNMcc4wNvy/rY5O7C4E/TBK6BYia
         50bdGoWJU8isXczlwspdmt7fks6YYSj/zJlzvQPU=
Date:   Thu, 13 Feb 2020 22:21:06 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
Message-ID: <20200214062106.GA3928737@kroah.com>
References: <20200213151931.677980430@linuxfoundation.org>
 <20200214022146.GA4866@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214022146.GA4866@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 06:21:46PM -0800, Guenter Roeck wrote:
> On Thu, Feb 13, 2020 at 07:18:23AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.171 release.
> > There are 173 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Commit 833e09807c49 ("serial: uartps: Add a timeout to the tx empty wait")
> breaks all xilinx boot tests, here and in v4.19.y. Reverting it fixes the
> problem. that is maybe not entirely surprising, given that there were
> some 40 other commits into the same file since v4.14.

Ah, I added the fixup patch (Pavel pointed it out), but didn't push out
a -rc2 with it in it.  I'll go do that now.

> FWIW, I still think that way too many patches are being backported.

All of the patches I have been added are there either because they were
asked to be there due to the cc: stable tag, or a developer asked, or
there was a "Fixes:" tag that referenced a commit in that tree.

Yes, it looks like a lot, but people are finally getting better at
tagging their stuff, which is why we are finally getting more fixes in
the tree.  We were riding for the past 15 years before now with way too
little fixes being applied.

And this is also what testing is for, be it 1 or 200 patches a release,
they should all be able to pass testing to make us feel better that they
are "safe".  The quantity does not matter for that.

thanks,

greg k-h
