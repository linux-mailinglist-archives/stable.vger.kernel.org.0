Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A614A30E6A7
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhBCXEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhBCXEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:04:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FE1B64E38;
        Wed,  3 Feb 2021 23:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393439;
        bh=+j96CcnNPqtxUEz9+6D2M/LizfXJWiujKz3lb2cnFY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vGWBlVlIJNdhu1Ju9CdYY44qdcQs+NK84CWQejv58SfyU9aqIxwgOSVtB6raA/yKa
         lRk/2wWg/vZ9O06eGJTCRVAoXkKWq+NAiODI8yVlkXx70U2X64Eyxa8VnO/dX5DgaY
         xiiLqKVVEVHTQUU5FFx97XT+y4wmUb+BxDC2t+f4=
Date:   Thu, 4 Feb 2021 00:03:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <YBsr3Dtk1HXNWpuX@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <20210203204258.GF106766@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203204258.GF106766@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 12:42:58PM -0800, Guenter Roeck wrote:
> On Tue, Feb 02, 2021 at 02:36:03PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.13 release.
> > There are 142 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
