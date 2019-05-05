Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24613E14
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 09:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEEHLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 03:11:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbfEEHLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 03:11:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D10F2087F;
        Sun,  5 May 2019 07:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557040312;
        bh=rAH2tC2KoywMsPCwkRNKA7zIFO+HNkloGfJW+qDuCp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kkKgj313FVHZSUjHuUNDOyGNObeXaZcfMfKDvk3n7laJIQ+DpcobRi+c1jxNm7MSq
         MdrS9YpMIkXGg33c9wJhHW3xEZTdSBLTgGcJ0yvv/vKq5qDQWeDUd/DjjImbiG8vGc
         xk+B4rusk/Xm7R73NQiCPsU0rVlrOQVPRB88uXds=
Date:   Sun, 5 May 2019 09:11:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/32] 5.0.13-stable review
Message-ID: <20190505071149.GB3895@kroah.com>
References: <20190504102452.523724210@linuxfoundation.org>
 <7e81d963-68b5-40ba-6e49-4fdee5e2bb61@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e81d963-68b5-40ba-6e49-4fdee5e2bb61@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 04:53:10PM -0700, Guenter Roeck wrote:
> On 5/4/19 3:24 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.0.13 release.
> > There are 32 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon 06 May 2019 10:24:23 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 349 pass: 349 fail: 0

Thanks for testing both of these and letting me know.

greg k-h
