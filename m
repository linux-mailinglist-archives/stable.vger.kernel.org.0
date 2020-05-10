Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392551CC7A7
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 09:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgEJHeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 03:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEJHeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 03:34:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 300D720801;
        Sun, 10 May 2020 07:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589096054;
        bh=ga2TeOqeHG7jn271obXjzKtTc+UJPjddCGS+woKggY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=thghNFdCYS9Ke65nRrcVT0L1sZaX9H6teqN+As8Nl/yVWGeOeizrycTcRhpEDYoT8
         GdAKEcq/fTjT43cr5vCAixlm70vONtWIMTr6wGx2CQKumWnFNtNMvwV3GWirHrNYt2
         JIPUA+6oNegaKhqiPcIxgiCZJY/zYc338mNxjpPA=
Date:   Sun, 10 May 2020 09:34:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/306] 4.4.223-rc3 review
Message-ID: <20200510073411.GB3474912@kroah.com>
References: <20200509064507.085696379@linuxfoundation.org>
 <2e986f85-e3c5-fa22-73cf-82c78db18663@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e986f85-e3c5-fa22-73cf-82c78db18663@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 09, 2020 at 06:17:05AM -0700, Guenter Roeck wrote:
> On 5/8/20 11:51 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.223 release.
> > There are 306 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 11 May 2020 06:44:14 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 169 pass: 169 fail: 0
> Qemu test results:
> 	total: 331 pass: 331 fail: 0

Wonderful, thanks for your help with this and testing all of the other
ones and letting me know.

greg k-h
