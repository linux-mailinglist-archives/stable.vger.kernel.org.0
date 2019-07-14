Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F138D67DA0
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 08:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfGNGCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 02:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfGNGCL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 02:02:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E6F20896;
        Sun, 14 Jul 2019 06:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563084130;
        bh=OpnHIPw3qEyVaoydOYQNEKaCB9QFb/q5rc/VC7y5GBM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LsZB6AbBZd5Zt9WKO5AE3Cw5c/kQ05ZUYx84+HGWThFaucC8TVVqPwqqLiIK3+Uqc
         KulrSE96H+w5arvp3PUSMTDwx5kV01x7HRh9fSeXgNmIIyrCZ/uJKY7HDwM0p3s2jY
         gIUos6HoGxxGD7SEUzh/ispF0Evo1wwNRfO1OiHg=
Date:   Sun, 14 Jul 2019 08:02:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190714060208.GC8005@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <7355803d-19e2-c05c-3573-13a280a98f30@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7355803d-19e2-c05c-3573-13a280a98f30@roeck-us.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 03:04:16PM -0700, Guenter Roeck wrote:
> On 7/12/19 5:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> 
> For v5.2-61-g0a498a7d2850:
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 364 pass: 364 fail: 0

Great, thanks for testing and letting me know.

greg k-h
