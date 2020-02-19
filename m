Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D275164DFE
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBSSwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSSwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 13:52:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B36D2064C;
        Wed, 19 Feb 2020 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582138359;
        bh=owwPLCIXW01JCabPd8oJy4g6ge27ISgAiv8nVu3IKf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0HKNPJL+9nl6VtNmfRoqfyNHJ5j44MtPiZVzaJ6c67p5IzGO7/nDEKZ5raGnObN3
         oxkbyVOp4P4lAflAlwGFcGiY8joZRPGYXFnK+Qi7RHpf82ANCide/XSfIiisHxYbl/
         tlZ8Xo3zbeCtOpUv95T6gAr7bR5lZPCeNHgpiZuE=
Date:   Wed, 19 Feb 2020 19:52:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
Message-ID: <20200219185237.GD2857377@kroah.com>
References: <20200218190432.043414522@linuxfoundation.org>
 <20200219180954.GC26169@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219180954.GC26169@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 10:09:54AM -0800, Guenter Roeck wrote:
> On Tue, Feb 18, 2020 at 08:54:21PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.5 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 412 pass: 412 fail: 0

Great, thanks for testing all of them and letting me know.

greg k-h
