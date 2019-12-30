Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A98012D415
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 20:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfL3TmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 14:42:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfL3TmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 14:42:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E808206DB;
        Mon, 30 Dec 2019 19:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577734927;
        bh=8pLArFFyzZXI+7pQHo+gGRjVZrDbaoBWS/yzNG4nnaE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=XzB20GQaCF32mm9p8jysYoVYjtAOz3Ij2cd9gpMfEUTiTvmJyuWYaj1TkGYZFEm6o
         m8FTu0lwlVj+uBDW5hMZwbc4CSgfDb9EUHq8bGprR+H/2sC7mWpLmSEOPW05cn1UBF
         sGdgxePqG1kKGiWIbtejGpElibk4ZlOta76jvSPM=
Date:   Mon, 30 Dec 2019 20:42:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230194204.GB1880685@kroah.com>
References: <20191229172702.393141737@linuxfoundation.org>
 <20191230163437.sz4mb5gh7ed2htfa@xps.therub.org>
 <20191230174522.GA1499079@kroah.com>
 <20191230180849.222x3hg2tnpwz7dn@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191230180849.222x3hg2tnpwz7dn@xps.therub.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 30, 2019 at 12:08:49PM -0600, Dan Rue wrote:
> On Mon, Dec 30, 2019 at 06:45:22PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Dec 30, 2019 at 10:34:37AM -0600, Dan Rue wrote:
> > > On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.7 release.
> > > > There are 434 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > Results from Linaro’s test farm.
> > > No regressions on arm64, arm, x86_64, and i386.
> > 
> > Thanks for testing all of these and letting me know.
> > 
> > But didn't you add perf build testing to your builds?  That should have
> > broken things, so I am guessing not :(
> 
> We do build (and run) perf, and it worked for us. Which patch was the
> problem? I can go look at why our config didn't hit the offending
> code/build path.

See the thread from Guenter and from others on the perf patches
themselves in this release for the details.

thanks,

greg k-h
