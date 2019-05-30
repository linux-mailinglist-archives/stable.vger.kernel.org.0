Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D9030335
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 22:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfE3USz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 16:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3USz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 16:18:55 -0400
Received: from localhost (unknown [207.225.69.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45B326153;
        Thu, 30 May 2019 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559247535;
        bh=ceVcsPKIV2y+/b5zNkGiaYOU0XHWWX3tRD7gIIQNa5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARfkuACHy/E6tzx9n6XI5rSUxTdLebrRd78v1Q4G9lkZNZkCe4NsoZcnItbdaYUkP
         VjNG7FHoxg00oduWlIBFKePot/oBRvvpxWxGZULt+x2HAlwaLmfnJYsIAxe36hkWt9
         rVRgkfbrGT7agixSPEL0GGSygmZ6UuFMZZLVwscU=
Date:   Thu, 30 May 2019 13:18:54 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/405] 5.1.6-stable review
Message-ID: <20190530201854.GB816@kroah.com>
References: <20190530030540.291644921@linuxfoundation.org>
 <20190530183550.GB9720@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530183550.GB9720@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 11:35:50AM -0700, Guenter Roeck wrote:
> On Wed, May 29, 2019 at 07:59:58PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.6 release.
> > There are 405 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 01 Jun 2019 03:01:59 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
