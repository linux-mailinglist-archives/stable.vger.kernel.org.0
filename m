Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4437B2FCEBF
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbhATLCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733262AbhATKjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9CEF2333D;
        Wed, 20 Jan 2021 10:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611139079;
        bh=VKkMtUBJLuvfBDm+gK6YI/CI58lIyBVOOWidcbaNCFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=veVsc6bEOdXOlvSFghBelW5MZY29hcuLdgWL3+JNBYxszcBMbPIsJHs5vuP2fgucZ
         TXADS/F9WQh8lSYut91xoat8TVnDHmxCJce/8clbfFuyXJ3FaCe04UTtdqMbs67Z+7
         M9mnPzP26yY3HOoBnuIbIMCIh3VTMigqG0KimktI=
Date:   Wed, 20 Jan 2021 11:37:56 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
Message-ID: <YAgIBElD4TOomzU9@kroah.com>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210119144229.GC54031@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119144229.GC54031@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 06:42:29AM -0800, Guenter Roeck wrote:
> On Mon, Jan 18, 2021 at 12:32:55PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.9 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Great, thanks for testing and letting me know.

greg k-h
