Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B8B2024B1
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgFTPGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 11:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFTPGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 11:06:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 009DD221F1;
        Sat, 20 Jun 2020 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592665584;
        bh=mxael5EIiTKAt9mB9+pdpud89LZpZ4EDu4JhH2UiTNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ydJWjeJwv9sIIRJ8z1VVN33wdlIb/mI0kh+8siMky5PVD/qtaj/d5hNWsC/oFIO+L
         j6BsKfKiQZjaseswrfxrlvNGV+azsxgLl9bLJQcTajS3gIdEFHuAFBAW0fwmtLhOro
         5CPKYdVSyI82lm4jk48Dw76RCBocuVT/usD7K+EE=
Date:   Sat, 20 Jun 2020 17:06:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/259] 5.4.48-rc2 review
Message-ID: <20200620150620.GD3170217@kroah.com>
References: <20200620082215.905874302@linuxfoundation.org>
 <01c4acf6-9f07-68af-3334-4b02a1e9c4a3@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c4acf6-9f07-68af-3334-4b02a1e9c4a3@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 20, 2020 at 06:29:25AM -0700, Guenter Roeck wrote:
> On 6/20/20 1:23 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.48 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 22 Jun 2020 08:21:26 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0

Wonderful, thanks for testing all of these and letting me know.

greg k-h
