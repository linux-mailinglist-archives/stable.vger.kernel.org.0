Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA502DFC17
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 13:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLUM7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 07:59:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgLUM7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 07:59:09 -0500
Date:   Mon, 21 Dec 2020 13:59:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608555508;
        bh=ldIcp+aDbNJoC683BEt7JraLLmc67Ag6UIQ8V6ET4Jo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4gVSv7134UcRPv/8xsjHXMj/4t64uJS65aSWQ5fD/96/xCnERDORADHswzV704Pv
         rteCdXVWWMR+lHjzb7cPHDbRD7FeyXXUsUuTfORib0VIkvaaTsKK/SlOxgCujQvBGC
         JK1SYdqvTsmfO+kYcFis1IPVIbz3+WrDr+fvJubo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
Message-ID: <X+CcQBLXWfyiatqt@kroah.com>
References: <20201219125339.066340030@linuxfoundation.org>
 <20201219215008.GC22593@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219215008.GC22593@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 01:50:08PM -0800, Guenter Roeck wrote:
> On Sat, Dec 19, 2020 at 01:57:07PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.2 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing these and letting me know.

greg k-h
