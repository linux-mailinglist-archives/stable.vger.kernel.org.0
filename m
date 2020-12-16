Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E79A2DC119
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgLPNU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgLPNU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:20:56 -0500
Date:   Wed, 16 Dec 2020 14:21:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608124815;
        bh=Eq7A2BL0FI2mKs5iwlVvM21Z7VyRHX2MIWDxFYx1UJQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKujheRxg2tIC5U8jHMy6cHhM2DT5mNxX1v+OYD5HEmLyVcU2DKerCW204TlWENvv
         Gaq+6PJlubWCBfDzavcwoBkK2jYJxW6rqEpj5uf/bqipf1xxNGqeQe6sRhiCfA0Esc
         h+DEFtp4RYgkhPSh3e4+DUqkhxzc4sQCtC3ymwE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
Message-ID: <X9oJzPFCn8mlIRNE@kroah.com>
References: <20201214172555.280929671@linuxfoundation.org>
 <20201215203201.GB188376@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215203201.GB188376@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 12:32:01PM -0800, Guenter Roeck wrote:
> On Mon, Dec 14, 2020 at 06:27:34PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.15 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
