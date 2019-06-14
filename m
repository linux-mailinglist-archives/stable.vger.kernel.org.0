Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8774544E
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 07:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfFNFvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 01:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfFNFvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 01:51:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8BF2133D;
        Fri, 14 Jun 2019 05:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560491479;
        bh=HupSjd11yAvr6+RX4xhnU6neJDD0iJF4+UlTvBQNwEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AhdSwqtQpHMw0xMfNzElbO6e0pjwiuj0cekBujQcwZ63+oigWTsHnWQM22JcUFm3A
         jvJSW4APsFCT+RcEW8RHxvNqbCo8RRkhv2j87eDJrDn5XvSueu2DUdKXVn6hLk9l7q
         2QKKdQII6dXiUI1Hp3IiYQGD/H91CkhwY4LYPQaA=
Date:   Fri, 14 Jun 2019 07:51:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
Message-ID: <20190614055116.GE27319@kroah.com>
References: <20190613075652.691765927@linuxfoundation.org>
 <1526e84e-a087-452c-7f00-ff7f70de0cf4@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526e84e-a087-452c-7f00-ff7f70de0cf4@roeck-us.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 13, 2019 at 01:03:08PM -0700, Guenter Roeck wrote:
> On 6/13/19 1:31 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.10 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 354 pass: 354 fail: 0

Great, thanks for testing and letting me know.

greg k-h
