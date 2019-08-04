Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B156809CA
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 09:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfHDHPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 03:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfHDHPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Aug 2019 03:15:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2402070D;
        Sun,  4 Aug 2019 07:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564902944;
        bh=dLmag7aq+BvGzFJ06j3fOE25hyRcx7tMj0ad4B1fZqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HlH0FIsJWFmivgUqDfuwUf+xsCL5TFi4zTYxkPsPmUnQMVEoN1w88fO5TrR0QTKTb
         4EI9bYs06I8wmDUPrTRFRt2sH/XsTLspW8Z0BddSEstCHeiG/+czaezuaOqSQTllNJ
         /hTy1++52zE6WAiKtANK5mKKOGIi6Pha3/WHME2I=
Date:   Sun, 4 Aug 2019 09:15:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/20] 5.2.6-stable review
Message-ID: <20190804071541.GA29188@kroah.com>
References: <20190802092055.131876977@linuxfoundation.org>
 <9492210e-e617-f636-d0f6-6a6381ad9461@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9492210e-e617-f636-d0f6-6a6381ad9461@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 03, 2019 at 09:00:11AM -0700, Guenter Roeck wrote:
> On 8/2/19 2:39 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Great!  Thanks for testing all of these and letting me know.

greg k-h
