Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A186315F8A3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 22:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388649AbgBNVSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 16:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbgBNVSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 16:18:36 -0500
Received: from localhost (unknown [65.119.211.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 717AB24649;
        Fri, 14 Feb 2020 21:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581715115;
        bh=Uzqk7dvc4/so2Sog967beDxTUsqE4HY78f8gCHtW3E0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gd9hl6T29dSfp+Ymf5tBk+eXTpiKOpAaz1aRaAftfpj1WGd5bRva4vBPsnlsbWE6I
         jGqXgfx66wr2IKNS0lvwUZS9D/0anYiblydM2dInJ2hDrqia3rY9pzspf/CavA/Z2h
         kKAyBMGrfsKLDocdFBi3CJKh4eckzaXMGtGTD0O4=
Date:   Fri, 14 Feb 2020 16:18:07 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214211807.GB4144398@kroah.com>
References: <20200213151901.039700531@linuxfoundation.org>
 <20200214162829.GD18488@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214162829.GD18488@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 08:28:29AM -0800, Guenter Roeck wrote:
> On Thu, Feb 13, 2020 at 07:19:56AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.4 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.5.3-121-ged6d023a1817:
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 400 pass: 400 fail: 0

Great, thanks for testing all of these and letting me know.

greg k-h
