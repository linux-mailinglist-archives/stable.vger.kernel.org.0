Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E48510340F
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfKTGA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 01:00:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfKTGA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 01:00:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14DC1205C9;
        Wed, 20 Nov 2019 06:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574229628;
        bh=2d2oFiuKLFEOGBdFCBRI/uZU667a1Rtk1tIk3n6mnA0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Ww+AOqAIAnCQ6uE+LJNysbs2r/nNtvVcy4t2Ljs03cQE19q+ieNpM7zefeNyIxmsS
         5VnuMk8fnQuH7FeXLAy7Jus8i8NteXUQmixBteOhVOGHBv/FzCid5meebpaJHTKTJ1
         MLjvp5oyLSGl1ZHq1+z0VQmYWEAHs0pYFFdozfzo=
Date:   Wed, 20 Nov 2019 07:00:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
Message-ID: <20191120060025.GC2853442@kroah.com>
References: <20191119050946.745015350@linuxfoundation.org>
 <20191119184524.v7b5mkopvv2zunpc@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191119184524.v7b5mkopvv2zunpc@xps.therub.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 12:45:24PM -0600, Dan Rue wrote:
> On Tue, Nov 19, 2019 at 06:19:20AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.12 release.
> > There are 48 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all 3 of these and letting me know.

greg k-h
