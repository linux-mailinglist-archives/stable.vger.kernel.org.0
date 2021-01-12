Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D6E2F39E1
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhALTSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:18:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbhALTSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 14:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 518FF2310A;
        Tue, 12 Jan 2021 19:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610479084;
        bh=kCAiNOl7dOTGNrymJiOeyjT1Bm8bEQoQxxvaZpNDk4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LDazS/qG4vLfCt5brZ57UYsCC44Waz++DmP6zUuNY2QlWlog523EgxGDuFdjk67C7
         2X22BbQTG2TOoP3NoO9HsC6z6CBBFIsP6j+WeUqSICqvHkSDKwEj+0631Q+czo17Dv
         XRmULPigoflg4228tmVvAt6N2bGiMX+4no+SwitU=
Date:   Tue, 12 Jan 2021 20:19:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/144] 5.10.7-rc2 review
Message-ID: <X/32MWGAAnO2dqm8@kroah.com>
References: <20210111161510.602817176@linuxfoundation.org>
 <20210111220326.GF56906@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111220326.GF56906@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 02:03:26PM -0800, Guenter Roeck wrote:
> On Mon, Jan 11, 2021 at 05:15:35PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.7 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Jan 2021 16:14:43 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all.

greg k-h
