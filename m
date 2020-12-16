Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1874E2DBDE9
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 10:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgLPJqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 04:46:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgLPJqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 04:46:44 -0500
Date:   Wed, 16 Dec 2020 10:47:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608111963;
        bh=7ZBc09cMn7kyUBcEhIPNYojljA/qZxXDcD7jHyUGB1A=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLYmDXUdsc835/A6QTTHr/lpuOW83SFRMOLrjYJWnTvp+Z/bNj8pbjspxsavaSGl2
         waE9kEBPiS90K4gP6RLCtBsn1sUhncw+RPjFWhEwfOmLwDEKMIrcBJ+/5YuLmgfC+b
         wGiKUjINE4YxaYipv/3yaRvsNuzvjiu/QrcnA+dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
Message-ID: <X9nXmIqZhUFnyDyg@kroah.com>
References: <20201214170452.563016590@linuxfoundation.org>
 <20201215203226.GC188376@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215203226.GC188376@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 12:32:26PM -0800, Guenter Roeck wrote:
> On Mon, Dec 14, 2020 at 06:06:09PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.1 release.
> > There are 2 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing!
greg k-h
