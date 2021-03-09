Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38A3322F8
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhCIK0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:26:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhCIK0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:26:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8219365267;
        Tue,  9 Mar 2021 10:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615285599;
        bh=3wWSlQQbPApXMLVkFwkTLSFS0diGnhMS1RBkqHtwf38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yuiV8HnBSMGUCXYiUUarSqMO9DIUSLV8xg6Eg88hd8aAKQOqQGzgaSK97SxyTMMVg
         WIlEGQ7AnLfI+GhuXAbLkhJRYRyu/8bx+M7O/AG4w4uL+X7oXnzt+kZK9+2sljwPgf
         HtNWZifhdo1/TIftpsu0+brujjr8j6M5bjqJrIbM=
Date:   Tue, 9 Mar 2021 11:26:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
Message-ID: <YEdNXBiRcw61IQQQ@kroah.com>
References: <20210308122718.586629218@linuxfoundation.org>
 <20210308222953.GC185990@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308222953.GC185990@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 02:29:53PM -0800, Guenter Roeck wrote:
> On Mon, Mar 08, 2021 at 01:34:38PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.5 release.
> > There are 44 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 435 pass: 435 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

thanks for testing them all.

greg k-h
