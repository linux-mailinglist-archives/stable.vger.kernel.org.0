Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6569C49D1A7
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbiAZSXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:23:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiAZSXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:23:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 842FEB81CB2;
        Wed, 26 Jan 2022 18:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3E3C340E8;
        Wed, 26 Jan 2022 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643221395;
        bh=HaUJ1DIE2otskZQOlUgdgj2w7ZNEAKjxKptjEmihFLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0Zvjnfhui5FMdjtb5lte4QaqQRgx213TGCnt9RHEhogh9jmymcCBifiOvTfnTK25
         66U3mWzaDsRqsrrQ3wucu5DlhR2PbIRaKpmeHUFf5fQxCyMNckTMJbE1XdQ4Sz8HwX
         eOB/9AwKDab2jUU7IeZyrXqZJ6+CbbTgUbbFU5/c=
Date:   Wed, 26 Jan 2022 19:23:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <YfGRkN5fGaVK2ZId@kroah.com>
References: <20220125155447.179130255@linuxfoundation.org>
 <20220126181346.GA105372@roeck-us.net>
 <YfGRAQ2+liyyljEb@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfGRAQ2+liyyljEb@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 07:20:49PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Jan 26, 2022 at 10:13:46AM -0800, Guenter Roeck wrote:
> > Hi Greg,
> > 
> > On Tue, Jan 25, 2022 at 05:33:08PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.16.3 release.
> > > There are 1033 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > I wasn't copied on this announcement nor on the announcement for v5.16.3-rc1.
> > Linaro wasn't copied either. I managed to catch it, but it would be great
> > if you could add me (and Linaro) back to cc.
> 
> Ouch, something went wrong, let me go see what changed in my scripts,
> very sorry about that...

Found the problem, this was the first set of -rc releases that we have
over 999 commits and the script was adding the cc: to "msg.000" not
"msg.0000".  I'll fix this up.

thanks,

greg k-h
