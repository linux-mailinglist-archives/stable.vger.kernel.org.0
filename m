Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865AE67DA2
	for <lists+stable@lfdr.de>; Sun, 14 Jul 2019 08:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfGNGCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 02:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbfGNGCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 02:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2984020838;
        Sun, 14 Jul 2019 06:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563084156;
        bh=bzNPYjZiYP2C43roZZG0B6jvu1WA5UVesQC/XDKr7bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xyWC/GWmlzyhYOdZt5cQ6h4AnttfjGpHELLYdmjlHz5C6QvtSB580Lu/cdqN4TUSB
         tkK67TJMYa/CHe8XT0ciGUUB8tLWplvJaoZ0gOQ4zjEf5lyWMhSKHUelp3CVJssb2W
         qfFqQ0suiCgm9ZEGA6107+VSqvvt+9kBTFlfUPy4=
Date:   Sun, 14 Jul 2019 08:02:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190714060234.GD8005@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <20190713203751.GA14762@luke-XPS-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713203751.GA14762@luke-XPS-13>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 01:37:51PM -0700, Luke Nowakowski-Krijger wrote:
> On Fri, Jul 12, 2019 at 02:19:13PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my x86_64 system. No dmesg regressions. 

Thanks for testing all of these and letting me know.

greg k-h
