Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3422807A5
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgJATWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATWw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:22:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB41420759;
        Thu,  1 Oct 2020 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580171;
        bh=j1kHHCrL5PW6IVyov96NqvEu+Wa0oTvtIfRLDW3pCyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GV5ZpAP2Qr82GNAgwYedIWcVy56UWaAl8/Lowp5u2X1kF2cFG174TjzROYnOw1Qpl
         s12i6l29v9l3YzjgxqF+8vyOCBVWItG1ATDHgvXHwD2egfNE4FIEskkQ08+XODADzb
         ew8eK4N48rDbJmYSG6h8W7xb0q19p8xAmG/rI1Vo=
Date:   Thu, 1 Oct 2020 21:22:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/119] 4.9.238-rc2 review
Message-ID: <20201001192251.GA3873962@kroah.com>
References: <20201001091034.685078175@linuxfoundation.org>
 <20201001151141.GB64648@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001151141.GB64648@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 01, 2020 at 08:11:41AM -0700, Guenter Roeck wrote:
> On Thu, Oct 01, 2020 at 11:11:05AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.238 release.
> > There are 119 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 03 Oct 2020 09:10:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 168 fail: 0
> Qemu test results:
> 	total: 386 pass: 386 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for retesting this one so quickly.

greg k-h
