Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EB018DE67
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgCUHLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgCUHLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70DDA20739;
        Sat, 21 Mar 2020 07:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774665;
        bh=3ygXSoTaoRXGYCDm4Jd2huUox9ORD81Lz2OJy7zKBoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zg361lUkt3sE8c2J0asZEEK62boHms3WGJd6bKI9xQux8cb3pd5ptMVqdrvQEBAJY
         xd0kwCSndxD2O2rQfsnbLSqtg6hGmCtVNiXx0Mn8/Vc4deed187uB7ozk7PUk33Quw
         P2+I/HTMaBNNb1XN6L8f1qp5Z1RSnNspyHv4QXZo=
Date:   Sat, 21 Mar 2020 08:11:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/54] 5.5.11-rc3 review
Message-ID: <20200321071103.GD850676@kroah.com>
References: <20200320113335.277810029@linuxfoundation.org>
 <53e0e115-6d12-1f1e-518c-26ae2ec5c2b1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53e0e115-6d12-1f1e-518c-26ae2ec5c2b1@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 20, 2020 at 11:00:29AM -0700, Guenter Roeck wrote:
> On 3/20/20 4:34 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.11 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 22 Mar 2020 11:32:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.5.10-55-gbea94317c526:
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
