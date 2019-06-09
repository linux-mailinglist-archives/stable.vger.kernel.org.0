Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB03C3A41D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfFIHQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 03:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfFIHQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 03:16:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD8BE208C0;
        Sun,  9 Jun 2019 07:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560064612;
        bh=fyOlrHNADm1YRUwsAyOFV8WpxPCrlr0sk31fPt+Sa5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K5E+VzDeR5gwLuifXyZ+6eS3FihfE60OELHPK5tunwXw4ZBWNBmp2xsu+t9+Ua9EF
         XLtL3SVBLQ9lC3E1nk9z6X9bXeOUTIzuVvJt8MOTq4075PSdxKeC3IQuJvhw8yF/mr
         dokBpsNdKdM7dDeetMYbe0UoLUbno8peQM9PaKBs=
Date:   Sun, 9 Jun 2019 09:16:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/85] 5.1.8-stable review
Message-ID: <20190609071649.GB4565@kroah.com>
References: <20190607153849.101321647@linuxfoundation.org>
 <1e5e5424-c888-bb1a-8e70-cc23847ed87b@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e5e5424-c888-bb1a-8e70-cc23847ed87b@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 08, 2019 at 11:50:30AM -0700, Guenter Roeck wrote:
> On 6/7/19 8:38 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.8 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 09 Jun 2019 03:37:09 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 351 pass: 351 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
