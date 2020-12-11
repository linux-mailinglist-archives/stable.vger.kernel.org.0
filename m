Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DF22D789C
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436896AbgLKPA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:60126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436862AbgLKPAW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:00:22 -0500
Date:   Fri, 11 Dec 2020 15:23:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607696525;
        bh=FBUVVSiPxsxyO4Yw8MHtE62MD7rlHAh45gZ3bz2Svh4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=G7asG2T3u2uBPia4Sc8W2CAkGFlbSuTcbVstDlHDaoHZ+wjZJ3CUcrbCQVBhEyv3a
         FKBZqsbC6PEliR2J3IdxPf85+UpXHGECmlhc/HEhax+uOMb27Iuu0MBRYrL/pq4Wx+
         vUg3iHgaE0BwXm48uwPaoVleR7LVZI3RrVyJEvs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
Message-ID: <X9OA0YuoD31gym9v@kroah.com>
References: <20201210142606.074509102@linuxfoundation.org>
 <20201210234623.GE259082@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210234623.GE259082@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 03:46:23PM -0800, Guenter Roeck wrote:
> On Thu, Dec 10, 2020 at 03:26:25PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.14 release.
> > There are 75 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 426 pass: 426 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing all of these and letting me know.

greg k-h
