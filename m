Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A579B1C2677
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 17:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgEBPO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 11:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbgEBPO1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 11:14:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B9CE206F0;
        Sat,  2 May 2020 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588432466;
        bh=kY6U6j7JZf4k6CBHBVmyiHSPDIw9/bhJCuLYfRZaiSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wj+aArUVsNYsgBblqXBjm3x9ZpaF8AieTNcqDNA7WNgvXjxISJ2tx3beTZwD4X0ec
         pTHPs3yV/elxhkALeh1154BBQi/ihFrrTzPWpeY2DjCJ3VIgZYcwuyCqxx20EziSpN
         bnw7BfEIAnENLaNBAM88IKSIaGzW3ebVD+s34KUU=
Date:   Sat, 2 May 2020 17:14:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/47] 4.19.120-rc2 review
Message-ID: <20200502151422.GA94986@kroah.com>
References: <20200502064235.767298413@linuxfoundation.org>
 <20200502145646.GD189389@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502145646.GD189389@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 07:56:46AM -0700, Guenter Roeck wrote:
> On Sat, May 02, 2020 at 08:48:14AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.120 release.
> > There are 47 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 418 pass: 418 fail: 0

Wonderful, thanks for re-testing all of these and letting me know.

greg k-h
