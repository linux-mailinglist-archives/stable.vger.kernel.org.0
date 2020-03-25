Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78934192FEC
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgCYRyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgCYRyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:54:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3F5C2077D;
        Wed, 25 Mar 2020 17:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158870;
        bh=cJ/j9bdZ1oPxw+aE1LUw5bu0E3LAREM2NIWTchBVsBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2IF1hNNjT8PhQ06g3uOmK1HOyuHC10CnFTQitRHpv86b/GOdZAum4RJrnCSciEWOW
         xq/BEVCK3MIWJQlh2+bsWeUKBizecrZpy48UnuUduJQ6Z/6uva0GzD4mY55HKv1pzl
         aKFKPHMpCssaNSDmk5fKBMp4xc6OtcybiR17lpzc=
Date:   Wed, 25 Mar 2020 18:54:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/119] 5.5.12-rc1 review
Message-ID: <20200325175427.GC3765240@kroah.com>
References: <20200324130808.041360967@linuxfoundation.org>
 <9e8c7d9d-cbed-7738-a6f6-c658b0adb542@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e8c7d9d-cbed-7738-a6f6-c658b0adb542@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 24, 2020 at 01:56:35PM -0700, Guenter Roeck wrote:
> On 3/24/20 6:09 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.12 release.
> > There are 119 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 428 pass: 428 fail: 0

Thanks ofr testinging all of these and letting me know.

greg k-h
