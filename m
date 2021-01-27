Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D8830590C
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbhA0K7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 05:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231959AbhA0K5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 903A52074B;
        Wed, 27 Jan 2021 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611744993;
        bh=SBYnYjuYiKWziA1UaYv1e3bdv/LS8hXZt4gpUT6pA0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kfyh1mtXUTtdlxJu8WQLh/9ZZM/tZpcmWgTHneXYnB9+D3WYELwzAG5NRA6+QuEH5
         u+xCK5Z0D7QjID022a2mqw86cC1UK1sJjjHCT46iSns8dLC6ZvS0UINEDIQbUXuQOx
         pPsjel9XQtJdMdeY20/yi7wK0CTR0WAMOCRdbVdc=
Date:   Wed, 27 Jan 2021 11:56:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <YBFG3vzd8KliEs3/@kroah.com>
References: <20210126094313.589480033@linuxfoundation.org>
 <20210126192658.GC31936@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126192658.GC31936@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 11:26:58AM -0800, Guenter Roeck wrote:
> On Tue, Jan 26, 2021 at 11:03:12AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing.

greg k-h
